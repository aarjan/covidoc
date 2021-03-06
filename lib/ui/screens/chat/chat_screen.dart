import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

import 'components/chat_app_bar.dart';
import 'components/chat_input.dart';
import 'components/message_content.dart';

class ChatScreen extends StatefulWidget {
  static const ROUTE_NAME = '/chat/message';

  const ChatScreen({Key? key, required this.chat, required this.isFromPatient})
      : super(key: key);

  final Chat chat;
  final bool isFromPatient;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? userType;
  List<Message>? _msgs;
  int _deleteCount = 0;
  bool _deleteMode = false;
  bool _hasReachedEnd = false;
  ScrollController? _controller;
  bool _clearReqmsg = false;
  final List<String> msgIds = [];

  @override
  void initState() {
    super.initState();
    userType = widget.isFromPatient ? 'Patient' : 'Doctor';
    _controller = ScrollController(initialScrollOffset: 0)
      ..addListener(() {
        if (_controller!.offset == _controller!.position.maxScrollExtent &&
            !_hasReachedEnd) {
          context.read<MessageBloc>().add(LoadMsgs(chatId: widget.chat.id));
        }
      });
    Permission.microphone.request();
  }

  void onLongPress(bool onSelected, String msgId) {
    if (onSelected) {
      _deleteCount++;
      msgIds.add(msgId);
    } else {
      _deleteCount--;
      msgIds.remove(msgId);
    }
    _deleteMode = _deleteCount > 0;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String? toUserId;
    String? fromUserId;
    String? fullname;
    String? avatar;

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
        flexibleSpace: ChatAppBar(
          name: fullname,
          active: true,
          imgUrl: avatar,
          userId: toUserId!,
          deleteMode: _deleteMode,
          deleteCount: _deleteCount,
          msgRequest: widget.chat.consultReqMessage!,
          onDelete: () {
            context.read<MessageBloc>().add(
                  DeleteMsg(chatId: widget.chat.id, msgIds: msgIds),
                );
            _deleteMode = false;
            _deleteCount = 0;
            setState(() {});
          },
        ),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(builder: (context, state) {
        if (state is MessageLoadSuccess) {
          _msgs = state.msgs;
          _hasReachedEnd = state.hasReachedEnd;
        }
        return Stack(
          children: [
            Column(
              children: [
                if (_msgs != null)
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: _msgs!.length,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      itemBuilder: (context, index) {
                        final msg = _msgs![index];
                        final isSender = msg.msgFrom == userType;
                        if (isSender) {
                          return SenderContent(
                            key: ValueKey(msg.id),
                            msg: msg,
                            onLongPress: onLongPress,
                          );
                        } else {
                          return ReceiverContent(
                            key: ValueKey(msg.id),
                            msg: msg,
                          );
                        }
                      },
                    ),
                  )
                else
                  const Spacer(),
                ChatInput(
                  onSend: (str, photos, msgType) {
                    final msg = Message(
                      message: str,
                      docId: toUserId,
                      patId: fromUserId,
                      chatId: widget.chat.id,
                      msgType: msgType,
                      timestamp: DateTime.now(),
                      msgFrom: widget.isFromPatient ? 'Patient' : 'Doctor',
                    );

                    context
                        .read<MessageBloc>()
                        .add(SendMsg(msg: msg, images: photos));
                  },
                ),
              ],
            ),
            if (!_clearReqmsg)
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.GREEN1,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ReadMoreText(
                          widget.chat.consultReqMessage!,
                          trimLines: 4,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          style: AppFonts.REGULAR_BLACK3_14,
                          colorClickableText: AppColors.DEFAULT,
                          moreStyle: AppFonts.MEDIUM_DEFAULT_14,
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(left: 5),
                        constraints:
                            const BoxConstraints(minHeight: 24, minWidth: 24),
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _clearReqmsg = true;
                          setState(() {});
                        },
                      )
                    ],
                  )),
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
