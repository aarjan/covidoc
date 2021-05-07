import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/bloc/forum/forum.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/ui/widgets/dropdown.dart';

import 'attached_images.dart';
import 'question_tags.dart';

class AddQuestionModal extends StatelessWidget {
  const AddQuestionModal();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForumBloc, ForumState>(
      listener: (context, state) {
        if (state is ForumLoadSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            const _AddQuestion(),
            if (state is ForumLoadInProgress)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}

class _AddQuestion extends StatefulWidget {
  const _AddQuestion({
    Key key,
  }) : super(key: key);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<_AddQuestion> {
  String _question;
  final List<String> _tags = [];
  final List<File> _attachedImages = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          Text('Add new question', style: AppFonts.REGULAR_BLACK3_24),
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
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 150,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            validator: (val) => val.trim().isEmpty
                                ? 'Question cannot be empty!'
                                : null,
                            onSaved: (str) => _question = str,
                            decoration: InputDecoration(
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Type your Question here',
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
                        (index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AttachedImages(
                              imgFile: _attachedImages[index],
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
                    ],
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
          // --------------------------------------------------------
          //  TAGS HEADING
          // --------------------------------------------------------
          Text(
            'Tags',
            style: AppFonts.REGULAR_BLACK3_14,
          ),
          const SizedBox(
            height: 15,
          ),
          // --------------------------------------------------------
          //  CONTAINER CONTAINING A HORIZONTAL LIST OF TAGS
          // --------------------------------------------------------
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.WHITE5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: QuestionTags(
              onAdd: (str) {
                _tags.add(str);
              },
              onRemove: (str) {
                _tags.remove(str);
              },
            ),
          ),

          const SizedBox(
            height: 25,
          ),
          // --------------------------------------------------------
          // CATEGORY DROPDOWN
          // --------------------------------------------------------
          Dropdown(
            title: 'Category',
            borderRadius: 10,
            verticalPadding: 15,
            onPressed: () {},
          ),
          const SizedBox(
            height: 25,
          ),
          // -----------------------------------------------------------------
          // BUTTONS CANCEL AND SUBMIT
          // -----------------------------------------------------------------
          Container(
            padding: const EdgeInsets.only(
              top: 10,
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
                        final forum = Forum(
                          tags: _tags,
                          title: _question,
                          category: 'Category1',
                          timestamp: DateTime.now(),
                        );
                        context
                            .read<ForumBloc>()
                            .add(AddForum(forum, _attachedImages));
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
        _attachedImages.add(File(pickedFile.path));
      });
    }
  }
}
