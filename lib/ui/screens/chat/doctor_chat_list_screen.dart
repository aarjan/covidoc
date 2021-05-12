import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covidoc/ui/screens/screens.dart';

import 'package:covidoc/ui/router.dart';
import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/model/repo/repo.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

import 'chat_screen.dart';
import 'components/components.dart';

class DocChatListScreen extends StatefulWidget {
  static const ROUTE_NAME = '/chat/list';

  const DocChatListScreen();

  @override
  _DocChatListScreenState createState() => _DocChatListScreenState();
}

class _DocChatListScreenState extends State<DocChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversations',
          style: AppFonts.SEMIBOLD_BLACK3_16,
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ChatBloc(
              repo: context.read<MessageRepo>(),
            )..add(LoadDoctorChats()),
          ),
        ],
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatLoadSuccess && state.conversationStarted) {
              context.read<MessageBloc>().add(LoadMsgs());
              Navigator.push(
                  context,
                  getRoute(
                      ChatScreen(chat: state.chatWith, isFromPatient: false)));
            }
          },
          child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
            if (state is ChatLoadSuccess) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _ChatListView(
                      state.user,
                      state.chats,
                      state.requests,
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }
}

class _ChatListView extends StatelessWidget {
  const _ChatListView(this.user, this.chats, this.requests);
  final AppUser user;
  final List<Chat> chats;
  final List<MessageRequest> requests;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: chats.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Recent Chats',
              style: AppFonts.SEMIBOLD_WHITE3_14,
            ),
          ),
        ),
        // Recent Chats
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chats.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => Column(
            children: [
              ChatItem(chats[index], false),
              const Divider(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Text(
            'Consultation requests',
            style: AppFonts.SEMIBOLD_WHITE3_14,
          ),
        ),
        // Recent Patient Queries
        ListView.separated(
          shrinkWrap: true,
          itemCount: requests.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return const SizedBox(height: 16);
          },
          itemBuilder: (context, index) {
            final request = requests[index];
            return MsgRequest(
              request: request,
              onSubmit: () {
                context.read<ChatBloc>().add(
                      StartChat(Chat(
                        docId: user.id,
                        requestId: request.id,
                        docAvatar: user.avatar,
                        docName: user.fullname,
                        patId: request.postedBy,
                        consultReqMessage: request.message,
                        lastTimestamp: DateTime.now().toUtc(),
                        patName: request.patDetail['fullname'],
                        patAvatar: request.patDetail['avatar'],
                      )),
                    );
              },
            );
          },
        ),
        const SizedBox(height: 32)
      ],
    );
  }
}
