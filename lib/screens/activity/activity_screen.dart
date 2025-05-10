import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_management_app/theme/colors.dart';

class Activity {
  final String type;
  final String desc;
  final DateTime dateTime;
  final bool isCompleted;
  final IconData icon;
  final Color color;
  final String? assignedTo;

  Activity({
    required this.type,
    required this.desc,
    required this.dateTime,
    this.isCompleted = false,
    required this.icon,
    required this.color,
    this.assignedTo,
  });
}

class ActivityScreen extends StatefulWidget {
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
                    const Text(
                      'Activity Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      items: ['Call', 'Email', 'Meeting', 'Task'].map((type) {
                        IconData icon;
                        Color color;
                        switch (type) {
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
                        return DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Icon(icon, color: color),
                              const SizedBox(width: 8),
                              Text(type),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setSheetState(() => selectedType = val!),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
                    TextField(
                      controller: descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter activity details',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
                          child: InkWell(
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
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.date_range,
                                      color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(DateFormat('dd MMM, yyyy')
                                      .format(selectedDate)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
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
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(selectedTime.format(context)),
                                ],
                              ),
                            ),
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
                    DropdownButtonFormField<String>(
                      value: selectedUser,
                      items: ['Demo User', 'User A', 'User B'].map((user) {
                        return DropdownMenuItem(
                          value: user,
                          child: Text(user),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setSheetState(() => selectedUser = val!),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
                  child: DropdownButtonFormField<String>(
                    value: filterType,
                    items: types
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => filterType = val!),
                    decoration: InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: filterStatus,
                    items: statuses
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => filterStatus = val!),
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: filterUser,
                    items: users
                        .map((u) => DropdownMenuItem(
                              value: u,
                              child: Text(u),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => filterUser = val!),
                    decoration: InputDecoration(
                      labelText: 'User',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
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
                      return GestureDetector(
                        onTap: () {
                          _showActivityBottomSheet(
                            existingActivity: activity,
                            index: originalIndex,
                          );
                        },
                        child: Card(
                          color: AppColor.whiteColor,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: activity.color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        activity.icon,
                                        color: activity.color,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            activity.type,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            activity.assignedTo ?? 'Unassigned',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: activity.isCompleted
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        activity.isCompleted
                                            ? 'Completed'
                                            : 'Pending',
                                        style: TextStyle(
                                          color: activity.isCompleted
                                              ? Colors.green
                                              : Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  activity.desc,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('dd MMM, yyyy hh:mm a')
                                          .format(activity.dateTime),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
