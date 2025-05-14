import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/providers/attendance_provider.dart';
import 'package:leads_management_app/screens/auth/splash_screen.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/size_config.dart';
import 'package:leads_management_app/widgets/appbar.dart';
import 'package:leads_management_app/widgets/title_widget.dart';
import 'package:provider/provider.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: const CustomAppBar(title: 'Attendance History'),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.filteredHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: getProportionateScreenWidth(64),
                    color:
                        ColorAlphaExtension(Colors.grey).withAlphaDouble(0.5),
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  const TitleWidget(
                    val: 'No Attendance History',
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  SizedBox(height: getProportionateScreenHeight(8)),
                  const TitleWidget(
                    val: 'Your attendance records will appear here',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: provider.filteredHistory.length,
            itemBuilder: (context, index) {
              final record = provider.filteredHistory[index];
              return _buildHistoryCard(record);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(AttendanceRecord record) {
    return Card(
      color: AppColor.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleWidget(
                  val: record.type,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                if (record.lateness != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: record.lateness! > 0
                          ? ColorAlphaExtension(AppColor.errorColor)
                              .withAlphaDouble(0.1)
                          : ColorAlphaExtension(AppColor.successColor)
                              .withAlphaDouble(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TitleWidget(
                      val: record.lateness! > 0
                          ? 'Late ${record.lateness} min'
                          : 'Early ${-record.lateness!} min',
                      color: record.lateness! > 0
                          ? AppColor.errorColor
                          : AppColor.successColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(8)),
            TitleWidget(
              val: DateFormat('MMM dd, yyyy HH:mm').format(record.timestamp),
              color: Colors.grey,
              fontSize: 14,
            ),
            if (record.officeLocation != null) ...[
              SizedBox(height: getProportionateScreenHeight(8)),
              TitleWidget(
                val: 'Office: ${record.officeLocation}',
                fontSize: 14,
              ),
            ],
            if (record.workingHours != null) ...[
              SizedBox(height: getProportionateScreenHeight(8)),
              TitleWidget(
                val:
                    'Working Hours: ${record.workingHours!.toStringAsFixed(1)}',
                fontSize: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
