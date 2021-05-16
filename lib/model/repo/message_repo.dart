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
    final msgRef = firestore.collection('chat');

    final chats = <Chat>[];
    for (final id in chatIds) {
      final doc = await msgRef.doc(id).get();
      if (doc != null && doc.exists) {
        chats.add(Chat.fromJson(doc.data()).copyWith(id: doc.id));
      }
    }
    if (chats.isEmpty) {
      return [];
    }
    return chats;
  }

  // MessageRequests made by the patient
  Future<List<MessageRequest>> loadMsgRequestsByUser(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final msgRef = await firestore
        .collection('messageRequest')
        .where('postedBy', isEqualTo: userId)
        .where('resolved', isEqualTo: false)
        .get();

    if (msgRef == null || msgRef.docs.isEmpty) {
      return [];
    }
    final reqs = msgRef.docs
        .map((m) => m == null
            ? null
            : MessageRequest.fromJson(m.data()).copyWith(id: m.id))
        .toList();
    return reqs;
  }

  // MessageRequests made by different patients -> for doctors
  Future<List<MessageRequest>> loadRequests({limit = 10, offset = 0}) async {
    final firestore = FirebaseFirestore.instance;
    final mRef = await firestore
        .collection('messageRequest')
        .where('resolved', isEqualTo: false)
        .limit(limit)
        .get();
    if (mRef == null || mRef.docs.isEmpty) {
      return [];
    }
    return mRef.docs
        .map((m) => m == null
            ? null
            : MessageRequest.fromJson(m.data()).copyWith(id: m.id))
        .toList();
  }

  Future<List<Message>> loadMessages(String chatId, {int lastTimestamp}) async {
    final firestore = FirebaseFirestore.instance;
    var query = firestore
        .collection('chat/$chatId/message')
        .limit(10)
        .orderBy('timestamp', descending: true);

    if (lastTimestamp != null) {
      query = query.startAfter([lastTimestamp]);
    }

    final msgRef = await query.get();

    if (msgRef == null || msgRef.docs.isEmpty) {
      return [];
    }
    final msgs = msgRef.docs
        .map((m) =>
            m == null ? null : Message.fromJson(m.data()).copyWith(id: m.id))
        .toList();
    return msgs;
  }

  Stream<QuerySnapshot> messageSubscription(String chatId,
      {int lastTimestamp}) {
    final firestore = FirebaseFirestore.instance;
    var query = firestore
        .collection('chat/$chatId/message')
        .limit(10)
        .orderBy('timestamp', descending: true);

    if (lastTimestamp != null) {
      query = query.startAfter([lastTimestamp]);
    }
    return query.snapshots();
  }

  Future<String> sendMsgRequest({MessageRequest request}) async {
    final firestore = FirebaseFirestore.instance;
    final mRef =
        await firestore.collection('messageRequest').add(request.toJson());
    return mRef.id;
  }

  Future<void> resolveMsgRequest(
      {String requestId, String docId, Map<String, dynamic> docDetail}) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.doc('messageRequest/$requestId').update({
      'docId': docId,
      'resolved': true,
      'docDetail': docDetail,
    });
  }

  Future<String> startConversation({Chat chat}) async {
    final firestore = FirebaseFirestore.instance;
    final cRef = await firestore.collection('chat').add(chat.toJson());
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
      'lastTimestmap': DateTime.now().toUtc().millisecondsSinceEpoch,
    });
  }

  Future<void> editMessage({Message msg}) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .doc('chat/${msg.chatId}/message/${msg.id}')
        .update(msg.toJson());
  }

  Future<void> deleteMessage({List<String> msgIds, String chatId}) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    for (final id in msgIds) {
      batch.delete(firestore.doc('chat/$chatId/message/$id'));
    }
    await batch.commit();
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

  Future<String> uploadImage(File img) async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('image${DateTime.now().toUtc()}');
    final res = await ref.putFile(img);
    return res.ref.getDownloadURL();
  }

  Future<String> uploadAudio(File img) async {
    final storage = FirebaseStorage.instance;
    final fileName = img.path.substring(img.path.lastIndexOf('/') + 1);

    final ref = storage.ref().child('audio/$fileName');
    final res = await ref.putFile(img);
    return res.ref.getDownloadURL();
  }
}
