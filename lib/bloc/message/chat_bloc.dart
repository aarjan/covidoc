import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/message_repo.dart';
import 'package:covidoc/model/entity/message_request.dart';

class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadPatientChats extends ChatEvent {
  final bool hardRefresh;
  const LoadPatientChats({this.hardRefresh = false});

  @override
  List<Object> get props => [hardRefresh];
}

class LoadDoctorChats extends ChatEvent {
  final bool hardRefresh;
  const LoadDoctorChats({this.hardRefresh = false});

  @override
  List<Object> get props => [hardRefresh];
}

class LoadChatRequests extends ChatEvent {}

class UpdateMsgRequest extends ChatEvent {
  final MessageRequest request;
  const UpdateMsgRequest(this.request);

  @override
  List<Object> get props => [request];
}

class DelMsgRequest extends ChatEvent {
  final String id;
  const DelMsgRequest(this.id);

  @override
  List<Object> get props => [id];
}

class RequestChat extends ChatEvent {
  final MessageRequest request;

  const RequestChat(this.request);

  @override
  List<Object> get props => [request];
}

class StartChat extends ChatEvent {
  final Chat chat;

  const StartChat(this.chat);

  @override
  List<Object> get props => [chat];
}

class ReportChat extends ChatEvent {
  final String report;
  final String reportType;
  final Map<String, String> details;

  const ReportChat({
    required this.report,
    required this.details,
    required this.reportType,
  });

  @override
  List<Object> get props => [report, reportType, details];
}

class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoadInProgress extends ChatState {}

class ChatLoadSuccess extends ChatState {
  final String? msg;
  final AppUser? user;
  final Chat? chatWith;
  final String? userType;
  final List<Chat> chats;
  final bool requestSent;
  final bool conversationStarted;
  final List<MessageRequest> requests;

  ChatLoadSuccess({
    this.msg,
    this.user,
    this.userType,
    this.chatWith,
    this.chats = const [],
    this.requests = const [],
    this.requestSent = false,
    this.conversationStarted = false,
  });

  @override
  List<Object?> get props => [
        msg,
        user,
        chats,
        chatWith,
        userType,
        requests,
        requestSent,
        conversationStarted
      ];

  ChatLoadSuccess copyWith({
    String? msg,
    AppUser? user,
    Chat? chatWith,
    List<Chat>? chats,
    String? userType,
    bool? requestSent,
    bool? conversationStarted,
    List<MessageRequest>? requests,
  }) {
    return ChatLoadSuccess(
      msg: msg ?? this.msg,
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
  ChatBloc({required this.repo}) : super(ChatInitial());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    switch (event.runtimeType) {
      case ReportChat:
        yield* _mapReportChatEventToState(event as ReportChat);
        break;
      case StartChat:
        yield* _mapStartChatEventToState(event as StartChat);
        break;
      case RequestChat:
        yield* _mapRequestChatEventToState(event as RequestChat);
        break;
      case UpdateMsgRequest:
        yield* _mapUpdateMsgRequestEventToState(event as UpdateMsgRequest);
        break;
      case DelMsgRequest:
        yield* _mapDelMsgRequestEventToState(event as DelMsgRequest);
        break;
      case LoadPatientChats:
        yield* _mapLoadPatientChatsEventToState(event as LoadPatientChats);
        break;
      case LoadDoctorChats:
        yield* _mapLoadDoctorChatsEventToState(event as LoadDoctorChats);
        break;
      case LoadChatRequests:
        yield* _mapLoadRequestsEventToState(event as LoadChatRequests);
        break;
      default:
    }
  }

  Stream<ChatState> _mapReportChatEventToState(ReportChat event) async* {
    if (state is ChatLoadSuccess) {
      final curState = state as ChatLoadSuccess;
      yield ChatLoadInProgress();

      await repo.reportPost(
        report: event.report,
        details: event.details,
        reportType: event.reportType,
      );
      yield curState.copyWith(msg: 'Thank you for the report!');
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
    if (state is ChatLoadSuccess && !event.hardRefresh) {
      return;
    }
    yield ChatLoadInProgress();
    final user = await repo.getUser();
    if (user == null) {
      throw Exception('user is null');
    }

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
    if (state is ChatLoadSuccess && !event.hardRefresh) {
      return;
    }
    yield ChatLoadInProgress();
    final user = await repo.getUser();

    final chats = await repo.loadChats(user?.chatIds ?? []);

    final requests = await repo.loadMsgRequestsByUser(user?.id);
    yield ChatLoadSuccess(
      user: user,
      chats: chats,
      userType: user?.type,
      requests: requests,
    );
  }

  Stream<ChatState> _mapUpdateMsgRequestEventToState(
      UpdateMsgRequest event) async* {
    if (state is ChatLoadSuccess) {
      final curState = state as ChatLoadSuccess;
      yield ChatLoadInProgress();

      await repo.updateMsgRequest(request: event.request);

      yield curState.copyWith(
        requestSent: true,
        requests: curState.requests
            .map((e) => e.id == event.request.id ? event.request : e)
            .toList(),
      );
    }
  }

  Stream<ChatState> _mapDelMsgRequestEventToState(DelMsgRequest event) async* {
    if (state is ChatLoadSuccess) {
      final curState = state as ChatLoadSuccess;
      yield ChatLoadInProgress();

      await repo.delMsgRequest(id: event.id);

      yield curState.copyWith(
        requestSent: true,
        requests: curState.requests.where((e) => e.id != event.id).toList(),
      );
    }
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
      await repo.resolveMsgRequest(
        requestId: event.chat.requestId,
        docId: event.chat.docId,
        docDetail: {
          'fullname': event.chat.docName,
          'avatar': event.chat.docAvatar,
        },
      );

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

      final user = curState.user!;
      final toUserId =
          user.type == 'Patient' ? event.chat.docId : event.chat.patId;
      await repo.cacheUserChatRecord(user, toUserId, chatId);

      yield curState.copyWith(conversationStarted: true, chatWith: nChat);
    }
  }
}
