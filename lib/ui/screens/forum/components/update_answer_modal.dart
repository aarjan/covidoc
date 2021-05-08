import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';

import 'attached_images.dart';

class UpdateAnswerModal extends StatefulWidget {
  final String text;
  final List<Photo> images;
  final void Function(String text, List<Photo> images) onSend;

  const UpdateAnswerModal({
    Key key,
    this.text,
    this.images,
    this.onSend,
  }) : super(key: key);

  @override
  UpdateAnswerModalState createState() => UpdateAnswerModalState();
}

class UpdateAnswerModalState extends State<UpdateAnswerModal> {
  String _txt;
  ScrollController _controller;
  final List<Photo> _attachedImages = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    // init values
    _txt = widget.text;

    for (final e in widget.images) {
      _attachedImages.add(Photo(
        source: PhotoSource.Network,
        url: e.url,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -----------------------------------------------------------------
          // a small divider at the top
          // -----------------------------------------------------------------
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Divider(
              thickness: 4,
              indent: screenWidth(context) * 0.4,
              endIndent: screenWidth(context) * 0.4,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          // --------------------------------------------------------
          // HEADING
          // --------------------------------------------------------
          Text('Update your answer', style: AppFonts.REGULAR_BLACK3_24),
          const SizedBox(
            height: 15,
          ),
          // -----------------------------------------------------------------
          // SCROLLABLE CONTAINER
          // CONTAINING THE QUESTION TEXTFIELD, ATTACHED IMAGES, TAGS, ETC
          // -----------------------------------------------------------------

          const SizedBox(
            height: 10,
          ),
          // --------------------------------------------------------
          // CONTAINER CONTAINING
          // QUESTION, THE ATTACHED IMAGES ALONG WITH BUTTON
          // --------------------------------------------------------
          Container(
            height: 250,
            width: double.infinity,
            padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.WHITE5,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // --------------------------------------------------
                //  TEXTFIELD FOR THE QUESTION
                // --------------------------------------------------
                Expanded(
                  child: Scrollbar(
                    isAlwaysShown: true,
                    radius: const Radius.circular(6),
                    controller: _controller,
                    child: ListView(
                      controller: _controller,
                      children: [
                        SizedBox(
                          height: 150,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              initialValue: _txt,
                              validator: (val) => val.trim().isEmpty
                                  ? 'Answer cannot be empty!'
                                  : null,
                              onSaved: (str) => _txt = str.trim(),
                              decoration: InputDecoration(
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'Type your answer here',
                                hintStyle: AppFonts.REGULAR_WHITE3_14,
                              ),
                              textAlign: TextAlign.left,
                              textAlignVertical: TextAlignVertical.top,
                            ),
                          ),
                        ),
                        // --------------------------------------------------
                        // GENERATE
                        // ATTACHED IMAGE CONTAINER FROM THE IMAGEURL LIST
                        // --------------------------------------------------
                        ...List.generate(
                          _attachedImages.length,
                          (index) => AttachedImages(
                            photo: _attachedImages[index],
                            onRemove: () {
                              _attachedImages.removeAt(index);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // --------------------------------------------------
                // ATTACH IMAGE BUTTOM
                // --------------------------------------------------
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await getImage();
                      Focus.of(context).unfocus();

                      // animate to bottom
                      await _controller.animateTo(
                          _controller.position.maxScrollExtent + 50,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.WHITE5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/forum/attach.svg',
                          ),
                          Expanded(
                            child: Text(
                              'Attach Image',
                              textAlign: TextAlign.center,
                              style: AppFonts.REGULAR_BLACK3_14,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          // -----------------------------------------------------------------
          // BUTTONS CANCEL AND SUBMIT
          // -----------------------------------------------------------------
          Container(
            padding: EdgeInsets.only(
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Row(
              children: [
                // ----------------------------------------------------------
                // CANCEL BUTTON
                // ----------------------------------------------------------
                Flexible(
                  child: DefaultButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    bgColor: Colors.white,
                    textColor: AppColors.DEFAULT,
                    title: 'Cancel',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // ----------------------------------------------------------
                // SUBMIT BUTTON
                // ----------------------------------------------------------
                Flexible(
                  child: DefaultButton(
                    onTap: () {
                      _formKey.currentState.save();
                      if (_formKey.currentState.validate()) {
                        widget.onSend(_txt, _attachedImages);
                      }
                    },
                    title: 'Submit',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
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
