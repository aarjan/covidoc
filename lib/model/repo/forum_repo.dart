import 'dart:io';

import 'package:covidoc/model/entity/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidoc/model/repo/session_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ForumRepo {
  final SessionRepository sessionRepo;

  ForumRepo(this.sessionRepo);

  Future<List<Forum>> getForums({String? category, int? createdAt}) async {
    final firestore = FirebaseFirestore.instance;
    var query = firestore.collection('forum').limit(10);

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    query = query.orderBy('createdAt', descending: true);

    // paginate
    if (createdAt != null) {
      query = query.startAfter([createdAt]);
    }

    final fRef = await query.get();

    if (fRef.docs.isNotEmpty) {
      return fRef.docs
          .map((e) => Forum.fromJson(e.data()).copyWith(id: e.id))
          .toList();
    }
    return [];
  }

  Future<List<Answer>> getAnswers({String? questionId, int? createdAt}) async {
    final firestore = FirebaseFirestore.instance;
    var query = firestore
        .collection('forum/$questionId/answer')
        .limit(10)
        .orderBy('createdAt', descending: false);

    // paginate
    if (createdAt != null) {
      query = query.startAfter([createdAt]);
    }

    final fRef = await query.get();

    if (fRef.docs.isNotEmpty) {
      return fRef.docs
          .map((e) => Answer.fromJson(e.data()).copyWith(id: e.id))
          .toList();
    }
    return [];
  }

  Future<Forum> addForum(Forum forum) async {
    final firestore = FirebaseFirestore.instance;
    final fRef = await firestore.collection('forum').add(forum.toJson());
    return forum.copyWith(id: fRef.id);
  }

  Future<void> updateForum(Forum forum) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('forum').doc(forum.id).update(forum.toJson());
  }

  Future<void> delQuestion(String? questionId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.doc('forum/$questionId').delete();
  }

  Future<Answer> addAnswer(Answer answer, bool addAvatar) async {
    final firestore = FirebaseFirestore.instance;
    final aRef = await firestore
        .collection('forum/${answer.questionId}/answer')
        .add(answer.toJson());

    // increase the answer count & recentUsersAvatar
    final avatars = addAvatar ? [answer.addedByAvatar] : [];
    await firestore.doc('forum/${answer.questionId}').update({
      'ansCount': FieldValue.increment(1),
      'recentUsersAvatar': FieldValue.arrayUnion(avatars),
    });
    return answer.copyWith(id: aRef.id);
  }

  Future<void> delAnswer(String? questionId, String? answerId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.doc('forum/$questionId/answer/$answerId').delete();

    // increase the answer count
    await firestore
        .doc('forum/$questionId')
        .update({'ansCount': FieldValue.increment(-1)});
  }

  Future<void> updateAnswer(Answer answer) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .doc('forum/${answer.questionId}/answer/${answer.id}')
        .update(answer.toJson());
  }

  Future<String> uploadImage(File img) async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('image${DateTime.now().toUtc()}');
    final res = await ref.putFile(img);
    return res.ref.getDownloadURL();
  }

  Future<AppUser?> getUser() async {
    return sessionRepo.getUser();
  }

  Future<void> reportPost({
    required String report,
    required Map<String, String> details,
    required String reportType,
  }) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('report').add({
      'report': report,
      'details': details,
      'reportType': reportType,
    });
  }
}
