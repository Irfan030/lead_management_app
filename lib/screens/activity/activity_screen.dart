import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_management_app/screens/activity/activity_card.dart';
import 'package:leads_management_app/screens/activity/activity_model.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/date_time_picker_field.dart';
import 'package:leads_management_app/widgets/default_drop_down.dart';
import 'package:leads_management_app/widgets/default_text_input.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Activity> activities = [
    Activity(
      type: 'Call',
      desc:
          'Reached out to discuss product demo. Lead showed interest in pricing.',
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      isCompleted: true,
      icon: Icons.phone,
      color: Colors.red,
      assignedTo: 'Demo User',
    ),
    Activity(
      type: 'Email',
      desc: 'Shared pricing and contract details via email. Awaiting response.',
      dateTime: DateTime.now(),
      isCompleted: false,
      icon: Icons.email,
      color: Colors.green,
      assignedTo: 'Demo User',
    ),
    Activity(
      type: 'Meeting',
      desc: 'Scheduled Zoom call for a live demo on Friday at 2 PM.',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      isCompleted: false,
      icon: Icons.groups,
      color: Colors.blue,
      assignedTo: 'Demo User',
    ),
  ];

  DateTime currentDate = DateTime.now();
  int? selectedDay;
  String filterType = 'All';
  String filterStatus = 'All';
  String filterUser = 'All';

  List<int> getDaysInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return List<int>.generate(lastDay.day, (i) => i + 1);
  }

  List<Activity> get filteredActivities {
    return activities.where((activity) {
      final matchesType = filterType == 'All' || activity.type == filterType;
      final matchesStatus = filterStatus == 'All' ||
          (filterStatus == 'Completed'
              ? activity.isCompleted
              : !activity.isCompleted);
      final matchesUser =
          filterUser == 'All' || activity.assignedTo == filterUser;
      final matchesDay = selectedDay == null ||
          (activity.dateTime.year == currentDate.year &&
              activity.dateTime.month == currentDate.month &&
              activity.dateTime.day == selectedDay);
      return matchesType && matchesStatus && matchesUser && matchesDay;
    }).toList();
  }

  void _changeMonth(int offset) {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + offset);
      selectedDay = null;
    });
  }

  void _showActivityBottomSheet({Activity? existingActivity, int? index}) {
    final TextEditingController descController = TextEditingController(
      text: existingActivity?.desc ?? '',
    );

    DateTime selectedDate = existingActivity?.dateTime ?? DateTime.now();
    TimeOfDay selectedTime = existingActivity != null
        ? TimeOfDay.fromDateTime(existingActivity.dateTime)
        : TimeOfDay.now();

    String selectedType = existingActivity?.type ?? 'Call';
    String selectedUser = existingActivity?.assignedTo ?? 'Demo User';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.scaffoldBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          existingActivity != null
                              ? 'Edit Activity'
                              : 'New Activity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Activity Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DefaultDropDown<String>(
                      hint: 'Select Type',
                      label: 'Type',
                      value: selectedType,
                      listValues: const ['Call', 'Email', 'Meeting', 'Task'],
                      onChange: (val) =>
                          setSheetState(() => selectedType = val),
                      getDisplayText: (val) => val,
                      getValue: (val) => val,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DefaultTextInput(
                      controller: descController,
                      hint: 'Enter activity details',
                      label: 'Description',
                      maxlineHeight: 4,
                      onChange: () {},
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'When to remind?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DateTimePickerField(
                            date: selectedDate,
                            time: selectedTime,
                            onDateChanged: (date) =>
                                setSheetState(() => selectedDate = date),
                            onTimeChanged: (time) =>
                                setSheetState(() => selectedTime = time),
                            label: 'Date',
                            isDate: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DateTimePickerField(
                            date: selectedDate,
                            time: selectedTime,
                            onDateChanged: (date) =>
                                setSheetState(() => selectedDate = date),
                            onTimeChanged: (time) =>
                                setSheetState(() => selectedTime = time),
                            label: 'Time',
                            isDate: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Assigned To',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DefaultDropDown<String>(
                      hint: 'Select User',
                      label: 'User',
                      value: selectedUser,
                      listValues: const ['Demo User', 'User A', 'User B'],
                      onChange: (val) =>
                          setSheetState(() => selectedUser = val),
                      getDisplayText: (val) => val,
                      getValue: (val) => val,
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
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'DELETE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (existingActivity != null) const SizedBox(width: 8),
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

                              IconData icon;
                              Color color;
                              switch (selectedType) {
                                case 'Call':
                                  icon = Icons.phone;
                                  color = Colors.red;
                                  break;
                                case 'Email':
                                  icon = Icons.email;
                                  color = Colors.green;
                                  break;
                                case 'Meeting':
                                  icon = Icons.groups;
                                  color = Colors.blue;
                                  break;
                                default:
                                  icon = Icons.task;
                                  color = Colors.orange;
                              }

                              final newActivity = Activity(
                                type: selectedType,
                                desc: descController.text.trim(),
                                dateTime: newDateTime,
                                isCompleted:
                                    existingActivity?.isCompleted ?? false,
                                icon: icon,
                                color: color,
                                assignedTo: selectedUser,
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
                              backgroundColor: AppColor.mainColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'SAVE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    final users = ['All', 'Demo User', 'User A', 'User B'];
    final types = ['All', 'Call', 'Email', 'Meeting', 'Task'];
    final statuses = ['All', 'Completed', 'Pending'];

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Selector UI
          Container(
            color: AppColor.mainColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
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

                // Days Strip UI + Clear Button
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
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
                    ),
                    if (selectedDay != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          tooltip: 'Clear date filter',
                          onPressed: () {
                            setState(() {
                              selectedDay = null;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: DefaultDropDown<String>(
                    hint: 'Select Type',
                    label: 'Type',
                    value: filterType,
                    listValues: types,
                    onChange: (val) => setState(() => filterType = val),
                    getDisplayText: (val) => val,
                    getValue: (val) => val,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: DefaultDropDown<String>(
                    hint: 'Select Status',
                    label: 'Status',
                    value: filterStatus,
                    listValues: statuses,
                    onChange: (val) => setState(() => filterStatus = val),
                    getDisplayText: (val) => val,
                    getValue: (val) => val,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: DefaultDropDown<String>(
                    hint: 'Select User',
                    label: 'User',
                    value: filterUser,
                    listValues: users,
                    onChange: (val) => setState(() => filterUser = val),
                    getDisplayText: (val) => val,
                    getValue: (val) => val,
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
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = filteredActivities[index];
                      final originalIndex = activities.indexOf(activity);
                      return ActivityCard(
                        activity: activity,
                        onTap: () => _showActivityBottomSheet(
                          existingActivity: activity,
                          index: originalIndex,
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
