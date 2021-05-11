import 'dart:io';

import 'package:covidoc/model/entity/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidoc/model/repo/session_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ForumRepo {
  final SessionRepository sessionRepo;

  ForumRepo(this.sessionRepo);

  Future<List<Forum>> getForums({String category}) async {
    final firestore = FirebaseFirestore.instance;
    var query = firestore.collection('forum').limit(20);

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    final fRef = await query.orderBy('createdAt', descending: true).get();

    if (fRef != null && fRef.docs.isNotEmpty) {
      return fRef.docs
          ?.map((e) =>
              e == null ? null : Forum.fromJson(e.data()).copyWith(id: e.id))
          ?.toList();
    }
    return [];
  }

  Future<List<Answer>> getAnswers(String questionId) async {
    final firestore = FirebaseFirestore.instance;
    final fRef = await firestore
        .collection('forum/$questionId/answer')
        .limit(20)
        .orderBy('updatedAt', descending: false)
        .get();

    if (fRef != null && fRef.docs.isNotEmpty) {
      return fRef.docs
          ?.map((e) =>
              e == null ? null : Answer.fromJson(e.data()).copyWith(id: e.id))
          ?.toList();
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

  Future<void> delQuestion(String questionId) async {
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

  Future<void> delAnswer(String questionId, String answerId) async {
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
    final ref = storage.ref().child('image${DateTime.now()}');
    final res = await ref.putFile(img);
    return res.ref.getDownloadURL();
  }

  Future<AppUser> getUser() async {
    return sessionRepo.getUser();
  }
}
