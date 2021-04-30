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

  Future<List<Chat>> loadChats(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final msgRef =
        await firestore.collection('user/$userId/chat').limit(10).get();

    if (msgRef == null || msgRef.docs.isEmpty) {
      return [];
    }
    final msgs = msgRef.docs.map((m) => Chat.fromJson(m.data())).toList();
    return msgs;
  }

  Future<List<Message>> loadMessages(String fromUserId, String toUserId) async {
    final firestore = FirebaseFirestore.instance;
    final msgRef = await firestore
        .collection('user/$fromUserId/chat/$toUserId/message')
        .get();
    if (msgRef == null || msgRef.docs.isEmpty) {
      return [];
    }
    final msgs = msgRef.docs.map((m) => Message.fromJson(m.data())).toList();
    return msgs;
  }

  Future<void> startConversation(
      {Chat chat, String fromUserId, String toUserId}) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.doc('user/$fromUserId/chat/$toUserId').set(chat.toJson());
  }

  Future<Message> sendMessage(
      Message msg, String fromUserId, String toUserId) async {
    final firestore = FirebaseFirestore.instance;
    final mRef = await firestore
        .collection('user/$fromUserId/chat/$toUserId/message')
        .add(msg.toJson());
    return msg.copyWith(id: mRef.id);
  }

  Future<void> updateLastMsg(
      String fromUserId, String chatId, String msg) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('user/$fromUserId/chat').doc(chatId).update({
      'lastMessage': msg,
      'lastTimestmap': DateTime.now().toIso8601String()
    });
  }

  Future<void> editMessage(
      Message msg, String fromUserId, String toUserId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('user/$fromUserId/chat/$toUserId/message')
        .doc(msg.id)
        .update(msg.toJson());
  }

  Future<void> deleteMessage(
      Message msg, String fromUserId, String toUserId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('user/$fromUserId/chat/$toUserId/message')
        .doc(msg.id)
        .delete();
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
