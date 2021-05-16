import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:covidoc/model/repo/repo.dart';
import 'package:covidoc/model/entity/entity.dart';

class MessageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateData extends MessageEvent {
  final List<Message> data;
  final String chatId;

  UpdateData(this.data, this.chatId);

  @override
  List<Object> get props => [data, chatId];
}

class SubscribeMsg extends MessageEvent {
  final String chatId;

  SubscribeMsg({this.chatId});

  @override
  List<Object> get props => [chatId];
}

class LoadMsgs extends MessageEvent {
  final String chatId;

  LoadMsgs({this.chatId});

  @override
  List<Object> get props => [chatId];
}

class EditMsg extends MessageEvent {
  final Message msg;

  EditMsg(this.msg);

  @override
  List<Object> get props => [msg];
}

class DeleteMsg extends MessageEvent {
  final String chatId;
  final List<String> msgIds;

  DeleteMsg({this.msgIds, this.chatId});

  @override
  List<Object> get props => [msgIds, chatId];
}

class SendMsg extends MessageEvent {
  final Message msg;
  final List<Photo> images;

  SendMsg({this.msg, this.images});

  @override
  List<Object> get props => [msg, images];
}

class MessageState extends Equatable {
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoadInProgress extends MessageState {}

class MessageLoadSuccess extends MessageState {
  final String chatId;
  final bool hasReachedEnd;
  final List<Message> msgs;

  MessageLoadSuccess({this.msgs, this.chatId, this.hasReachedEnd = false});

  @override
  List<Object> get props => [msgs, chatId, hasReachedEnd];

  MessageLoadSuccess copyWith(
      {List<Message> msgs, String chatId, bool hasReachedEnd}) {
    return MessageLoadSuccess(
      msgs: msgs ?? this.msgs,
      chatId: chatId ?? this.chatId,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepo repo;
  StreamSubscription<QuerySnapshot> subscription;

  MessageBloc({this.repo}) : super(MessageInitial());

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    switch (event.runtimeType) {
      case SubscribeMsg:
        yield* _mapSubscribeMsgEventToState(event);
        break;
      case UpdateData:
        yield* _mapUpdateDataEventToState(event);
        break;
      case LoadMsgs:
        yield* _mapLoadMsgsEventToState(event);
        break;
      case SendMsg:
        yield* _mapSendMsgEventToState(event);
        break;
      case EditMsg:
        yield* _mapEditMsgEventToState(event);
        break;
      case DeleteMsg:
        yield* _mapDeleteMsgEventToState(event);
        break;
      default:
    }
  }

  Stream<MessageState> _mapSubscribeMsgEventToState(SubscribeMsg event) async* {
    // return if subscribed already
    if (state is MessageLoadSuccess &&
        subscription != null &&
        (state as MessageLoadSuccess).chatId == event.chatId) {
      return;
    }

    yield MessageLoadInProgress();

    // cancel pervious subscription
    await subscription?.cancel();

    subscription = repo.messageSubscription(event.chatId).listen((msgEvent) {
      final msgs = msgEvent.docs
          .map((e) => Message.fromJson(e.data()).copyWith(id: e.id))
          .toList();
      add(UpdateData(msgs, event.chatId));
    });
  }

  Stream<MessageState> _mapUpdateDataEventToState(UpdateData event) async* {
    yield MessageLoadSuccess(msgs: event.data, chatId: event.chatId);
  }

  Stream<MessageState> _mapLoadMsgsEventToState(LoadMsgs event) async* {
    // start of conversation
    if (event.chatId == null) {
      yield MessageLoadSuccess(msgs: []);
      return;
    }
    if (state is MessageLoadSuccess &&
        (state as MessageLoadSuccess).chatId == event.chatId) {
      final curState = (state as MessageLoadSuccess);

      // If currentState has no message
      // OR, currentState has reached end of the message list
      if (curState.msgs.isEmpty || curState.hasReachedEnd) {
        return;
      }

      yield MessageLoadInProgress();
      final msgs = await repo.loadMessages(event.chatId,
          lastTimestamp: curState.msgs.last.timestamp.millisecondsSinceEpoch);

      yield curState.copyWith(
          msgs: [...curState.msgs, ...msgs], hasReachedEnd: msgs.isEmpty);

      return;
    }

    yield MessageLoadInProgress();
    final msgs = await repo.loadMessages(event.chatId);
    yield MessageLoadSuccess(msgs: msgs, chatId: event.chatId);
  }

  Stream<MessageState> _mapSendMsgEventToState(SendMsg event) async* {
    if (state is MessageLoadSuccess) {
      yield MessageLoadInProgress();

      // Add images
      final documents = <String>[];
      for (final f in event.images) {
        if (event.msg.msgType == MessageType.Audio) {
          final url = await repo.uploadAudio(f.file);
          documents.add(url);
        } else {
          final url = await repo.uploadImage(f.file);
          documents.add(url);
        }
      }
      final nMsg = event.msg.copyWith(documents: documents);

      await repo.sendMessage(nMsg);
      await repo.updateLastMsg(event.msg.chatId, event.msg.message);

      // final nMsgs = List<Message>.from([msg, ...curState.msgs]);
      // yield MessageLoadSuccess(msgs: nMsgs);
    }
  }

  Stream<MessageState> _mapEditMsgEventToState(EditMsg event) async* {
    if (state is MessageLoadSuccess) {
      final curMsgs = (state as MessageLoadSuccess).msgs;

      yield MessageLoadInProgress();

      await repo.editMessage(msg: event.msg);

      final newMsgs =
          curMsgs.map((m) => m.id == event.msg.id ? event.msg : m).toList();

      yield MessageLoadSuccess(msgs: newMsgs);
    }
  }

  Stream<MessageState> _mapDeleteMsgEventToState(DeleteMsg event) async* {
    if (state is MessageLoadSuccess) {
      final curMsgs = (state as MessageLoadSuccess).msgs;

      yield MessageLoadInProgress();

      await repo.deleteMessage(chatId: event.chatId, msgIds: event.msgIds);

      final newMsgs =
          curMsgs.where((m) => !event.msgIds.contains(m.id)).toList();

      yield MessageLoadSuccess(msgs: newMsgs);
    }
  }
}
