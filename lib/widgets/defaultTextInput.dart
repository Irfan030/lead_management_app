import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';

class DefaultTextInput extends StatelessWidget {
  final String hint;
  final String label;
  final String? type;
  final int? maxlineHeight;
  final Function onChange;
  final String errorMsg;
  final bool validator;
  final String value;

  const DefaultTextInput({
    super.key,
    required this.hint,
    required this.label,
    this.type,
    this.maxlineHeight = 1,
    this.validator = false,
    this.errorMsg = "Invalid value",
    this.value = "",
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.justify,
      maxLines: maxlineHeight,
      onChanged: (value) {
        onChange(value);
      },
      initialValue: value,
      validator: (value) => validator ? errorMsg : null,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 10.0,
        ),
        fillColor: Colors.white,
        hintText: hint,
        labelText: label,

        labelStyle: TextStyle(
          color: AppColor.dividerColor,
          fontSize: 14,
          fontFamily: "PoppinsMedium",
        ),
        hintStyle: TextStyle(
          color: AppColor.secondaryColor,
          fontSize: 12,
          fontFamily: "PoppinsRegular",
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
