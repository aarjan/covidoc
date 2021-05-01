import 'package:covidoc/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/model/entity/entity.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoadSuccess) {
          return _ChatItem(state.chats, state.userType == 'Patient');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ChatItem extends StatelessWidget {
  const _ChatItem(this.chats, this.isFrontPatient);

  final List<Chat> chats;
  final bool isFrontPatient;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          onTap: () {
            context.read<MessageBloc>().add(LoadMsgs(chat.id));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          chat: chat,
                          isFromPatient: isFrontPatient,
                        )));
          },
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(chat.docAvatar),
          ),
          title: Text(chat.docName),
          subtitle: Text(chat.lastMessage ?? 'No Conversation started!'),
          trailing: Text(chat.lastTimestamp?.formattedTime ?? 'Today'),
        );
      },
    );
  }
}
