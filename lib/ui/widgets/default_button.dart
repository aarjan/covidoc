import 'package:flutter/material.dart';
import 'package:covidoc/utils/const/const.dart';

class DefaultButton extends StatelessWidget {
  /// Default button
  ///
  /// [onTap] property for handling onTap gestures
  ///
  ///[title] property for the text to be displayed on the drop down

  const DefaultButton({
    Key key,
    this.onTap,
    this.title = '',
    this.textColor,
    this.border = false,
    this.borderRadius = 10,
    this.bgColor = AppColors.DEFAULT,
  }) : super(key: key);

  ///Function associated when the button is tapped
  final Function onTap;

  ///Text to be displayed on the button
  final String title;

  ///Background color of the button
  final Color bgColor;

  ///Text color of the text in the button
  final Color textColor;

  ///Should there be a border around the button or not
  final bool border;

  ///Circular radius for the border of the button
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ? Border.all(color: AppColors.WHITE5) : null,
          ),
          padding: const EdgeInsets.all(15),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: textColor == null
                ? AppFonts.REGULAR_WHITE_16
                : AppFonts.REGULAR_WHITE_16.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
