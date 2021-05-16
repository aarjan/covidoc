import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:readmore/readmore.dart';

import 'update_answer_modal.dart';

class AnswerItem extends StatelessWidget {
  final Answer answer;

  const AnswerItem({Key key, this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18.0,
              backgroundImage: CachedNetworkImageProvider(answer.addedByAvatar),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  answer.addedByName,
                  style: AppFonts.REGULAR_BLACK3_14,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(answer.updatedAt.formattedTime,
                    style: AppFonts.REGULAR_WHITE2_10),
              ],
            ),
            const Spacer(),
            Visibility(
              visible: answer.isBestAnswer ?? false,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.GREEN1,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(5),
                child: Text('Best Answer', style: AppFonts.REGULAR_DEFAULT_10),
              ),
            ),
            _DiscussionPopUpMenu(answer: answer),
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        ReadMoreText(
          answer.title,
          trimLines: 2,
          colorClickableText: AppColors.DEFAULT,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          style: AppFonts.REGULAR_BLACK3_14,
          moreStyle: AppFonts.MEDIUM_DEFAULT_14,
        ),
        if (answer.imageUrls.isNotEmpty)
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          ImageGallerySlider(images: answer.imageUrls)));
            },
            child: ImageSlider(images: answer.imageUrls),
          ),
        const Divider(
          height: 20.0,
          thickness: 1.5,
        )
      ],
    );
  }
}

class _DiscussionPopUpMenu extends StatelessWidget {
  const _DiscussionPopUpMenu({
    Key key,
    @required this.answer,
  }) : super(key: key);

  final Answer answer;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (str) {
        final isAuthenticated = context.read<AuthBloc>().state is Authenticated;

        if (!isAuthenticated) {
          return showLoginDialog(context);
        }

        switch (str) {
          case 'delete':
            context
                .read<AnswerBloc>()
                .add(DeleteAnswer(answer.questionId, answer.id));
            break;
          case 'edit':
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return UpdateAnswerModal(
                    text: answer.title,
                    images: answer.imageUrls
                        .map((e) => Photo(source: PhotoSource.Network, url: e))
                        .toList(),
                    onSend: (str, images) {
                      final nAnswer = answer.copyWith(title: str);

                      context
                          .read<AnswerBloc>()
                          .add(UpdateAnswer(answer: nAnswer, images: images));

                      Navigator.pop(context);
                    },
                  );
                });
            break;
          case 'report':
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return ReportForumModal(
                  onSubmit: (String report, String reportType) {
                    Navigator.pop(context);
                  },
                );
              },
            );
            break;
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
        const PopupMenuItem(
          child: Text('Edit'),
          value: 'edit',
          height: 36,
        ),
        const PopupMenuItem(
          child: Text('Delete'),
          value: 'delete',
          height: 36,
        ),
        const PopupMenuItem(
          child: Text('Report'),
          value: 'report',
          height: 36,
        ),
      ],
    );
  }
}
