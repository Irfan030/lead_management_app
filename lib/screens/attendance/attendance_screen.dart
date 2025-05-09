import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_management_app/providers/attendance_provider.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/sizeConfig.dart';
import 'package:leads_management_app/widgets/appbar.dart';
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter and History Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColor.cardBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                dropdownColor: AppColor.cardBackground,
                                value: provider.selectedFilter,
                                underline: const SizedBox(),
                                items: provider.filters.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  if (value != null) {
                                    provider.setFilter(value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendanceHistoryScreen(
                                  history: provider.filteredHistory,
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.history,
                            size: getProportionateScreenWidth(18),
                          ),
                          label: Text(
                            'History',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(14),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColor.mainColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    // Statistics Card
                    Card(
                      color: AppColor.cardBackground,
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
                                Text(
                                  'Monthly Overview',
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(18),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMMM yyyy')
                                      .format(DateTime.now()),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: getProportionateScreenWidth(14),
                                  ),
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
                                      provider.stats.averageWorkingHours
                                          .toStringAsFixed(1),
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
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    // Status Card
                    Center(
                      child: Card(
                        color: AppColor.cardBackground,
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
                                  provider.isCheckedIn
                                      ? Icons.login
                                      : Icons.logout,
                                  size: 48,
                                  color: provider.isCheckedIn
                                      ? AppColor.successColor
                                      : AppColor.errorColor,
                                ),
                              SizedBox(
                                  height: getProportionateScreenHeight(16)),
                              Text(
                                provider.statusMessage,
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: getProportionateScreenHeight(8)),
                              if (provider.currentPosition != null)
                                Text(
                                  'Location: ${provider.currentPosition!.latitude.toStringAsFixed(4)}, '
                                  '${provider.currentPosition!.longitude.toStringAsFixed(4)}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: getProportionateScreenWidth(12),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(24)),
                    // Check In/Out Button
                    SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(56),
                      child: ElevatedButton(
                        onPressed:
                            (provider.isLoading || provider.isLocationLoading)
                                ? null
                                : () => provider.handleAttendance(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: provider.isCheckedIn
                              ? AppColor.errorColor
                              : AppColor.successColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                provider.isCheckedIn ? 'CHECK OUT' : 'CHECK IN',
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    // Recent History
                    if (provider.filteredHistory.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent History',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Filter: ${provider.selectedFilter}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: getProportionateScreenWidth(12),
                            ),
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
                          return Card(
                            color: AppColor.cardBackground,
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
                                    ? AppColor.successColor.withOpacity(0.1)
                                    : AppColor.errorColor.withOpacity(0.1),
                                child: Icon(
                                  record.type == 'Check In'
                                      ? Icons.login
                                      : Icons.logout,
                                  color: record.type == 'Check In'
                                      ? AppColor.successColor
                                      : AppColor.errorColor,
                                ),
                              ),
                              title: Text(
                                record.type,
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(14),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('MMM dd, yyyy HH:mm')
                                        .format(record.timestamp),
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(12),
                                    ),
                                  ),
                                  if (record.officeLocation != null)
                                    Text(
                                      'Office: ${record.officeLocation}',
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(11),
                                      ),
                                    ),
                                ],
                              ),
                              trailing: record.lateness != null
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: record.lateness! > 0
                                            ? AppColor.errorColor
                                                .withOpacity(0.1)
                                            : AppColor.successColor
                                                .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        record.lateness! > 0
                                            ? 'Late ${record.lateness} min'
                                            : 'Early ${-record.lateness!} min',
                                        style: TextStyle(
                                          color: record.lateness! > 0
                                              ? AppColor.errorColor
                                              : AppColor.successColor,
                                          fontSize:
                                              getProportionateScreenWidth(10),
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
          Text(
            value,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: getProportionateScreenWidth(12),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AttendanceHistoryScreen extends StatelessWidget {
  final List<AttendanceRecord> history;

  const AttendanceHistoryScreen({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: const CustomAppBar(title: 'Attendance History'),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final record = history[index];
          return Card(
            color: AppColor.cardBackground,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        record.type,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (record.lateness != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: record.lateness! > 0
                                ? AppColor.errorColor.withOpacity(0.1)
                                : AppColor.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            record.lateness! > 0
                                ? 'Late ${record.lateness} min'
                                : 'Early ${-record.lateness!} min',
                            style: TextStyle(
                              color: record.lateness! > 0
                                  ? AppColor.errorColor
                                  : AppColor.successColor,
                              fontSize: getProportionateScreenWidth(12),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(8)),
                  Text(
                    DateFormat('MMM dd, yyyy HH:mm').format(record.timestamp),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: getProportionateScreenWidth(14),
                    ),
                  ),
                  if (record.officeLocation != null) ...[
                    SizedBox(height: getProportionateScreenHeight(8)),
                    Text(
                      'Office: ${record.officeLocation}',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                      ),
                    ),
                  ],
                  if (record.workingHours != null) ...[
                    SizedBox(height: getProportionateScreenHeight(8)),
                    Text(
                      'Working Hours: ${record.workingHours!.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
