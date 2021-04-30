import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadMsgs extends MessageEvent {
  final String fromUserId;
  final String toUserId;

  LoadMsgs(this.fromUserId, this.toUserId);

  @override
  List<Object> get props => [fromUserId, toUserId];
}

class EditMsg extends MessageEvent {
  final Message msg;

  EditMsg(this.msg);

  @override
  List<Object> get props => [msg];
}

class DeleteMsg extends MessageEvent {
  final Message msg;

  DeleteMsg(this.msg);

  @override
  List<Object> get props => [msg];
}

class SendMsg extends MessageEvent {
  final Message msg;

  SendMsg(this.msg);

  @override
  List<Object> get props => [msg];
}

class MessageState extends Equatable {
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoadInProgress extends MessageState {}

class MessageLoadSuccess extends MessageState {
  final List<Message> msgs;

  MessageLoadSuccess(this.msgs);

  @override
  List<Object> get props => [msgs];
}

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepo repo;
  MessageBloc({this.repo}) : super(MessageInitial());

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    switch (event.runtimeType) {
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

  Stream<MessageState> _mapLoadMsgsEventToState(LoadMsgs event) async* {
    // if (state is MessageLoadSuccess) {
    //   return;
    // }
    yield MessageLoadInProgress();
    final msgs = await repo.loadMessages(event.fromUserId, event.toUserId);
    yield MessageLoadSuccess(msgs);
  }

  Stream<MessageState> _mapSendMsgEventToState(SendMsg event) async* {
    if (state is MessageLoadSuccess) {
      final curState = state as MessageLoadSuccess;

      // yield MessageLoadInProgress();
      final msg =
          await repo.sendMessage(event.msg, event.msg.patId, event.msg.docId);

      final nMsgs = List<Message>.from([...curState.msgs, msg]);
      await repo.updateLastMsg(
          event.msg.patId, event.msg.docId, event.msg.message);
      yield MessageLoadSuccess(nMsgs);
    }
  }

  Stream<MessageState> _mapEditMsgEventToState(EditMsg event) async* {
    yield MessageLoadInProgress();
    if (state is MessageLoadSuccess) {
      final curMsgs = (state as MessageLoadSuccess).msgs;
      await repo.editMessage(event.msg, event.msg.patId, event.msg.docId);

      final newMsgs =
          curMsgs.map((m) => m.id == event.msg.id ? event.msg : m).toList();

      yield MessageLoadSuccess(newMsgs);
    }
  }

  Stream<MessageState> _mapDeleteMsgEventToState(DeleteMsg event) async* {
    yield MessageLoadInProgress();
    if (state is MessageLoadSuccess) {
      final curMsgs = (state as MessageLoadSuccess).msgs;
      await repo.editMessage(event.msg, event.msg.patId, event.msg.docId);

      final newMsgs = curMsgs.where((m) => m.id != event.msg.id).toList();

      yield MessageLoadSuccess(newMsgs);
    }
  }
}
