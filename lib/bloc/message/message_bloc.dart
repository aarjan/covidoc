import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadMsg extends MessageEvent {}

class MessageState extends Equatable {
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoadInProgress extends MessageState {}

class MessageLoadSuccess extends MessageState {
  final List<Message> msgs;

  MessageLoadSuccess(this.msgs);
}

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepo repo;
  MessageBloc({this.repo}) : super(MessageInitial());

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    switch (event.runtimeType) {
      case LoadMsg:
        yield* _mapLoadMsgEventToState(event);
        break;
      default:
    }
  }

  Stream<MessageState> _mapLoadMsgEventToState(LoadMsg event) async* {
    yield MessageLoadInProgress();
    final userId = await repo.getUserId();
    final msgs = await repo.loadMsg(userId);
    yield MessageLoadSuccess(msgs);
  }
}
