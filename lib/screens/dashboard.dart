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

  @override
  void initState() {
    super.initState();
    _loadCheckedInDates();
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
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildCheckInCard(alreadyCheckedIn),
            const SizedBox(height: 24),
            _buildCalendarCard(),
            const SizedBox(height: 24),
            _buildMenuSection(),
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
          "Medicine Reminder",
          "Set and track your medications",
          Icons.medication_outlined,
          '/reminder-scheduler',
        ),
        const SizedBox(height: 16),
        _buildDashboardCard(
          context,
          "Medicine Lookup",
          "Search for medicine information",
          Icons.search,
          '/medicine-lookup',
        ),
        const SizedBox(height: 16),
        _buildDashboardCard(
          context,
          "Symptom Checker",
          "Check your symptoms",
          Icons.healing,
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
