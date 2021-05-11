import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/bloc/message/message.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    Key key,
    this.onSend,
  }) : super(key: key);

  final void Function(String val, List<Photo> photos) onSend;

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> with TickerProviderStateMixin {
  bool showCamera = true;
  FocusScopeNode currentFocus;
  TextEditingController _controller;
  final List<Photo> _attachedImages = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()
      ..addListener(() {
        if (showCamera && _controller.value.text.isNotEmpty) {
          showCamera = false;
          setState(() {});
        }
        if (!showCamera && _controller.value.text.isEmpty) {
          showCamera = true;
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future getImage(ImageSource source) async {
    final imgPicker = ImagePicker();
    final pickedFile =
        await imgPicker.getImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _attachedImages.add(Photo(
          file: File(pickedFile.path),
          source: PhotoSource.File,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is MessageLoadSuccess) {
          _attachedImages.clear();
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ...List.generate(
              _attachedImages.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AttachedImages(
                  photo: _attachedImages[index],
                  onRemove: () {
                    _attachedImages.removeAt(index);
                    setState(() {});
                  },
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: 18,
                    minWidth: 18,
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 36,
                    minWidth: 36,
                  ),
                  hintText: 'Write a message...',
                  hintStyle: AppFonts.MEDIUM_WHITE3_12,
                  contentPadding: const EdgeInsets.all(10),
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await getImage(ImageSource.gallery);
                        },
                        child: SvgPicture.asset('assets/forum/attach.svg'),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      if (showCamera)
                        GestureDetector(
                          onTap: () async {
                            await getImage(ImageSource.camera);
                          },
                          child: const Icon(Icons.photo_camera,
                              size: 24, color: AppColors.WHITE2),
                        ),
                      if (showCamera)
                        const SizedBox(
                          width: 4,
                        ),
                    ],
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      final _txt = _controller.value.text.trim();

                      if (_txt.isNotEmpty || _attachedImages.isNotEmpty) {
                        widget.onSend(_txt, _attachedImages);

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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
