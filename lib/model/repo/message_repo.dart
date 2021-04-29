import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/session_repo.dart';

class MessageRepo {
  final SessionRepository sessionRepo;

  MessageRepo(this.sessionRepo);

  Future<String> getUserId() async {
    final user = await sessionRepo.getUser();
    return user?.id;
  }

  Future<List<Message>> loadMsg(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final msgRef = await firestore
        .collection('user')
        .doc(userId)
        .collection('message')
        .limit(10)
        .get();
    if (msgRef == null || msgRef.docs.isEmpty) {
      return [];
    }
    final msgs = msgRef.docs.map((m) => Message.fromJson(m.data())).toList();
    return msgs;
  }

  Future<void> startMessage(Message msg) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('message').add(msg.toJson());
  }

  Future<void> editMessage(Message msg) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('message').doc(msg.id).update(msg.toJson());
  }

  Future<void> deleteMessage(Message msg) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('message').doc(msg.id).delete();
  }

  Future<void> uploadFile(String fileName) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDocDir.absolute}/$fileName';

    final file = File(filePath);
    try {
      final task =
          await FirebaseStorage.instance.ref('uploads/$fileName').putFile(file);
      log(task.toString());
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message);
      // e.g, e.code == 'canceled'
    }
  }
}
