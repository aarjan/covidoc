import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/message_repo.dart';
import 'package:covidoc/utils/utils.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen();

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
            )..add(LoadChats()),
          ),
        ],
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoadSuccess) {
              return _ChatListView(state.chats);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _ChatListView extends StatelessWidget {
  const _ChatListView(this.chats);

  final List<Chat> chats;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          onTap: () {
            context.read<MessageBloc>().add(LoadMsgs(chat.patId, chat.docId));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          toUser: AppUser(
                            id: chat.docId,
                            avatar: chat.docAvatar,
                            fullname: chat.docName,
                          ),
                          fromUser: AppUser(
                            id: chat.patId,
                            avatar: chat.patAvatar,
                            fullname: chat.patName,
                          ),
                        )));
          },
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(chat.docAvatar),
          ),
          title: Text(chat.docName),
          subtitle: Text(chat.lastMessage),
          trailing: Text(chat.lastTimestamp?.formattedTime ?? 'Today'),
        );
      },
    );
  }
}
