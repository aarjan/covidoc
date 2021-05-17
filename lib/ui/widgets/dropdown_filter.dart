import 'package:flutter/material.dart';
import 'package:covidoc/utils/const/const.dart';

class DropdownFilter extends StatefulWidget {
  const DropdownFilter({
    Key? key,
    this.title,
    this.items,
    this.fillColor,
    this.selectedCategory,
    this.borderRadius = 6,
    this.verticalPadding = 10,
    this.horizontalPadding = 15,
    required this.onItemSelected,
  }) : super(key: key);

  final String? title;
  final Color? fillColor;
  final List<String>? items;
  final double borderRadius;
  final double verticalPadding;
  final String? selectedCategory;
  final double horizontalPadding;
  final void Function(String val) onItemSelected;

  @override
  _DropdownFilterState createState() => _DropdownFilterState();
}

class _DropdownFilterState extends State<DropdownFilter> {
  String? _val;

  @override
  void initState() {
    super.initState();
    _val = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(6),
      child: Ink(
        decoration: BoxDecoration(
          color: widget.fillColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.WHITE4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: DropdownButton<String>(
          value: _val,
          isExpanded: true,
          hint: Text(widget.title!),
          style: AppFonts.REGULAR_BLACK3_14,
          underline: const SizedBox.shrink(),
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: widget.items!
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c, style: AppFonts.REGULAR_BLACK3_14),
                  ))
              .toList(),
          onChanged: (String? str) {
            _val = str;
            setState(() {});
            widget.onItemSelected(str!);
          },
        ),
      ),
    );
  }
}
