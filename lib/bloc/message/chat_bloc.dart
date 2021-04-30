import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/message_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadChats extends ChatEvent {}

class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoadInProgress extends ChatState {}

class ChatLoadSuccess extends ChatState {
  final List<Chat> chats;

  ChatLoadSuccess(this.chats);
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepo repo;
  ChatBloc({this.repo}) : super(ChatInitial());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    switch (event.runtimeType) {
      case LoadChats:
        yield* _mapLoadChatsEventToState(event);
        break;
      default:
    }
  }

  Stream<ChatState> _mapLoadChatsEventToState(LoadChats event) async* {
    if (state is ChatLoadSuccess) {
      return;
    }
    yield ChatLoadInProgress();
    final userId = await repo.getUserId();
    final chats = await repo.loadChats(userId);
    yield ChatLoadSuccess(chats);
  }
}
