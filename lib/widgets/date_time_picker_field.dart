import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_management_app/theme/colors.dart';

class DateTimePickerField extends StatelessWidget {
  final DateTime date;
  final TimeOfDay time;
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;
  final String label;
  final bool isDate;

  const DateTimePickerField({
    Key? key,
    required this.date,
    required this.time,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.label,
    required this.isDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (isDate) {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColor.mainColor,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            onDateChanged(picked);
          }
        } else {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: time,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColor.mainColor,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            onTimeChanged(picked);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isDate ? Icons.date_range : Icons.access_time,
              color: AppColor.mainColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isDate
                  ? DateFormat('dd MMM, yyyy').format(date)
                  : time.format(context),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
