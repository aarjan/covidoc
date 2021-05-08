import 'dart:io';

import 'package:covidoc/model/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:image_picker/image_picker.dart';

import 'attached_images.dart';

class AddAnswerField extends StatefulWidget {
  const AddAnswerField({
    Key key,
    this.text,
    this.onSend,
    this.images,
    this.updateAnswer = false,
  }) : super(key: key);

  final String text;
  final List<Photo> images;
  final bool updateAnswer;
  final void Function(String, List<Photo>) onSend;

  @override
  _AddAnswerState createState() => _AddAnswerState();
}

class _AddAnswerState extends State<AddAnswerField> {
  String _txt;
  final List<Photo> _attachedImages = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // init values
    if (widget.updateAnswer) {
      _txt = widget.text;

      for (final e in widget.images) {
        _attachedImages.add(Photo(
          source: PhotoSource.Network,
          url: e.url,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          10, 0, 10, MediaQuery.of(context).viewInsets.bottom),
      // width: double.infinity,
      child: Column(
        children: [
          ...List.generate(
            _attachedImages.length,
            (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AttachedImages(
                  photo: _attachedImages[index],
                  onRemove: () {
                    _attachedImages.removeAt(index);
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: false,
                    onSaved: (val) => _txt = val,
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      hintStyle: AppFonts.REGULAR_WHITE3_14,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.WHITE4),
                      ),
                      suffix: GestureDetector(
                        onTap: () async {
                          await getImage();
                        },
                        child: SvgPicture.asset(
                          'assets/forum/attach.svg',
                          height: 18,
                          width: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  _formKey.currentState.save();
                  if (_formKey.currentState.validate()) {
                    widget.onSend(_txt, _attachedImages);
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppColors.DEFAULT,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(11),
                  child: SvgPicture.asset('assets/forum/send.svg'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _attachedImages.add(Photo(
          file: File(pickedFile.path),
          source: PhotoSource.File,
        ));
      });
    }
  }
}
