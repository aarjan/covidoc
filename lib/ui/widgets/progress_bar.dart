import 'package:flutter/material.dart';

class ProgressBar extends PreferredSize {
  final List<Color> colors;

  ProgressBar(this.colors);

  @override
  Widget get child => Row(
        children: colors
            .map((e) => Flexible(
                child: Container(color: e, width: double.infinity, height: 2)))
            .toList(),
      );
  @override
  Size get preferredSize => const Size(double.infinity, 2);
}
