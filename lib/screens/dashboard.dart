// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/notification_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<String> _checkedInDates = {};

  // Sample health data (to be replaced with real data)
  final Map<String, dynamic> healthData = {
    'bloodPressure': {
      'systolic': 120,
      'diastolic': 80,
      'lastChecked': '2 hours ago',
      'status': 'normal',
    },
    'bloodSugar': {
      'value': 95,
      'unit': 'mg/dL',
      'lastChecked': '4 hours ago',
      'status': 'normal',
    },
    'heartRate': {
      'value': 72,
      'unit': 'bpm',
      'lastChecked': '2 hours ago',
      'status': 'normal',
    },
    'weight': {
      'value': 70,
      'unit': 'kg',
      'lastChecked': 'Today',
      'status': 'normal',
    },
    'temperature': {
      'value': 36.6,
      'unit': '°C',
      'lastChecked': '2 hours ago',
      'status': 'normal',
    },
  };

  List<DocumentSnapshot> _todayReminders = [];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadCheckedInDates();
    _loadTodayReminders();
  }

  Future<void> _initializeNotifications() async {
    await NotificationService.init();
    NotificationService.listenToMedicineReminders();
  }

  void _loadCheckedInDates() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('daily_logs').get();
    final dates = snapshot.docs.map((doc) {
      final timestamp = doc['date'] as Timestamp;
      return DateFormat('yyyy-MM-dd').format(timestamp.toDate());
    }).toSet();

    setState(() => _checkedInDates = dates);
  }

  Future<void> _loadTodayReminders() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await FirebaseFirestore.instance
        .collection('reminders')
        .where('time', isGreaterThanOrEqualTo: startOfDay)
        .where('time', isLessThan: endOfDay)
        .get();

    setState(() {
      _todayReminders = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedToday = DateFormat('yyyy-MM-dd').format(today);
    final alreadyCheckedIn = _checkedInDates.contains(formattedToday);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      appBar: AppBar(
        title: const Text(
          "Health Dashboard",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, size: 28),
            onPressed: () => Navigator.pushNamed(context, '/patient-profile'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _loadCheckedInDates();
          _loadTodayReminders();
          return Future.value();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeader(),
              const SizedBox(height: 16),
              _buildCompactCalendar(),
              const SizedBox(height: 16),
              _buildCheckInStrip(alreadyCheckedIn),
              const SizedBox(height: 16),
              _buildMedicineRemindersSection(),
              const SizedBox(height: 16),
              _buildHealthMetricsSection(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/health-tools'),
                  icon: const Icon(Icons.apps, size: 28),
                  label: const Text(
                    'More Health Tools',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.person,
                size: 36,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hi,",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Text(
                    "Mostafiz",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/patient-profile'),
              icon: const Icon(Icons.edit, size: 20),
              label: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.blue.shade200),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            "Your Health Metrics",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
        ),
        _buildBloodPressureCard(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                "Blood Sugar",
                "${healthData['bloodSugar']['value']}",
                healthData['bloodSugar']['unit'],
                healthData['bloodSugar']['lastChecked'],
                healthData['bloodSugar']['status'],
                Icons.water_drop,
                Colors.red.shade100,
                Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                "Heart Rate",
                "${healthData['heartRate']['value']}",
                healthData['heartRate']['unit'],
                healthData['heartRate']['lastChecked'],
                healthData['heartRate']['status'],
                Icons.favorite,
                Colors.pink.shade100,
                Colors.pink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                "Weight",
                "${healthData['weight']['value']}",
                healthData['weight']['unit'],
                healthData['weight']['lastChecked'],
                healthData['weight']['status'],
                Icons.monitor_weight,
                Colors.orange.shade100,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                "Temperature",
                "${healthData['temperature']['value']}",
                healthData['temperature']['unit'],
                healthData['temperature']['lastChecked'],
                healthData['temperature']['status'],
                Icons.thermostat,
                Colors.purple.shade100,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBloodPressureCard() {
    return Card(
      elevation: 4,
      color: Colors.blue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 32,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Blood Pressure",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      "Systolic",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      "${healthData['bloodPressure']['systolic']}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "/",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      "Diastolic",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      "${healthData['bloodPressure']['diastolic']}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                "Last checked: ${healthData['bloodPressure']['lastChecked']}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String unit,
    String lastChecked,
    String status,
    IconData icon,
    Color backgroundColor,
    Color iconColor,
  ) {
    return Card(
      elevation: 4,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                "$value $unit",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Last checked: $lastChecked",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInStrip(bool alreadyCheckedIn) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How Are You Feeling Today?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodOption('😊', 'Great'),
                _buildMoodOption('😌', 'Good'),
                _buildMoodOption('😕', 'Okay'),
                _buildMoodOption('😫', 'Bad'),
              ],
            ),
            if (!alreadyCheckedIn) ...[
              const SizedBox(height: 16),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/lifestyle-tracker'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "Start Health Check-In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMoodOption(String emoji, String label) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/lifestyle-tracker'),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCalendar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 24, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      "Recent Check-Ins",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _showFullCalendar(context),
                  icon: const Icon(Icons.expand_more),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Show only last 3 days of check-ins
            ...List.generate(3, (index) {
              final date = DateTime.now().subtract(Duration(days: index));
              final dateStr = DateFormat('yyyy-MM-dd').format(date);
              final isCheckedIn = _checkedInDates.contains(dateStr);
              final isToday = index == 0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isToday
                            ? Colors.blue.shade100
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('EEE').format(date),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isToday ? Colors.blue : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        DateFormat('MMM d').format(date),
                        style: TextStyle(
                          fontSize: 16,
                          color: isToday ? Colors.blue : Colors.black87,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isCheckedIn
                            ? Colors.green.shade100
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCheckedIn ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color: isCheckedIn ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isCheckedIn ? 'Checked In' : 'Not Checked',
                            style: TextStyle(
                              fontSize: 14,
                              color: isCheckedIn ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showFullCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Health Check-In History",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(2023, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        titleTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        leftChevronIcon: Icon(Icons.chevron_left, size: 24),
                        rightChevronIcon: Icon(Icons.chevron_right, size: 24),
                      ),
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        defaultTextStyle: const TextStyle(fontSize: 16),
                        weekendTextStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        outsideTextStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        holidayTextStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        disabledTextStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        cellMargin: const EdgeInsets.all(4),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(fontSize: 16),
                        weekendStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          final dateStr = DateFormat('yyyy-MM-dd').format(date);
                          if (_checkedInDates.contains(dateStr)) {
                            return Positioned(
                              bottom: 1,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        defaultBuilder: (context, day, focusedDay) {
                          final dateStr = DateFormat('yyyy-MM-dd').format(day);
                          final isCheckedIn = _checkedInDates.contains(dateStr);
                          return Container(
                            margin: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isCheckedIn ? Colors.green.shade50 : null,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isCheckedIn
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color:
                                    isCheckedIn ? Colors.green.shade700 : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegendItem("Today", Colors.blue.shade400),
                    _buildLegendItem("Selected", Colors.blue.shade700),
                    _buildLegendItem("Checked In", Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMedicineRemindersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            "Today's Medicine Schedule",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
        ),
        if (_todayReminders.isEmpty)
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 32,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "No medications scheduled for today",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...List.generate(
            _todayReminders.length > 3 ? 3 : _todayReminders.length,
            (index) {
              final reminder = _todayReminders[index];
              final time = (reminder['time'] as Timestamp).toDate();
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.medication_outlined,
                          size: 32,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reminder['medicine'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${reminder['type']}, ${reminder['dose']} ${(int.tryParse(reminder['dose']) ?? 1) > 1 ? "units" : "unit"}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat.jm().format(time),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reminder['note'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        if (_todayReminders.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/reminder-list'),
              child: Text(
                'View all ${_todayReminders.length} reminders',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, '/reminder-scheduler'),
            icon: const Icon(Icons.add_circle_outline, size: 24),
            label: const Text(
              "Add New Medication",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
