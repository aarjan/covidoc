import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';

class PendingStatus extends StatelessWidget {
  const PendingStatus({
    Key? key,
    this.request,
  }) : super(key: key);

  final MessageRequest? request;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.WHITE5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            request!.message!,
            softWrap: true,
            style: AppFonts.MEDIUM_BLACK3_16,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                request!.postedAt!.formattedTime,
                style: AppFonts.REGULAR_WHITE3_12,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.WHITE5,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Pending',
                  style: AppFonts.REGULAR_BLACK3_12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MsgRequest extends StatelessWidget {
  const MsgRequest({
    Key? key,
    this.request,
    this.onSubmit,
  }) : super(key: key);

  final MessageRequest? request;
  final void Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    final patInfo =
        '${request!.patDetail!["gender"]}, ${request!.patDetail!["age"]}';
    final fullname = request!.postedAnonymously
        ? 'Anonymous'
        : request!.patDetail!['fullname'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.WHITE5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              request!.postedAnonymously
                  ? CircleAvatar(
                      radius: 22,
                      child: SvgPicture.asset('assets/register/patient.svg'),
                    )
                  : CircleAvatar(
                      radius: 22,
                      backgroundImage: CachedNetworkImageProvider(
                          request!.patDetail!['avatar']),
                    ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullname,
                      style: AppFonts.MEDIUM_BLACK3_14,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      patInfo,
                      style: AppFonts.MEDIUM_BLACK3_14,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      request!.postedAt!.formattedTime,
                      style: AppFonts.REGULAR_BLACK3_12,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onSubmit,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.DEFAULT,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Consult Now',
                    style: AppFonts.MEDIUM_WHITE_14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            request!.message!,
            softWrap: true,
            style: AppFonts.MEDIUM_BLACK3_16,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [],
          ),
        ],
      ),
    );
  }
}
