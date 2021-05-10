import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

class SenderContent extends StatelessWidget {
  const SenderContent({
    Key key,
    @required this.msg,
  }) : super(key: key);

  final Message msg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            decoration: const BoxDecoration(
                color: AppColors.DEFAULT,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.zero,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(msg.message,
                    softWrap: true, style: AppFonts.REGULAR_WHITE_14),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(msg.timestamp.formattedTimes,
                        style: AppFonts.REGULAR_DEFAULT_12
                            .copyWith(color: AppColors.WHITE5)),
                    const SizedBox(
                      width: 4,
                    ),
                    SvgPicture.asset('assets/chat/read.svg'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiverContent extends StatelessWidget {
  const ReceiverContent({
    Key key,
    @required this.msg,
  }) : super(key: key);

  final Message msg;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: const BoxDecoration(
              color: AppColors.WHITE4,
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              alignment: WrapAlignment.end,
              spacing: 12,
              children: [
                Text(
                  msg.message,
                  style: AppFonts.REGULAR_BLACK3_14,
                ),
                Text(
                  msg.timestamp.formattedTimes,
                  textAlign: TextAlign.end,
                  style: AppFonts.REGULAR_WHITE2_11,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
