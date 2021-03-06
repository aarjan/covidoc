import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';

class ChatRequest extends StatefulWidget {
  const ChatRequest({Key? key, required this.user}) : super(key: key);
  final AppUser? user;

  @override
  _ChatRequestState createState() => _ChatRequestState();
}

class _ChatRequestState extends State<ChatRequest> {
  PageController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.WHITE3),
        ),
        padding: const EdgeInsets.all(20),
        child: PageView(
          pageSnapping: false,
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            RequestDialog(
              onSubmit: () async {
                // show signIn dialog
                if (widget.user == null) {
                  return showLoginDialog(context);
                }

                await _controller!.animateToPage(1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
            ),
            ReplyDialog(
              onSubmit: (String msg, bool anonymous) {
                final msgRequest = MessageRequest(
                  message: msg,
                  resolved: false,
                  postedBy: widget.user!.id ?? '',
                  patDetail: {
                    'avatar': widget.user!.avatar,
                    'age': widget.user!.detail!['age'],
                    'fullname': widget.user!.fullname,
                    'gender': widget.user!.detail!['gender'],
                  },
                  postedAt: DateTime.now().toUtc(),
                  postedAnonymously: anonymous,
                );

                context.read<ChatBloc>().add(RequestChat(msgRequest));

                _controller!.animateToPage(2,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
            ),
            const StatusDialog(),
          ],
        ),
      ),
    );
  }
}

class RequestDialog extends StatelessWidget {
  const RequestDialog({
    Key? key,
    this.onSubmit,
  }) : super(key: key);

  final void Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
          AppConst.REQUEST_CONSULT,
          textAlign: TextAlign.center,
          style: AppFonts.MEDIUM_BLACK3_16,
        ),
        const Spacer(),
        const SizedBox(height: 20),
        MsgBtn(
          title: AppConst.REQUEST_CONSULT_BTN_TXT,
          onTap: onSubmit,
        ),
      ],
    );
  }
}

class ReplyDialog extends StatefulWidget {
  const ReplyDialog({
    Key? key,
    this.msg = '',
    required this.onSubmit,
    this.updateMode = false,
    this.postAnonymous = false,
  }) : super(key: key);

  final String msg;
  final bool updateMode;
  final bool postAnonymous;
  final void Function(String msg, bool anonymous) onSubmit;

  @override
  _ReplyDialogState createState() => _ReplyDialogState();
}

class _ReplyDialogState extends State<ReplyDialog> {
  late String _msg;
  late bool _postAnonymous;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _msg = widget.msg;
    _postAnonymous = widget.postAnonymous;
  }

  @override
  Widget build(BuildContext context) {
    final mainTxt = widget.updateMode ? 'Update your query' : 'Ask your query';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        Text(
          mainTxt,
          style: AppFonts.SEMIBOLD_BLACK3_16,
        ),
        const SizedBox(height: 20),
        Form(
          key: _formKey,
          child: FormInput(
            minLines: 6,
            maxLines: 6,
            initialValue: _msg,
            onSave: (val) => _msg = val!.trim(),
            onValidate: (val) =>
                val!.trim().length < 100 ? AppConst.MSG_ERROR : null,
            title: AppConst.REQUEST_WRITE_TXT,
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            setState(() {
              _postAnonymous = !_postAnonymous;
            });
          },
          child: Row(
            children: [
              _postAnonymous
                  ? const Icon(Icons.check_box_rounded,
                      color: AppColors.DEFAULT)
                  : const Icon(Icons.check_box_outline_blank_outlined,
                      color: AppColors.DEFAULT),
              const SizedBox(width: 10),
              Text(AppConst.POST_ANONYMOUS_TXT,
                  style: AppFonts.MEDIUM_BLACK3_14),
            ],
          ),
        ),
        const Spacer(),
        MsgBtn(
          title: widget.updateMode
              ? AppConst.REQUEST_UPDATE_BTN_TXT
              : AppConst.REQUEST_SEND_BTN_TXT,
          onTap: () {
            _formKey.currentState!.save();
            FocusScope.of(context).unfocus();

            if (_formKey.currentState!.validate()) {
              widget.onSubmit(_msg, _postAnonymous);
            }
          },
        )
      ],
    );
  }
}

class StatusDialog extends StatelessWidget {
  const StatusDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.DEFAULT,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.check, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 15),
            Text(
              AppConst.REQUEST_SUCCESSFULL_TXT,
              textAlign: TextAlign.center,
              style: AppFonts.MEDIUM_BLACK3_14,
            )
          ],
        )),
        MsgBtn(
          title: AppConst.REQUEST_DONE_BTN_TXT,
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

class MsgBtn extends StatelessWidget {
  const MsgBtn({
    Key? key,
    this.onTap,
    this.title,
  }) : super(key: key);

  final void Function()? onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.DEFAULT,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/chat/message.svg'),
            const SizedBox(width: 12),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: AppFonts.BOLD_WHITE_14,
            )
          ],
        ),
      ),
    );
  }
}
