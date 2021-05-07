import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

import 'discussion_count.dart';

class QuestionItem extends StatelessWidget {
  final Forum question;
  final void Function() onTap;
  const QuestionItem({this.question, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.WHITE4))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              maxLines: 2,
              softWrap: true,
              textAlign: TextAlign.start,
              style: AppFonts.REGULAR_BLACK3_14,
            ),
            const SizedBox(
              height: 10,
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
                SvgPicture.asset('assets/forum/calendar.svg'),
                const SizedBox(width: 6),
                Text(
                  question.timestamp.formattedTime,
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
                Visibility(
                  visible: question.ansCount > 0,
                  child: DiscussionCount(
                    count: question.ansCount ?? 0,
                    profilePics: question.recentUsersAvatar,
                  ),
                ),
                Text(
                  question.category,
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
