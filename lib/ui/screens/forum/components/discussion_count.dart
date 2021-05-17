import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:covidoc/utils/const/const.dart';

///WIDGET THAT SHOWS THE PROFILE PICS ONE ABOVE OTHER
///AND IF DISCUSSION COUNT IS GREATER THAN 4
///SHOWS THE COUNT TOO
class DiscussionCount extends StatelessWidget {
  const DiscussionCount({Key? key, this.count, this.profilePics})
      : super(key: key);
  final List<String>? profilePics;
  final int? count;
  @override
  Widget build(BuildContext context) {
    // -----------------------------------------------------------------
    // OFFSET FOR THE ADDING SPACE TO THE DYNAMIC DISCCOUNT COUNT
    // -----------------------------------------------------------------
    final maxPadding = count! > 4 ? 70.0 : count! * 15.0;

    return Padding(
      padding: EdgeInsets.only(right: maxPadding),
      // -----------------------------------------------------------------
      // STACK OF PROFILE PICS
      // -----------------------------------------------------------------
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // -----------------------------------------------------------------
          // IF COUNT OF THE DISCUSSIONS IS GREATER THAN 4
          // THEN SHOW THE TOTAL NUMBER IN CONTAINER
          // -----------------------------------------------------------------
          if (count! > 4)
            Transform.translate(
              offset: Offset((16 * profilePics!.length).toDouble(), 0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.WHITE5,
                ),
                child: Text(
                  '$count+',
                  style: AppFonts.REGULAR_BLACK3_10,
                ),
              ),
            ),
          // -----------------------------------------------------------------
          // GENERATING A REVERSE LIST OF ALL THE PROFILE PICS
          // WITH A LITTLE WHITE BORDER
          // REVERSED AS TO SHOW THE FIRST IMAGE ON TOP RATHER THAN BOTTOM
          // AND TRANSLATE IS USED TO SHIFT THE PIC BY 16 PIXELS FOR EACH INDEX
          // -----------------------------------------------------------------
          ...List.generate(
            profilePics!.length,
            (index) => Transform.translate(
              offset: Offset((16 * index).toDouble(), 0),
              child: CircleAvatar(
                radius: 11,
                foregroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 10,
                  backgroundImage: CachedNetworkImageProvider(
                    profilePics![index],
                  ),
                ),
              ),
            ),
          ).reversed,
        ],
      ),
    );
  }
}
