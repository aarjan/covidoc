import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/const/const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  static const ROUTE_NAME = '/chat/message';

  const ChatScreen({this.chat, this.isFromPatient});

  final Chat chat;
  final bool isFromPatient;

  @override
  Widget build(BuildContext context) {
    String toUserId;
    String fromUserId;
    String fullname;
    String avatar;

    if (isFromPatient) {
      fromUserId = chat.patId;
      toUserId = chat.docId;
      fullname = chat.docName;
      avatar = chat.docAvatar;
    } else {
      fromUserId = chat.docId;
      toUserId = chat.patId;
      fullname = chat.patName;
      avatar = chat.patAvatar;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: ChatAppBar(name: fullname, active: true, imgUrl: avatar),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(builder: (context, state) {
        if (state is MessageLoadSuccess) {
          return ChatView(
            toUserId: toUserId,
            fromUserId: fromUserId,
            messages: state.msgs,
            onSend: (String val) {
              context.read<MessageBloc>().add(
                    SendMsg(Message(
                      message: val,
                      chatId: chat.id,
                      msgFrom: isFromPatient ? 'Patient' : 'Doctor',
                      patId: fromUserId,
                      docId: toUserId,
                      timestamp: DateTime.now().toIso8601String(),
                    )),
                  );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({this.toUserId, this.fromUserId, this.onSend, this.messages});

  final String toUserId;
  final String fromUserId;
  final List<Message> messages;
  final void Function(String val) onSend;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: 0,
      keepScrollOffset: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            controller: _controller,
            itemCount: widget.messages.length,
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            itemBuilder: (context, index) {
              final msg = widget.messages[index];
              if (msg.msgFrom == 'Patient') {
                return MsgContent(msg: msg);
              } else {
                return MsgContent(msg: msg, rightAlign: false);
              }
            },
          ),
        ),
        ChatInput(
          onSend: widget.onSend,
        ),
      ],
    );
  }
}

class MsgContent extends StatelessWidget {
  const MsgContent({
    Key key,
    @required this.msg,
    this.rightAlign = true,
  }) : super(key: key);

  final Message msg;
  final bool rightAlign;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          rightAlign ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: rightAlign ? AppColors.DEFAULT3 : AppColors.WHITE3,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            msg.message,
            softWrap: true,
            style: AppFonts.REGULAR_BLACK3_14,
          ),
        ),
      ],
    );
  }
}

class ChatInput extends StatefulWidget {
  const ChatInput({
    Key key,
    this.onSend,
  }) : super(key: key);

  final void Function(String val) onSend;

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.WHITE4)),
      ),
      child: TextFormField(
        autofocus: true,
        controller: _controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 36,
              minWidth: 36,
            ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: 36,
              minWidth: 36,
            ),
            prefixIcon: Container(
              decoration: const BoxDecoration(
                color: AppColors.DEFAULT,
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(right: 12),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            hintText: 'Write a message...',
            hintStyle: AppFonts.MEDIUM_WHITE3_12,
            contentPadding: const EdgeInsets.all(20),
            suffixIcon: InkWell(
              onTap: () {
                widget.onSend(_controller.value.text);
                _controller.clear();
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.DEFAULT,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            )),
      ),
    );
  }
}

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({
    Key key,
    this.imgUrl,
    this.name,
    this.active = false,
  }) : super(key: key);

  final String name;
  final bool active;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 2),
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(imgUrl),
              maxRadius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(name, style: AppFonts.SEMIBOLD_BLACK3_16),
                  const SizedBox(height: 6),
                  Text(active ? 'Online' : 'Offline',
                      style: AppFonts.REGULAR_BLACK3_12),
                ],
              ),
            ),
            const Icon(Icons.settings, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
