import 'package:flutter/material.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/dropdown.dart';

class DropdownFilter extends StatelessWidget {
  const DropdownFilter();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Dropdown(
          title: 'Category',
          fillColor: AppColors.WHITE4,
          onPressed: () {},
        )),
        const SizedBox(width: 10),
        Flexible(
            child: Dropdown(
          title: 'Sort by',
          fillColor: AppColors.WHITE4,
          onPressed: () {},
        )),
      ],
    );
  }
}
