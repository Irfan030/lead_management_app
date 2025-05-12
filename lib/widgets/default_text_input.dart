import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/theme/colors.dart';

class DefaultTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String label;
  final String? type;
  final int? maxlineHeight;
  final Function onChange;
  final String errorMsg;
  final bool validator;
  final String value;
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
  final String? Function(String?)? customValidator;

  const DefaultTextInput({
    super.key,
    this.controller,
    required this.hint,
    required this.label,
    this.type,
    this.maxlineHeight = 1,
    this.validator = false,
    this.errorMsg = "Invalid value",
    this.value = "",
    required this.onChange,
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
    this.customValidator,
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
      validator: customValidator ?? (value) => validator ? errorMsg : null,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontFamily: AppData.poppinsMedium,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle: TextStyle(
          color: AppColor.textPrimary,
          fontSize: 16,
          fontFamily: AppData.poppinsMedium,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColor.textSecondary,
          fontSize: 12,
          fontFamily: AppData.poppinsMedium,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.mainColor),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
