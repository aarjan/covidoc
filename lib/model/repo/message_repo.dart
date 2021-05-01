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

  Future<AppUser> getUser() async {
    return sessionRepo.getUser();
  }

  Future<List<Chat>> loadChats(List<String> chatIds) async {
    if (chatIds == null || chatIds.isEmpty) {
      return [];
    }

    final firestore = FirebaseFirestore.instance;
    final msgRef = await firestore
        .collection('chat')
        .where(FieldPath.documentId, whereIn: chatIds)
        .get();

    if (msgRef == null || msgRef.docs.isEmpty) {
      return [];
    }
    final msgs = msgRef.docs.map((m) => Chat.fromJson(m.data())).toList();
    return msgs;
  }

  Future<List<Message>> loadMessages(String chatId) async {
    final firestore = FirebaseFirestore.instance;
    final msgRef = await firestore.collection('chat/$chatId/message').get();
    if (msgRef == null || msgRef.docs.isEmpty) {
      return [];
    }
    final msgs = msgRef.docs.map((m) => Message.fromJson(m.data())).toList();
    return msgs;
  }

  Future<String> startConversation({Chat chat}) async {
    final firestore = FirebaseFirestore.instance;
    final cRef = await firestore.collection('chat').add(chat.toJson());
    await firestore.doc('chat/${cRef.id}').update({'id': cRef.id});
    return cRef.id;
  }

  Future<void> addUserChatRecord(
      {String fromUserId, String toUserId, String chatId}) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.doc('user/$fromUserId').update({
      'chatIds': FieldValue.arrayUnion([chatId]),
      'chatUsers': FieldValue.arrayUnion([toUserId])
    });
  }

  Future<void> cacheUserChatRecord(
      AppUser user, String toUserId, String chatId) async {
    final nUser = user.copyWith(
      chatIds: [...user.chatIds, chatId],
      chatUsers: [...user.chatUsers, toUserId],
    );
    await sessionRepo.cacheUser(nUser);
  }

  Future<Message> sendMessage(Message msg) async {
    final firestore = FirebaseFirestore.instance;
    final mRef = await firestore
        .collection('chat/${msg.chatId}/message')
        .add(msg.toJson());
    return msg.copyWith(id: mRef.id);
  }

  Future<void> updateLastMsg(String chatId, String msg) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.doc('chat/$chatId').update({
      'lastMessage': msg,
      'lastTimestmap': DateTime.now().toIso8601String()
    });
  }

  Future<void> editMessage({Message msg}) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .doc('chat/${msg.chatId}/message/${msg.id}')
        .update(msg.toJson());
  }

  Future<void> deleteMessage({String msgId, String chatId}) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.doc('chat/$chatId/message/$msgId').delete();
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
