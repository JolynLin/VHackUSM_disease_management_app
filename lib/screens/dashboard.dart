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
    _loadCheckedInDates();
    _loadTodayReminders();
  }

  void _loadCheckedInDates() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('daily_logs').get();
    final dates =
        snapshot.docs.map((doc) {
          final timestamp = doc['date'] as Timestamp;
          return DateFormat('yyyy-MM-dd').format(timestamp.toDate());
        }).toSet();

    setState(() => _checkedInDates = dates);
  }

  Future<void> _loadTodayReminders() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot =
        await FirebaseFirestore.instance
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
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _loadCheckedInDates();
          _loadTodayReminders();
          return Future.value();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildCheckInCard(alreadyCheckedIn),
              const SizedBox(height: 24),
              _buildMedicineRemindersSection(),
              const SizedBox(height: 24),
              _buildHealthMetricsSection(),
              const SizedBox(height: 24),
              _buildCalendarCard(),
              const SizedBox(height: 24),
              _buildMenuSection(),
            ],
          ),
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

  Widget _buildCheckInCard(bool alreadyCheckedIn) {
    return Card(
      elevation: 4,
      color: alreadyCheckedIn ? Colors.green.shade100 : Colors.orange.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  alreadyCheckedIn ? Icons.check_circle : Icons.pending_actions,
                  size: 48,
                  color: alreadyCheckedIn ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alreadyCheckedIn
                            ? "Daily Check-In Completed"
                            : "Daily Check-In Required",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alreadyCheckedIn
                            ? "Great job! You've logged your health for today."
                            : "Take a moment to complete your health check-in.",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: alreadyCheckedIn ? Colors.grey : Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  alreadyCheckedIn ? Icons.check_circle : Icons.add_circle,
                  size: 32,
                ),
                label: Text(
                  alreadyCheckedIn ? "Completed" : "Check In Now",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed:
                    () => Navigator.pushNamed(context, '/lifestyle-tracker'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 32, color: Colors.blue),
                const SizedBox(width: 12),
                const Text(
                  "Health Check-In Calendar",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
                leftChevronIcon: Icon(Icons.chevron_left, size: 32),
                rightChevronIcon: Icon(Icons.chevron_right, size: 32),
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
                defaultTextStyle: const TextStyle(fontSize: 18),
                weekendTextStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                outsideTextStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                holidayTextStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                disabledTextStyle: const TextStyle(
                  fontSize: 18,
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
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 28,
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
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isCheckedIn ? Colors.green.shade50 : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            isCheckedIn ? FontWeight.bold : FontWeight.normal,
                        color: isCheckedIn ? Colors.green.shade700 : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem("Today", Colors.blue.shade400),
                _buildLegendItem("Selected", Colors.blue.shade700),
                _buildLegendItem("Checked In", Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
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
            onPressed:
                () => Navigator.pushNamed(context, '/reminder-scheduler'),
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

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Health Tools",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildDashboardCard(
          context,
          "Appointment Booking",
          "Schedule your medical appointments",
          Icons.calendar_month,
          '/appointment-booking',
        ),
        const SizedBox(height: 16),
        _buildDashboardCard(
          context,
          "Medicine Information",
          "Find details about your medicines",
          Icons.medication,
          '/medicine-lookup',
        ),
        const SizedBox(height: 16),
        _buildDashboardCard(
          context,
          "How Are You Feeling?",
          "Check your health symptoms",
          Icons.health_and_safety,
          '/symptom-tracker',
        ),
        const SizedBox(height: 16),
        _buildDashboardCard(
          context,
          "AI Diagnosis",
          "Get AI-powered health insights",
          Icons.smart_toy_outlined,
          '/ai-diagnosis',
        ),
        const SizedBox(height: 16),
        _buildDashboardCard(
          context,
          "Community Forum",
          "Connect with others",
          Icons.people_outline,
          '/forum',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () async {
                try {
                  // First run the debug check to see if notifications are enabled
                  await NotificationService.debugNotificationSettings();

                  // Then send the regular test notifications
                  await NotificationService.sendTestNotifications();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Test notifications sent! Check your device in a minute.',
                        style: TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error: ${e.toString()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.notifications_active, size: 28),
              label: const Text(
                'Test Reminders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 36, color: Colors.blue),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
