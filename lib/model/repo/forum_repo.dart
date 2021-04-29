import 'package:covidoc/model/entity/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidoc/model/repo/session_repo.dart';

class ForumRepo {
  final SessionRepository sessionRepo;

  ForumRepo(this.sessionRepo);

  Future<List<Forum>> getForums() async {
    final firestore = FirebaseFirestore.instance;
    final fRef = await firestore.collection('forum').limit(20).get();
    if (fRef != null && fRef.docs.isNotEmpty) {
      return fRef.docs
          ?.map((e) =>
              e == null ? null : Forum.fromJson(e as Map<String, dynamic>))
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

  Future<void> addAnswer(Answer answer) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('forum')
        .doc(answer.questionId)
        .collection('answer')
        .add(answer.toJson());
  }

  Future<void> updateAnswer(Answer answer) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('forum')
        .doc(answer.questionId)
        .collection('answer')
        .doc(answer.id)
        .update(answer.toJson());
  }
}
