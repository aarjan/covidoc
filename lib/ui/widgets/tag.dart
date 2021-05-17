import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:covidoc/utils/const/const.dart';

///CONTAINER CONTAINING A TEXT WITH GREY BACKGROUND AND LITTLE PADDING
class Tag extends StatelessWidget {
  const Tag({Key? key, this.tag = '', this.dismissible = false})
      : super(key: key);
  final String tag;
  final bool dismissible;
  @override
  Widget build(BuildContext context) {
    // -----------------------------------------------------------------
    // CONTAINER CONTAINING A TEXT WITH GREY BACKGROUND
    // -----------------------------------------------------------------
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.WHITE5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            tag,
            style: AppFonts.REGULAR_WHITE2_14,
          ),
          if (dismissible) ...[
            const SizedBox(
              width: 10,
            ),
            SvgPicture.asset(
              'assets/forum/cross.svg',
              height: 10,
              width: 10,
            )
          ]
        ],
      ),
    );
  }
}
