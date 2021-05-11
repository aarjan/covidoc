import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/ui/widgets/image_slider.dart';

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
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                if (msg.documents.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ImageGallerySlider(images: msg.documents)));
                    },
                    child: Hero(
                      tag: msg.documents.first,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: msg.documents[0],
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Visibility(
                            visible: msg.documents.length > 1,
                            child: Container(
                              alignment: Alignment.center,
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '+ ${msg.documents.length - 1}',
                                style: AppFonts.BOLD_WHITE_30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 6,
                ),
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
