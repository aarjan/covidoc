import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  bool _isLoading = false;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    // ----------------------------------------------------------------------
    // FETCH MORE ITEMS WHEN REACHED THE BOTTOM (90%) OF THE SCREEN
    // ----------------------------------------------------------------------
    _controller.addListener(() {
      final maxExtent = _controller.position.maxScrollExtent * 0.9;
      if (_controller.position.pixels > maxExtent &&
          !_isLoading &&
          _controller.position.userScrollDirection == ScrollDirection.reverse) {
        _isLoading = true;
        context
            .read<AnswerBloc>()
            .add(LoadAnswers(question: _question!, loadMore: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discuss',
          style: AppFonts.BOLD_WHITE_18,
        ),
        leading: const BackButton(color: Colors.white),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: BlocBuilder<AnswerBloc, AnswerState>(
        builder: (context, state) {
          if (state is AnswerLoadSuccess) {
            _isLoading = false;
            _question ??= state.question;
            _answers = state.answers;

            if (_controller.hasClients) {
              _controller.animateTo(
                _controller.position.maxScrollExtent + 100,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            }
          }
          return Stack(
            children: [
              if (_question != null)
                RefreshIndicator(
                  onRefresh: () async {
                    context.read<AnswerBloc>().add(
                        LoadAnswers(question: _question!, hardRefresh: true));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          child: ForumDiscussView(
                            question: _question!,
                            answers: _answers!,
                            isAuthenticated: widget.isAuthenticated,
                          ),
                        ),
                      ),
                      AddAnswerField(
                        onSend: (str, photos) async {
                          if (!widget.isAuthenticated) {
                            return showLoginDialog(context);
                          }

                          final answer = Answer(
                            title: str,
                            questionId: _question!.id,
                          );
                          context
                              .read<AnswerBloc>()
                              .add(AddAnswer(answer: answer, images: photos));
                        },
                      )
                    ],
                  ),
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

  final Forum question;
  final bool isAuthenticated;
  final List<Answer> answers;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadMoreText(
              question.title!,
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
            if (question.imageUrls.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ImageGallerySlider(images: question.imageUrls)));
                },
                child: ImageSlider(images: question.imageUrls),
              ),
            Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundImage:
                      CachedNetworkImageProvider(question.addedByAvatar!),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  question.addedByName!,
                  style: AppFonts.REGULAR_BLACK3_10,
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                  question.updatedAt!.formattedTime,
                  style: AppFonts.REGULAR_WHITE2_10,
                ),
                const Spacer(),
                Text(
                  question.category!,
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
                    margin: const EdgeInsets.only(right: 10),
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
                    key: ValueKey(answers[index].id),
                    answer: answers[index],
                  );
                }),
          ],
        ),
      ],
    );
  }
}
