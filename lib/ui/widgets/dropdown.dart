import 'package:flutter/material.dart';
import 'package:covidoc/utils/const/const.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    Key key,
    this.title,
    this.onPressed,
    this.fillColor,
    this.borderRadius = 6,
    this.verticalPadding = 10,
    this.horizontalPadding = 15,
  }) : super(key: key);

  final String title;
  final Color fillColor;
  final double borderRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.WHITE4),
          ),
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          child: Row(
            children: [
              Expanded(child: Text(title, style: AppFonts.REGULAR_BLACK3_14)),
              const Icon(Icons.keyboard_arrow_down_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
