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
  final Chat chatWith;
  final List<Chat> chats;
  final String userType;
  final bool conversationStarted;

  ChatLoadSuccess({
    this.chats,
    this.userType,
    this.chatWith,
    this.conversationStarted = false,
  });

  @override
  List<Object> get props => [chats, chatWith, userType, conversationStarted];

  ChatLoadSuccess copyWith({
    Chat chatWith,
    List<Chat> chats,
    String userType,
    bool conversationStarted,
  }) {
    return ChatLoadSuccess(
      chats: chats ?? this.chats,
      userType: userType ?? this.userType,
      chatWith: chatWith ?? this.chatWith,
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
    final user = await repo.getUser();
    final chats = await repo.loadChats(user.chatIds);
    yield ChatLoadSuccess(chats: chats, userType: user.type);
  }

  Stream<ChatState> _mapStartChatEventToState(StartChat event) async* {
    if (state is ChatLoadSuccess) {
      final curState = state as ChatLoadSuccess;
      yield ChatLoadInProgress();
      final chatId = await repo.startConversation(
        chat: event.chat,
      );
      final nChat = event.chat.copyWith(id: chatId);

      // add chatId in patient & doctor records
      await repo.addUserChatRecord(userId: event.chat.docId, chatId: chatId);
      await repo.addUserChatRecord(userId: event.chat.patId, chatId: chatId);

      await repo.cacheUserChatRecord(chatId);

      yield curState.copyWith(conversationStarted: true, chatWith: nChat);
    }
  }
}
