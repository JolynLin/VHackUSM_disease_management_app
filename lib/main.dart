import 'package:disease_management_app/screens/medicine_lookup.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/symptom_checker.dart';
import 'screens/ai_diagnosis.dart';
import 'screens/discussion_forum.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/reminder_scheduler.dart';
import 'screens/daily_lifestyle_tracker.dart';
import 'screens/appointment_booking.dart';
import 'screens/booking_history.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'services/notification_service.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp();

  // Initialize notification service
  await NotificationService.init();


  // Start listening to appointments and medicine reminders
  NotificationService.listenToAppointments();
  NotificationService.listenToMedicineReminders();


  runApp(const MyApp());
}

// Helper method to request SMS permissions on Android
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disease Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
            minimumSize: const Size(200, 60),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          labelStyle: const TextStyle(fontSize: 18),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/symptom-tracker': (context) => const SymptomCheckerPage(),
        '/ai-diagnosis': (context) => const AIDiagnosisScreen(),
        '/forum': (context) => const DiscussionForumScreen(),
        '/medicine-lookup': (context) => const MedicineLookupPage(),
        '/reminder-scheduler': (context) => const ReminderSchedulerPage(),
        '/lifestyle-tracker': (context) => const DailyLifestyleTracker(),
        '/appointment-booking': (context) => const AppointmentBookingPage(),
        '/booking-history': (context) => const BookingHistoryPage(),
      },
    );
  }
}
