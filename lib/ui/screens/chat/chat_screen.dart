import 'dart:async';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/chat_app_bar.dart';
import 'components/chat_input.dart';
import 'components/message_content.dart';

class ChatScreen extends StatefulWidget {
  static const ROUTE_NAME = '/chat/message';

  const ChatScreen({this.chat, this.isFromPatient});

  final Chat chat;
  final bool isFromPatient;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String userType;
  List<Message> _msgs;
  bool _hasReachedEnd = false;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    userType = widget.isFromPatient ? 'Patient' : 'Doctor';
    _controller = ScrollController(initialScrollOffset: 0)
      ..addListener(() {
        if (_controller.offset == _controller.position.maxScrollExtent &&
            !_hasReachedEnd) {
          context.read<MessageBloc>().add(LoadMsgs(chatId: widget.chat.id));
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    String toUserId;
    String fromUserId;
    String fullname;
    String avatar;

    if (widget.isFromPatient) {
      fromUserId = widget.chat.patId;
      toUserId = widget.chat.docId;
      fullname = widget.chat.docName;
      avatar = widget.chat.docAvatar;
    } else {
      fromUserId = widget.chat.docId;
      toUserId = widget.chat.patId;
      fullname = widget.chat.patName;
      avatar = widget.chat.patAvatar;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: ChatAppBar(name: fullname, active: true, imgUrl: avatar),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(builder: (context, state) {
        if (state is MessageLoadSuccess) {
          _msgs = state.msgs;
          _hasReachedEnd = state.hasReachedEnd;
        }
        return Stack(
          children: [
            if (_msgs != null)
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: _msgs.length,
                      padding: EdgeInsets.fromLTRB(
                          16, 6, 16, MediaQuery.of(context).viewInsets.bottom),
                      itemBuilder: (context, index) {
                        final msg = _msgs[index];
                        final isSender = msg.msgFrom == userType;
                        if (isSender) {
                          return SenderContent(msg: msg);
                        } else {
                          return ReceiverContent(msg: msg);
                        }
                      },
                    ),
                  ),
                  ChatInput(
                    onSend: (str) {
                      final msg = Message(
                        message: str,
                        docId: toUserId,
                        patId: fromUserId,
                        chatId: widget.chat.id,
                        timestamp: DateTime.now(),
                        msgFrom: widget.isFromPatient ? 'Patient' : 'Doctor',
                      );

                      context.read<MessageBloc>().add(SendMsg(msg));
                    },
                  ),
                ],
              ),
            if (state is MessageLoadInProgress)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }
}
