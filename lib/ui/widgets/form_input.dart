import 'package:covidoc/utils/const/const.dart';
import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  const FormInput({
    Key key,
    this.title,
    this.onEdit,
    this.onSave,
    this.onValidate,
    this.initialValue,
    this.minLines = 1,
    this.maxLines = 1,
    this.enabled = true,
    this.isNumber = false,
  }) : super(key: key);

  final String title;
  final int minLines;
  final int maxLines;
  final bool isNumber;
  final bool enabled;
  final String initialValue;
  final void Function() onEdit;
  final void Function(String) onSave;
  final String Function(String) onValidate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onSaved: onSave,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      validator: onValidate,
      onEditingComplete: onEdit,
      initialValue: initialValue,
      keyboardType: isNumber ? TextInputType.number : null,
      decoration: InputDecoration(
        hintText: title,
        labelText: title,
        alignLabelWithHint: true,
        hintStyle: AppFonts.MEDIUM_WHITE3_16,
        filled: true,
        fillColor: AppColors.WHITE1,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.WHITE4)),
      ),
    );
  }
}
