import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/message_repo.dart';
import 'package:covidoc/model/entity/message_request.dart';

class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPatientChats extends ChatEvent {}

class LoadDoctorChats extends ChatEvent {}

class LoadChatRequests extends ChatEvent {}

class RequestChat extends ChatEvent {
  final MessageRequest request;

  RequestChat(this.request);

  @override
  List<Object> get props => [request];
}

class StartChat extends ChatEvent {
  final Chat chat;

  StartChat(this.chat);

  @override
  List<Object> get props => [chat];
}

class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoadInProgress extends ChatState {}

class ChatLoadSuccess extends ChatState {
  final AppUser user;
  final Chat chatWith;
  final String userType;
  final List<Chat> chats;
  final bool requestSent;
  final bool conversationStarted;
  final List<MessageRequest> requests;

  ChatLoadSuccess({
    this.user,
    this.userType,
    this.chatWith,
    this.chats = const [],
    this.requests = const [],
    this.requestSent = false,
    this.conversationStarted = false,
  });

  @override
  List<Object> get props => [
        user,
        chats,
        chatWith,
        userType,
        requests,
        requestSent,
        conversationStarted
      ];

  ChatLoadSuccess copyWith({
    AppUser user,
    Chat chatWith,
    List<Chat> chats,
    String userType,
    bool requestSent,
    bool conversationStarted,
    List<MessageRequest> requests,
  }) {
    return ChatLoadSuccess(
      user: user ?? this.user,
      chats: chats ?? this.chats,
      userType: userType ?? this.userType,
      chatWith: chatWith ?? this.chatWith,
      requests: requests ?? this.requests,
      requestSent: requestSent ?? this.requestSent,
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
      case StartChat:
        yield* _mapStartChatEventToState(event);
        break;
      case RequestChat:
        yield* _mapRequestChatEventToState(event);
        break;
      case LoadPatientChats:
        yield* _mapLoadPatientChatsEventToState(event);
        break;
      case LoadDoctorChats:
        yield* _mapLoadDoctorChatsEventToState(event);
        break;
      case LoadChatRequests:
        yield* _mapLoadRequestsEventToState(event);
        break;
      default:
    }
  }

  Stream<ChatState> _mapLoadRequestsEventToState(
      LoadChatRequests event) async* {
    if (state is ChatLoadSuccess) {
      return;
    }
    yield ChatLoadInProgress();
    final requests = await repo.loadRequests();

    yield ChatLoadSuccess(
      requests: requests,
    );
  }

  Stream<ChatState> _mapLoadDoctorChatsEventToState(
      LoadDoctorChats event) async* {
    if (state is ChatLoadSuccess) {
      return;
    }
    yield ChatLoadInProgress();
    final user = await repo.getUser();
    final chats = await repo.loadChats(user.chatIds);
    final requests = await repo.loadRequests();

    yield ChatLoadSuccess(
      user: user,
      chats: chats,
      userType: user.type,
      requests: requests,
    );
  }

  Stream<ChatState> _mapLoadPatientChatsEventToState(
      LoadPatientChats event) async* {
    if (state is ChatLoadSuccess) {
      return;
    }
    yield ChatLoadInProgress();
    final user = await repo.getUser();
    final chats = await repo.loadChats(user.chatIds);

    final requests = await repo.loadMsgRequestsByUser(user.id);
    yield ChatLoadSuccess(
      user: user,
      chats: chats,
      userType: user.type,
      requests: requests,
    );
  }

  Stream<ChatState> _mapRequestChatEventToState(RequestChat event) async* {
    if (state is ChatLoadSuccess) {
      final curState = state as ChatLoadSuccess;
      yield ChatLoadInProgress();
      final reqId = await repo.sendMsgRequest(request: event.request);
      final nRequest = event.request.copyWith(id: reqId);

      final user = await repo.getUser();

      yield curState.copyWith(
        user: user,
        requestSent: true,
        requests: [...curState.requests, nRequest],
      );
    }
  }

  Stream<ChatState> _mapStartChatEventToState(StartChat event) async* {
    if (state is ChatLoadSuccess) {
      final curState = state as ChatLoadSuccess;
      yield ChatLoadInProgress();

      // resolve the message request as resolved
      await repo.resolveMsgRequest(event.chat.requestId);

      final chatId = await repo.startConversation(
        chat: event.chat,
      );
      final nChat = event.chat.copyWith(id: chatId);

      // add chatId, userId in patient & doctor records
      await repo.addUserChatRecord(
          toUserId: event.chat.docId,
          chatId: chatId,
          fromUserId: event.chat.patId);
      await repo.addUserChatRecord(
          toUserId: event.chat.patId,
          chatId: chatId,
          fromUserId: event.chat.docId);

      final user = curState.user;
      final toUserId =
          user.type == 'Patient' ? event.chat.docId : event.chat.patId;
      await repo.cacheUserChatRecord(user, toUserId, chatId);

      yield curState.copyWith(conversationStarted: true, chatWith: nChat);
    }
  }
}
