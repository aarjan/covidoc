import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:covidoc/utils/const/const.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'components.dart';

class QuestionItem extends StatelessWidget {
  const QuestionItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.WHITE4))),
      child: Column(
        children: [
          Text(
            'The commonest cause of UGI Bleeding in children is'
            ' a) variceal b) polyb c) duodenal ulcer',
            maxLines: 2,
            softWrap: true,
            style: AppFonts.REGULAR_BLACK3_14,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SvgPicture.asset('assets/forum/calendar.svg'),
              const SizedBox(width: 6),
              Text(
                'June 12, 1 hour ago',
                style: AppFonts.REGULAR_WHITE2_10,
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.WHITE4,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('ENT', style: AppFonts.REGULAR_WHITE2_10),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const CircleAvatar(
                radius: 10,
                backgroundImage: CachedNetworkImageProvider(
                    'https://lh6.googleusercontent.com/-OIwJt2XA8EM/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuck3gBspRFThmeOhR1_yvhtInFcfFg/s96-c/photo.jpg'),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                'Anne',
                style: AppFonts.REGULAR_BLACK3_10,
              ),
              const SizedBox(
                width: 30,
              ),
              const DiscussionCount(
                count: 120,
                profilePics: [
                  'https://lh6.googleusercontent.com/-OIwJt2XA8EM/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuck3gBspRFThmeOhR1_yvhtInFcfFg/s96-c/photo.jpg',
                  'https://lh6.googleusercontent.com/-OIwJt2XA8EM/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuck3gBspRFThmeOhR1_yvhtInFcfFg/s96-c/photo.jpg',
                  'https://lh6.googleusercontent.com/-OIwJt2XA8EM/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuck3gBspRFThmeOhR1_yvhtInFcfFg/s96-c/photo.jpg',
                  'https://lh6.googleusercontent.com/-OIwJt2XA8EM/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuck3gBspRFThmeOhR1_yvhtInFcfFg/s96-c/photo.jpg',
                ],
              ),
              Text(
                'Category1',
                style: AppFonts.REGULAR_DEFAULT_10,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(5),
                color: AppColors.GREEN1,
                child: SvgPicture.asset('assets/forum/pin.svg'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
