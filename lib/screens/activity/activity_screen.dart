import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_management_app/theme/colors.dart';

class Activity {
  final String title;
  final String details;
  final DateTime dateTime;
  final bool isCompleted;

  Activity({
    required this.title,
    required this.details,
    required this.dateTime,
    this.isCompleted = false,
  });
}

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Activity> activities = [
    Activity(
      title: 'Cold Call',
      details:
          'Reached out to discuss product demo. Lead showed interest in pricing.',
      dateTime: DateTime.now().subtract(Duration(days: 3)),
      isCompleted: true,
    ),
    Activity(
      title: 'Send Proposal',
      details:
          'Shared pricing and contract details via email. Awaiting response.',
      dateTime: DateTime.now(),
      isCompleted: false,
    ),
    Activity(
      title: 'Product Demo',
      details: 'Scheduled Zoom call for a live demo on Friday at 2 PM.',
      dateTime: DateTime.now().add(Duration(days: 1)),
      isCompleted: false,
    ),
  ];

  DateTime currentDate = DateTime.now(); // holds current month & year
  int? selectedDay; // holds selected day (date)

  List<int> getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return List<int>.generate(lastDay.day, (i) => i + 1);
  }

  List<Activity> get filteredActivities {
    return activities.where((activity) {
      if (selectedDay == null) return true;
      return activity.dateTime.year == currentDate.year &&
          activity.dateTime.month == currentDate.month &&
          activity.dateTime.day == selectedDay;
    }).toList();
  }

  void _changeMonth(int offset) {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + offset);
      selectedDay = null; // Reset day when changing month
    });
  }

  void _showActivityBottomSheet({Activity? existingActivity, int? index}) {
    final TextEditingController nameController = TextEditingController(
      text: existingActivity?.title ?? '',
    );
    final TextEditingController detailsController = TextEditingController(
      text: existingActivity?.details ?? '',
    );

    DateTime selectedDate = existingActivity?.dateTime ?? DateTime.now();
    TimeOfDay selectedTime = existingActivity != null
        ? TimeOfDay.fromDateTime(existingActivity.dateTime)
        : TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Follow-up task name',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: detailsController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Details',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'When to remind?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                setSheetState(() => selectedDate = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.date_range,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    DateFormat(
                                      'dd MMM, yyyy',
                                    ).format(selectedDate),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (picked != null) {
                                setSheetState(() => selectedTime = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(selectedTime.format(context)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        if (existingActivity != null)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  activities.removeAt(index!);
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('DELETE'),
                            ),
                          ),
                        if (existingActivity != null) const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final newDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                              final newActivity = Activity(
                                title: nameController.text.trim(),
                                details: detailsController.text.trim(),
                                dateTime: newDateTime,
                              );
                              setState(() {
                                if (existingActivity != null) {
                                  activities[index!] = newActivity;
                                } else {
                                  activities.add(newActivity);
                                }
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('SAVE'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = getDaysInMonth(currentDate);

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Selector UI
          Container(
            color: AppColor.secondaryColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(currentDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () => _changeMonth(-1),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () => _changeMonth(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Days Strip UI
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    itemCount: daysInMonth.length,
                    itemBuilder: (context, index) {
                      final day = daysInMonth[index];
                      final date = DateTime(
                        currentDate.year,
                        currentDate.month,
                        day,
                      );
                      final isSelected = selectedDay == day;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDay = day;
                          });
                        },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.shade700
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('E').format(date),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '$day',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Activities List
          Expanded(
            child: filteredActivities.isEmpty
                ? const Center(
                    child: Text(
                      'No activities available',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = filteredActivities[index];
                      final originalIndex = activities.indexOf(activity);
                      return GestureDetector(
                        onTap: () {
                          _showActivityBottomSheet(
                            existingActivity: activity,
                            index: originalIndex,
                          );
                        },
                        child: Card(
                          color: activity.isCompleted
                              ? Colors.grey.shade300
                              : Colors.white,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  activity.details,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat(
                                    'dd MMM, yyyy hh:mm a',
                                  ).format(activity.dateTime),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.mainColor,
        onPressed: () => _showActivityBottomSheet(),
        child: Icon(Icons.add, color: AppColor.scaffoldBackground),
      ),
    );
  }
}
