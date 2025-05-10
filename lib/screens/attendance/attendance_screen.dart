import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/providers/attendance_provider.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/sizeConfig.dart';
import 'package:leads_management_app/widgets/defaultDropDown.dart';
import 'package:leads_management_app/widgets/text_button_with_icon.dart';
import 'package:leads_management_app/widgets/titleWidget.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
    // Check location permission when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().checkLocationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColor.scaffoldBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Filter and History Row
                    _buildFilterAndHistoryRow(provider),
                    SizedBox(height: getProportionateScreenHeight(16)),

                    // Statistics Card
                    _buildStatisticsCard(provider),
                    SizedBox(height: getProportionateScreenHeight(16)),

                    // Status Card
                    _buildStatusCard(provider),
                    SizedBox(height: getProportionateScreenHeight(24)),

                    // Check In/Out Button
                    _buildCheckInOutButton(provider),
                    SizedBox(height: getProportionateScreenHeight(16)),

                    // Recent History
                    if (provider.filteredHistory.isNotEmpty)
                      _buildRecentHistorySection(provider),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterAndHistoryRow(AttendanceProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 200,
          child: DefaultDropDown<String>(
            hint: 'Select Filter',
            label: 'Filter',
            value: provider.selectedFilter,
            listValues: provider.filters,
            onChange: (value) => provider.setFilter(value),
            getDisplayText: (value) => value,
            getValue: (value) => value,
          ),
        ),
        TextButtonWithIcon(
          text: 'History',
          onPressed: () {
            Navigator.pushNamed(context, RoutePath.attendanceHistory);
          },
          icon: Icons.history,
          iconSize: getProportionateScreenWidth(18),
          fontSize: getProportionateScreenWidth(14),
          textColor: AppColor.mainColor,
        ),
      ],
    );
  }

  Widget _buildStatisticsCard(AttendanceProvider provider) {
    return Card(
      color: AppColor.whiteColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TitleWidget(
                  val: 'Monthly Overview',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                TitleWidget(
                  val: DateFormat('MMMM yyyy').format(DateTime.now()),
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildStatItem(
                      'Total Days',
                      provider.stats.totalDays.toString(),
                      Icons.calendar_today,
                      Colors.blue,
                      constraints.maxWidth,
                    ),
                    _buildStatItem(
                      'Late Days',
                      provider.stats.lateDays.toString(),
                      Icons.warning,
                      Colors.orange,
                      constraints.maxWidth,
                    ),
                    _buildStatItem(
                      'Avg Hours',
                      provider.stats.averageWorkingHours.toStringAsFixed(1),
                      Icons.access_time,
                      Colors.green,
                      constraints.maxWidth,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(AttendanceProvider provider) {
    return Center(
      child: Card(
        color: AppColor.whiteColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (provider.isLocationLoading)
                const CircularProgressIndicator(
                  color: AppColor.mainColor,
                )
              else
                Icon(
                  provider.isCheckedIn ? Icons.login : Icons.logout,
                  size: 48,
                  color: provider.isCheckedIn
                      ? AppColor.successColor
                      : AppColor.errorColor,
                ),
              SizedBox(height: getProportionateScreenHeight(16)),
              TitleWidget(
                val: provider.statusMessage,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              if (provider.currentPosition != null)
                TitleWidget(
                  val:
                      'Location: ${provider.currentPosition!.latitude.toStringAsFixed(4)}, '
                      '${provider.currentPosition!.longitude.toStringAsFixed(4)}',
                  color: Colors.grey,
                  fontSize: 12,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInOutButton(AttendanceProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButtonWithIcon(
        text: provider.isCheckedIn ? 'CHECK OUT' : 'CHECK IN',
        onPressed: () => provider.handleAttendance(context),
        icon: provider.isCheckedIn ? Icons.logout : Icons.login,
        iconSize: getProportionateScreenWidth(24),
        fontSize: getProportionateScreenWidth(16),
        textColor: Colors.white,
        backgroundColor:
            provider.isCheckedIn ? AppColor.errorColor : AppColor.successColor,
        borderRadius: 12,
        isLoading: provider.isLoading,
      ),
    );
  }

  Widget _buildRecentHistorySection(AttendanceProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TitleWidget(
              val: 'Recent History',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            TitleWidget(
              val: 'Filter: ${provider.selectedFilter}',
              color: Colors.grey,
              fontSize: 12,
            ),
          ],
        ),
        SizedBox(height: getProportionateScreenHeight(12)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.filteredHistory.length,
          itemBuilder: (context, index) {
            final record = provider.filteredHistory[index];
            return _buildHistoryCard(record);
          },
        ),
      ],
    );
  }

  Widget _buildHistoryCard(AttendanceRecord record) {
    return Card(
      color: AppColor.whiteColor,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: record.type == 'Check In'
              ? AppColor.successColor.withAlphaDouble(0.1)
              : AppColor.errorColor.withAlphaDouble(0.1),
          child: Icon(
            record.type == 'Check In' ? Icons.login : Icons.logout,
            color: record.type == 'Check In'
                ? AppColor.successColor
                : AppColor.errorColor,
          ),
        ),
        title: TitleWidget(
          val: record.type,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(
              val: DateFormat('MMM dd, yyyy HH:mm').format(record.timestamp),
              fontSize: 12,
            ),
            if (record.officeLocation != null)
              TitleWidget(
                val: 'Office: ${record.officeLocation}',
                fontSize: 11,
              ),
          ],
        ),
        trailing: record.lateness != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: record.lateness! > 0
                      ? AppColor.errorColor.withAlphaDouble(0.1)
                      : AppColor.successColor.withAlphaDouble(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TitleWidget(
                  val: record.lateness! > 0
                      ? 'Late ${record.lateness} min'
                      : 'Early ${-record.lateness!} min',
                  color: record.lateness! > 0
                      ? AppColor.errorColor
                      : AppColor.successColor,
                  fontSize: 10,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color, double maxWidth) {
    final itemWidth = (maxWidth - 32) / 3; // 32 is the total padding
    return SizedBox(
      width: itemWidth,
      child: Column(
        children: [
          Icon(icon, color: color, size: getProportionateScreenWidth(28)),
          SizedBox(height: getProportionateScreenHeight(8)),
          TitleWidget(
            val: value,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          TitleWidget(
            val: label,
            color: Colors.grey,
            fontSize: 12,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
