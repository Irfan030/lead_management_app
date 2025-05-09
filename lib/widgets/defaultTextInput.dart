import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool readOnly;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;

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
    this.controller,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.autofocus = false,
    this.readOnly = false,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textAlign: TextAlign.justify,
      maxLines: maxlineHeight,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      autofocus: autofocus,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      onChanged: (value) {
        onChange(value);
      },
      onFieldSubmitted: onSubmitted,
      initialValue: controller == null ? value : null,
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
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle: const TextStyle(
          color: AppColor.mainColor,
          fontSize: 14,
          fontFamily: "PoppinsMedium",
        ),
        hintStyle: const TextStyle(
          color: AppColor.dividerColor,
          fontSize: 12,
          fontFamily: "PoppinsRegular",
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
