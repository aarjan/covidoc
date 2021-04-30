import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/message_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadChats extends ChatEvent {}

class StartChat extends ChatEvent {
  final Chat chat;

  StartChat(this.chat);
}

class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoadInProgress extends ChatState {}

class ChatLoadSuccess extends ChatState {
  final List<Chat> chats;
  final AppUser toUser;
  final AppUser fromUser;
  final bool conversationStarted;

  ChatLoadSuccess({
    this.chats,
    this.toUser,
    this.fromUser,
    this.conversationStarted = false,
  });

  @override
  List<Object> get props => [chats, toUser, fromUser, conversationStarted];

  ChatLoadSuccess copyWith({
    AppUser toUser,
    AppUser fromUser,
    List<Chat> chats,
    bool conversationStarted,
  }) {
    return ChatLoadSuccess(
      chats: chats ?? this.chats,
      toUser: toUser ?? this.toUser,
      fromUser: fromUser ?? this.fromUser,
      conversationStarted: conversationStarted ?? this.conversationStarted,
    );
  }
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
      case StartChat:
        yield* _mapStartChatEventToState(event);
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
    yield ChatLoadSuccess(chats: chats);
  }

  Stream<ChatState> _mapStartChatEventToState(StartChat event) async* {
    if (state is ChatLoadSuccess) {
      final curState = state as ChatLoadSuccess;
      yield ChatLoadInProgress();
      await repo.startConversation(
        chat: event.chat,
        fromUserId: event.chat.patId,
        toUserId: event.chat.docId,
      );
      final fromUser = AppUser(
        id: event.chat.patId,
        avatar: event.chat.patAvatar,
        fullname: event.chat.patName,
      );

      final toUser = AppUser(
        id: event.chat.docId,
        avatar: event.chat.docAvatar,
        fullname: event.chat.docName,
      );
      yield curState.copyWith(
          conversationStarted: true, fromUser: fromUser, toUser: toUser);
    }
  }
}
