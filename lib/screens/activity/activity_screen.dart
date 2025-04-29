import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> allActivities = [];
  List<Map<String, dynamic>> filteredActivities = [];
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadDummyData();
    _applyFilter();
  }

  void _loadDummyData() {
    allActivities = [
      {
        'time': '09:00 AM',
        'type': 'Call',
        'assignedUser': 'Alex John',
        'linkedTo': 'Opportunity A',
        'status': 'Scheduled',
        'date': selectedDate,
      },
      {
        'time': '02:55 PM',
        'type': 'Meeting',
        'assignedUser': 'Pin.janna',
        'linkedTo': 'Sale Order B',
        'status': 'Scheduled',
        'date': selectedDate,
      },
      {
        'time': '11:00 AM',
        'type': 'Email',
        'assignedUser': 'Sara',
        'linkedTo': 'Opportunity B',
        'status': 'Scheduled',
        'date': selectedDate,
      },
    ];
  }

  void _applyFilter() {
    setState(() {
      filteredActivities = allActivities.where((activity) {
        final sameDate =
            activity['date'].day == selectedDate.day &&
            activity['date'].month == selectedDate.month &&
            activity['date'].year == selectedDate.year;

        final matchesFilter = selectedFilter == 'All'
            ? true
            : activity['type'] == selectedFilter;

        return sameDate && matchesFilter;
      }).toList();
    });
  }

  void _navigateMonth(bool forward) {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + (forward ? 1 : -1),
      );
      _applyFilter();
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      _applyFilter();
    });
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Call':
        return Colors.blue;
      case 'Meeting':
        return Colors.orange;
      case 'Email':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _handleAction(String action, Map<String, dynamic> activity) {
    switch (action) {
      case 'edit':
        _showDialog(
          'View/Edit',
          'You can show editable UI here for "${activity['type']}".',
        );
        break;
      case 'done':
        _showDialog(
          'Mark As Done',
          'You marked "${activity['type']}" as done.',
        );
        break;
      case 'cancel':
        _showDialog('Cancel', 'You cancelled "${activity['type']}".');
        break;
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMonthDays = List.generate(
      DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month),
      (i) => DateTime(selectedDate.year, selectedDate.month, i + 1),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM yyyy').format(selectedDate),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => _navigateMonth(false),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => _navigateMonth(true),
                    ),
                  ],
                ),
              ],
            ),

            // Scrollable Dates
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: currentMonthDays.length,
                itemBuilder: (context, index) {
                  final date = currentMonthDays[index];
                  final isSelected =
                      date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year;
                  return GestureDetector(
                    onTap: () => _onDateSelected(date),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('E').format(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
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

            const SizedBox(height: 12),

            // Filter Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedFilter,
                  items: ['All', 'Call', 'Meeting', 'Email']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedFilter = value;
                        _applyFilter();
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Activity List
            Expanded(
              child: filteredActivities.isEmpty
                  ? const Center(child: Text("No activities found"))
                  : ListView.builder(
                      itemCount: filteredActivities.length,
                      itemBuilder: (context, index) {
                        final activity = filteredActivities[index];
                        return Card(
                          color: _getTypeColor(
                            activity['type'],
                          ).withOpacity(0.1),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getTypeColor(activity['type']),
                              child: Text(
                                activity['time'].split(' ')[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            title: Text(
                              activity['type'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Assigned to: ${activity['assignedUser']}",
                                ),
                                Text("Linked to: ${activity['linkedTo']}"),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) =>
                                  _handleAction(value, activity),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('View / Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'done',
                                  child: Text('Mark As Done'),
                                ),
                                const PopupMenuItem(
                                  value: 'cancel',
                                  child: Text('Cancel'),
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
    );
  }
}
