import 'dart:io';

import 'package:covidoc/model/entity/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidoc/model/repo/session_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ForumRepo {
  final SessionRepository sessionRepo;

  ForumRepo(this.sessionRepo);

  Future<List<Forum>> getForums() async {
    final firestore = FirebaseFirestore.instance;
    final fRef = await firestore
        .collection('forum')
        .limit(20)
        .orderBy('updatedAt', descending: true)
        .get();
    if (fRef != null && fRef.docs.isNotEmpty) {
      return fRef.docs
          ?.map((e) => e == null ? null : Forum.fromJson(e.data()))
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
          ?.map((e) => e == null ? null : Answer.fromJson(e.data()))
          ?.toList();
    }
    return [];
  }

  Future<Forum> addForum(Forum forum) async {
    final firestore = FirebaseFirestore.instance;
    final fRef = await firestore.collection('forum').add(forum.toJson());
    await firestore.doc('forum/${fRef.id}').update({'id': fRef.id});
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
    await firestore
        .doc('forum/${answer.questionId}/answer/${aRef.id}')
        .update({'id': aRef.id});

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
