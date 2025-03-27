import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool isInitialized = false;

  // Initialize the notification service
  static Future<void> init() async {
    if (isInitialized) return;

    // Initialize timezone data
    tz_data.initializeTimeZones();

    // Set up Android notification settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    final platform = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (platform != null) {
      final hasPermission = await platform.areNotificationsEnabled();
      if (hasPermission == null || hasPermission == false) {
        print('Notification permission denied');
        return; // Exit if permissions are denied
      }
    }

    // Create notification channels for Android
    await platform?.createNotificationChannel(
      const AndroidNotificationChannel(
        'medicine_channel',
        'Medicine Reminders',
        description: 'Reminders to take your medications',
        importance: Importance.high,
        playSound: true,
      ),
    );

    await platform?.createNotificationChannel(
      const AndroidNotificationChannel(
        'appointment_channel',
        'Appointment Reminders',
        description: 'Reminders for upcoming appointments',
        importance: Importance.high,
        playSound: true,
      ),
    );

    // Initialize the plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification tapped: ${details.payload}');
      },
    );

    isInitialized = true;
    print('Notification service initialized');

    // Start listening for new appointments
    listenToAppointments();
  }

  // Schedule a notification
  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String channelId,
    String? payload,
  }) async {
    if (!isInitialized) {
      print('Notification service not initialized');
      await init();
    }

    try {
      // Check if the scheduled time is in the future
      if (scheduledTime.isBefore(DateTime.now())) {
        print('Cannot schedule notification for past time: $scheduledTime');
        return;
      }

      // Create a unique ID based on timestamp
      final id = DateTime.now().millisecondsSinceEpoch % 100000;

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        _createNotificationDetails(
          channelId,
          channelId == 'medicine_channel'
              ? 'Medicine Reminders'
              : 'Appointment Reminders',
          channelId == 'medicine_channel'
              ? 'Reminders to take your medications'
              : 'Reminders for upcoming appointments',
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      print('Notification scheduled for $scheduledTime');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  // Send test notifications
  static Future<void> sendTestNotifications() async {
    if (!isInitialized) {
      await init();
    }

    try {
      // Immediate test notification
      final testId = DateTime.now().millisecondsSinceEpoch % 100000;
      await _notifications.show(
        testId,
        'Test Notification 🔔',
        'This is an immediate test notification',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medicine_channel',
            'Medicine Reminders',
            channelDescription: 'Reminders to take your medications',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            styleInformation: null,
          ),
        ),
        payload: 'test_notification',
      );

      // Schedule a notification in 1 minute
      final scheduledTime = DateTime.now().add(const Duration(minutes: 1));
      await scheduleNotification(
        title: 'Scheduled Test 🕒',
        body: 'This notification was scheduled for 1 minute after the test',
        scheduledTime: scheduledTime,
        channelId: 'appointment_channel',
        payload: 'test_scheduled',
      );

      print('Test notifications sent successfully');
    } catch (e) {
      print('Error sending test notifications: $e');
    }
  }

  // Debug notification settings
  static Future<void> debugNotificationSettings() async {
    if (!isInitialized) {
      await init();
    }

    try {
      // Check if notifications are enabled on Android
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        final bool? areNotificationsEnabled =
            await androidPlugin.areNotificationsEnabled();
        print('Notifications enabled: $areNotificationsEnabled');
      }

      // Send a simple test notification for debugging
      final debugId = DateTime.now().millisecondsSinceEpoch % 100000;
      await _notifications.show(
        debugId,
        'Debug Notification 🔧',
        'If you see this, notifications are working!',
        _createNotificationDetails(
          'debug_channel',
          'Debug Notifications',
          'For debugging notification issues',
        ),
      );

      print('Debug notification sent with ID: $debugId');
    } catch (e) {
      print('Error during notification debugging: $e');
    }
  }

  // Listen for appointment reminders in Firestore
  static void listenToAppointments() {
    try {
      FirebaseFirestore.instance.collection('appointments').snapshots().listen((
        snapshot,
      ) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data() as Map<String, dynamic>;

            if (!data.containsKey('date') ||
                !data.containsKey('doctor') ||
                !data.containsKey('clinic')) {
              continue;
            }

            final doctor = data['doctor'] as String;
            final clinic = data['clinic'] as String;
            final dateTimestamp = data['date'] as Timestamp;
            final date = dateTimestamp.toDate();
            final timeStr = data['time'] as String? ?? '';

            // Parse time string (format: "10:30 AM")
            DateTime scheduledTime = date;
            if (timeStr.isNotEmpty) {
              final parts = timeStr.split(' ');
              if (parts.length == 2) {
                final timeParts = parts[0].split(':');
                if (timeParts.length == 2) {
                  int hour = int.tryParse(timeParts[0]) ?? 0;
                  final minute = int.tryParse(timeParts[1]) ?? 0;
                  final isPM = parts[1].toUpperCase() == 'PM';

                  // Convert to 24-hour format
                  if (isPM && hour != 12) hour += 12;
                  if (!isPM && hour == 12) hour = 0;

                  scheduledTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    hour,
                    minute,
                  );
                }
              }
            }

            // Send single notification with all details
            _notifications.show(
              DateTime.now().millisecondsSinceEpoch % 100000,
              'Appointment Booked ✅',
              'Your appointment is scheduled with Dr. $doctor at $clinic\n${DateFormat('MMM dd, yyyy').format(scheduledTime)} at ${DateFormat('hh:mm a').format(scheduledTime)}',
              _createNotificationDetails(
                'appointment_channel',
                'New Appointment',
                'Appointment booking confirmation',
              ),
            );
          }
        }
      });

      print('Listening to appointment reminders');
    } catch (e) {
      print('Error setting up appointment reminder listener: $e');
    }
  }

  // Listen for medicine reminders in Firestore
  static void listenToMedicineReminders() {
    try {
      FirebaseFirestore.instance.collection('reminders').snapshots().listen((
        snapshot,
      ) {
        for (var doc in snapshot.docs) {
          final data = doc.data();

          if (!data.containsKey('medicine') || !data.containsKey('time')) {
            continue;
          }

          final medicine = data['medicine'] as String;
          final timestamp = data['time'] as Timestamp;
          final time = timestamp.toDate();
          final dose = data['dose'] as String? ?? '';
          final type = data['type'] as String? ?? '';

          // Only schedule for future reminders
          if (time.isAfter(DateTime.now())) {
            scheduleNotification(
              title: 'Medicine Reminder 💊',
              body:
                  'Time to take $medicine${dose.isNotEmpty ? ' - $dose' : ''}${type.isNotEmpty ? ' $type' : ''}',
              scheduledTime: time,
              channelId: 'medicine_channel',
              payload: doc.id,
            );
          }
        }
      });

      print('Listening to medicine reminders');
    } catch (e) {
      print('Error setting up medicine reminder listener: $e');
    }
  }

  // Create standard notification details
  static NotificationDetails _createNotificationDetails(
    String channelId,
    String title,
    String description,
  ) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        title,
        channelDescription: description,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        styleInformation: null,
        icon: '@mipmap/ic_launcher',
        showWhen: true,
        autoCancel: true,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.message,
      ),
    );
  }
}
