import 'package:flutter/material.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/dropdown_filter.dart';

class Filters extends StatelessWidget {
  const Filters();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: DropdownFilter(
            title: 'Category',
            fillColor: AppColors.WHITE4,
            items: ['Category1', 'Category2', 'Category3'],
            onItemSelected: (val) {},
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: DropdownFilter(
            title: 'Sort',
            fillColor: AppColors.WHITE4,
            items: ['Sort1', 'Sort2', 'Sort3'],
            onItemSelected: (val) {},
          ),
        ),
      ],
    );
  }
}
