import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';

import 'components/components.dart';

class ForumDiscussScreen extends StatefulWidget {
  static const ROUTE_NAME = '/forum/discuss';

  final bool isAuthenticated;
  const ForumDiscussScreen({Key? key, this.isAuthenticated = false})
      : super(key: key);

  @override
  _ForumDiscussScreenState createState() => _ForumDiscussScreenState();
}

class _ForumDiscussScreenState extends State<ForumDiscussScreen> {
  Forum? _question;
  List<Answer>? _answers;

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
            _question = state.question;
            _answers = state.answers;
          }
          return Stack(
            children: [
              if (_question != null)
                ForumDiscussView(
                  question: _question,
                  answers: _answers,
                  isAuthenticated: widget.isAuthenticated,
                ),
              if (state is AnswerLoadInProgress)
                const Center(child: CircularProgressIndicator())
            ],
          );
        },
      ),
    );
  }
}

class ForumDiscussView extends StatelessWidget {
  const ForumDiscussView({
    Key? key,
    required this.question,
    required this.answers,
    required this.isAuthenticated,
  }) : super(key: key);

  final Forum? question;
  final bool isAuthenticated;
  final List<Answer>? answers;

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
                ReadMoreText(
                  question!.title!,
                  trimLines: 4,
                  colorClickableText: AppColors.DEFAULT,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  style: AppFonts.MEDIUM_BLACK3_16,
                  moreStyle: AppFonts.MEDIUM_DEFAULT_16,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                if (question!.imageUrls.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ImageGallerySlider(
                                  images: question!.imageUrls)));
                    },
                    child: ImageSlider(images: question!.imageUrls),
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage:
                          CachedNetworkImageProvider(question!.addedByAvatar!),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      question!.addedByName!,
                      style: AppFonts.REGULAR_BLACK3_10,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      question!.updatedAt!.formattedTime,
                      style: AppFonts.REGULAR_WHITE2_10,
                    ),
                    const Spacer(),
                    Text(
                      question!.category!,
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
                      question!.tags.length,
                      (index) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.WHITE5,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            question!.tags[index],
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
                  '${question!.ansCount} Discussion',
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
                    itemCount: answers!.length,
                    itemBuilder: (context, index) {
                      return AnswerItem(
                        answer: answers![index],
                      );
                    }),
              ],
            ),
          ),
        ),
        AddAnswerField(
          onSend: (str, photos) async {
            if (!isAuthenticated) {
              return showLoginDialog(context);
            }

            final answer = Answer(
              title: str,
              questionId: question!.id,
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
