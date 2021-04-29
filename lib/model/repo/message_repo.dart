import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/session_repo.dart';

class MessageRepo {
  SessionRepository sessionRepo;

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
