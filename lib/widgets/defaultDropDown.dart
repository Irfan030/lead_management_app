import 'package:flutter/material.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/titleWidget.dart';

class DefaultDropDown<T> extends StatelessWidget {
  final String hint;
  final String label;
  final Function onChange;
  final List<T> listValues;
  final String value;
  final String errorMsg;
  final bool validator;
  final Function(T) getDisplayText;
  final Function(T) getValue;
  const DefaultDropDown({
    super.key,
    required this.hint,
    required this.label,
    required this.onChange,
    required this.value,
    required this.listValues,
    this.validator = false,
    this.errorMsg = "Invalid value",
    required this.getDisplayText,
    required this.getValue,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(),
      child: DropdownButtonFormField(
        value: value == "" ? null : value,
        validator: (value) => validator ? errorMsg : null,
        icon: Icon(Icons.keyboard_arrow_down_rounded),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 10.0,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          labelStyle: TextStyle(
            color: AppColor.iconColor,
            fontSize: 14,
            fontFamily: AppData.openSansMedium,
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
        hint: Text(
          hint.toString(),
          style: TextStyle(
            color: AppColor.secondaryColor,
            fontSize: 12,
            fontFamily: AppData.openSansMedium,
          ),
        ),
        onChanged: (value) {
          onChange(value);
          // getUserDetail();
        },
        // validator: (value) {
        //   if (value == hint) {
        //     return 'This field is required ';
        //   }
        //   return null;
        // },
        items: listValues.map((e) {
          return DropdownMenuItem(
            value: getValue(e),
            child: Container(
              margin: const EdgeInsets.all(0.0),
              child: TitleWidget(
                val: getDisplayText(e),
                color: AppColor.dividerColor,
                fontFamily: AppData.openSansRegular,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
