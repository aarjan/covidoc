import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:covidoc/utils/const/const.dart';

///Container for attached images inside the add question modal sheet
///will display the images and it's name from the property [imgFile]
///name will also be extracted from the same property
class AttachedImages extends StatelessWidget {
  const AttachedImages({Key key, this.imgFile, this.onRemove})
      : super(key: key);
  final File imgFile;
  final void Function() onRemove;

  @override
  Widget build(BuildContext context) {
    //getting the last index of the /, and adding 1 to it will give the start index of the
    //name of the file which will indeed can be used by extracting the subString
    final lastIndexOfSlash = imgFile.path.lastIndexOf('/') + 1;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.WHITE4,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // -----------------------------------------------------------------
          // ATTACHED IMAGE
          // -----------------------------------------------------------------
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.hardEdge,
            child: Image.file(
              imgFile,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // -----------------------------------------------------------------
          // NAME OF THE IMAGE
          // -----------------------------------------------------------------
          Expanded(
            child: Text(
              imgFile.path.substring(lastIndexOfSlash),
              overflow: TextOverflow.ellipsis,
              style: AppFonts.REGULAR_BLACK3_14,
            ),
          ),
          // -----------------------------------------------------------------
          // CLOSE BUTTON
          // -----------------------------------------------------------------
          IconButton(
            onPressed: onRemove,
            icon: SvgPicture.asset(
              'assets/forum/cross.svg',
              fit: BoxFit.scaleDown,
            ),
          ),
          const SizedBox(
            width: 5,
          )
        ],
      ),
    );
  }
}
