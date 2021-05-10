import 'package:flutter/material.dart';
import 'package:covidoc/utils/const/const.dart';

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
  FocusScopeNode currentFocus;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentFocus = FocusScope.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.WHITE4)),
        ),
        child: TextFormField(
          autofocus: true,
          controller: _controller,
          minLines: 1,
          maxLines: 5,
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
                  final _txt = _controller.value.text.trim();

                  if (_txt.isNotEmpty) {
                    widget.onSend(_txt);

                    // remove focus from Textformfield
                    // if (!currentFocus.hasPrimaryFocus) {
                    //   currentFocus.unfocus();
                    // }
                  }

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
      ),
    );
  }
}
