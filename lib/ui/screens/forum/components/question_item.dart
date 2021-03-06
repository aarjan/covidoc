import 'package:covidoc/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';

import 'add_update_question_modal.dart';
import 'discussion_count.dart';

class QuestionItem extends StatelessWidget {
  final Forum question;
  final void Function() onTap;
  const QuestionItem({Key? key, required this.question, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.WHITE4))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ReadMoreText(
                    question.title!,
                    trimLines: 2,
                    colorClickableText: AppColors.DEFAULT,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    style: AppFonts.MEDIUM_BLACK3_16,
                    moreStyle: AppFonts.MEDIUM_DEFAULT_16,
                  ),
                ),
                _DiscussionPopUpMenu(question: question)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (question.imageUrls.isNotEmpty)
              ImageSlider(images: question.imageUrls),
            Row(
              children: [
                SvgPicture.asset('assets/forum/calendar.svg'),
                const SizedBox(width: 6),
                Text(
                  question.updatedAt!.formattedTime,
                  style: AppFonts.REGULAR_WHITE2_10,
                ),
                const SizedBox(width: 20),
                ...List.generate(
                  question.tags.length,
                  (index) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.WHITE4,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(question.tags[index],
                        style: AppFonts.REGULAR_WHITE2_10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
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
                Visibility(
                  visible: question.ansCount > 0,
                  child: DiscussionCount(
                    count: question.ansCount,
                    profilePics: question.recentUsersAvatar,
                  ),
                ),
                Text(
                  question.category!,
                  style: AppFonts.REGULAR_DEFAULT_10,
                ),
                const Spacer(),
                Visibility(
                  visible: question.isPinned,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    color: AppColors.GREEN1,
                    child: SvgPicture.asset('assets/forum/pin.svg'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _DiscussionPopUpMenu extends StatelessWidget {
  const _DiscussionPopUpMenu({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Forum question;

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserBloc b) => (b.state is UserLoadSuccess)
        ? (b.state as UserLoadSuccess).user
        : null);

    return PopupMenuButton<String>(
      onSelected: (str) async {
        final isAuthenticated = context.read<AuthBloc>().state is Authenticated;

        if (!isAuthenticated) {
          return showLoginDialog(context);
        }

        switch (str) {
          case 'delete':
            context.read<ForumBloc>().add(DeleteForum(question.id));
            break;
          case 'edit':
            return showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return AddUpdateQuestionModal(
                    question: question,
                    onSubmit: (txt, tags, category, images) {
                      final forum = question.copyWith(
                        tags: tags,
                        title: txt,
                        category: category,
                      );
                      context.read<ForumBloc>().add(UpdateForum(forum, images));
                    },
                  );
                });
          case 'report':
            return showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return ReportForumModal(
                  onSubmit: (String report, String reportType) {
                    context.read<ForumBloc>().add(
                          ReportForum(
                              report: report,
                              reportType: reportType,
                              details: {
                                'postType': 'ForumQuestion',
                                'forumId': question.id!,
                              }),
                        );
                    Navigator.pop(context);
                  },
                );
              },
            );
          default:
        }
      },
      icon: const Align(
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.more_vert,
          size: 20,
        ),
      ),
      padding: EdgeInsets.zero,
      itemBuilder: (context) => [
        if (user?.id == question.addedById)
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
        if (user?.id == question.addedById)
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
        const PopupMenuItem(
          value: 'report',
          child: Text('Report'),
        ),
      ],
    );
  }
}
