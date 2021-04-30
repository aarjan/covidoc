import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/repo/message_repo.dart';

import 'chat_list.dart';
import 'chat_screen.dart';
import 'doctor_list.dart';

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
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatLoadSuccess && state.conversationStarted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      fromUser: state.fromUser,
                      toUser: state.toUser,
                    ),
                  ));
            }
          },
          child: Column(
            children: [
              const Flexible(child: ChatListView()),
              const SizedBox(height: 50),
              Text(
                'Chat with Doctors',
                style: AppFonts.MEDIUM_BLACK3_16,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () {
                    context.read<UserBloc>().add(LoadDoctor());
                  },
                  child: Text('Load Doctors', style: AppFonts.MEDIUM_WHITE_14),
                ),
              ),
              const SizedBox(height: 20),
              const Flexible(child: DoctorListView()),
            ],
          ),
        ),
      ),
    );
  }
}
