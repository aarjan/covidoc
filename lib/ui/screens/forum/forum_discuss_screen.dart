import 'package:covidoc/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

import 'components/answer_item.dart';

class ForumDiscussScreen extends StatelessWidget {
  static const ROUTE_NAME = '/forum/discuss';

  const ForumDiscussScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Discuss',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          const Icon(
            Icons.more_vert,
            color: Colors.black,
          )
        ],
      ),
      body: BlocConsumer<AnswerBloc, AnswerState>(
        listener: (context, state) {
          if (state is AnswerLoadSuccess) {
            // context.toast('Answer added');
          }
        },
        builder: (context, state) {
          if (state is AnswerLoadSuccess) {
            return ForumDiscussView(
                question: state.question, answers: state.answers);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ForumDiscussView extends StatelessWidget {
  const ForumDiscussView({
    Key key,
    @required this.question,
    @required this.answers,
  }) : super(key: key);

  final Forum question;
  final List<Answer> answers;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.title,
                  style: AppFonts.MEDIUM_BLACK3_16,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                if (question.imageUrls.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: question.imageUrls[0],
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage:
                          CachedNetworkImageProvider(question.addedByAvatar),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      question.addedByName,
                      style: AppFonts.REGULAR_BLACK3_10,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      question.timestamp.formattedTime,
                      style: AppFonts.REGULAR_WHITE2_10,
                    ),
                    const Spacer(),
                    Text(
                      question.category,
                      style: AppFonts.REGULAR_DEFAULT_10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Wrap(
                  children: [
                    ...List.generate(
                      question.tags.length,
                      (index) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.WHITE5,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            question.tags[index],
                            style: AppFonts.REGULAR_WHITE2_10,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${question.ansCount} Discussion',
                      style: AppFonts.REGULAR_BLACK3_14,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.yellow[800],
                            size: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Report This Question',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.yellow[800]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1.0,
                  height: 20.0,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      return AnswerItem(
                        answer: answers[index],
                      );
                    }),
              ],
            ),
          ),
        ),
        SendMsg(
          onSend: (str) {
            final answer = Answer(
              title: str,
              questionId: question.id,
              timestamp: DateTime.now(),
            );
            context.read<AnswerBloc>().add(AddAnswer(answer: answer));
          },
        )
      ],
    );
  }
}

class SendMsg extends StatefulWidget {
  const SendMsg({
    Key key,
    this.onSend,
  }) : super(key: key);

  final void Function(String) onSend;

  @override
  _SendMsgState createState() => _SendMsgState();
}

class _SendMsgState extends State<SendMsg> {
  String _txt;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.WHITE4),
        ),
      ),
      child: Row(
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: AppFonts.REGULAR_WHITE3_14,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.WHITE4)),
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
                widget.onSend(_txt);
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
    );
  }
}
