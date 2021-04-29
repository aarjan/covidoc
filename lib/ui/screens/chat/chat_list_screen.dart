import 'package:cached_network_image/cached_network_image.dart';
import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/message_repo.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocProvider(
        create: (context) => MessageBloc(
          repo: context.read<MessageRepo>(),
        )..add(LoadMsg()),
        child: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            if (state is MessageLoadSuccess) {
              return ChatView(state.msgs);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView(this.messages);

  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(msg.docAvatar),
          ),
          title: Text(msg.docName),
          subtitle: Text(msg.lastMessage),
          trailing: Text(msg.lastTimeStamp),
        );
      },
    );
  }
}
