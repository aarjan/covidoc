import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

import 'components/components.dart';

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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ImageGallerySlider(
                                  images: question.imageUrls)));
                    },
                    child: ImageSlider(images: question.imageUrls),
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
                      question.updatedAt.formattedTime,
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
                Text(
                  '${question.ansCount} Discussion',
                  style: AppFonts.REGULAR_BLACK3_14,
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
        AddAnswerField(
          onSend: (str, photos) {
            final answer = Answer(
              title: str,
              questionId: question.id,
            );
            context
                .read<AnswerBloc>()
                .add(AddAnswer(answer: answer, images: photos));
          },
        )
      ],
    );
  }
}
