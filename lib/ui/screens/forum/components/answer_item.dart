import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

class AnswerItem extends StatelessWidget {
  final Answer answer;

  const AnswerItem({Key key, this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18.0,
                  backgroundImage:
                      CachedNetworkImageProvider(answer.addedByAvatar),
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
                    Text(answer.timestamp.formattedTime,
                        style: AppFonts.REGULAR_WHITE2_10),
                  ],
                )
              ],
            ),
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
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          answer.title,
          style: AppFonts.REGULAR_BLACK3_14,
        ),
        const Divider(
          height: 20.0,
          thickness: 1.5,
        )
      ],
    );
  }
}
