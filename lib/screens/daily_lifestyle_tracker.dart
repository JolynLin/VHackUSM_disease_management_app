// lib/screens/daily_lifestyle_tracker.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyLifestyleTracker extends StatefulWidget {
  const DailyLifestyleTracker({super.key});

  @override
  State<DailyLifestyleTracker> createState() => _DailyLifestyleTrackerState();
}

class _DailyLifestyleTrackerState extends State<DailyLifestyleTracker> {
  double sleepHours = 6;
  double waterIntake = 4;
  String mood = "😊";
  String meal = "Healthy";
  String activityLevel = "Moderate";

  final moods = ["😴", "😐", "😊", "😁", "😖"];
  final meals = ["Healthy", "Skipped", "Heavy"];
  final activities = ["Low", "Moderate", "Active"];

  void saveLog() async {
    await FirebaseFirestore.instance.collection('daily_logs').add({
      'date': Timestamp.now(),
      'sleep': sleepHours,
      'water': waterIntake,
      'mood': mood,
      'meal': meal,
      'activity': activityLevel,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "✅ Great job! Your daily check-in is saved.",
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate back to dashboard
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      appBar: AppBar(
        title: const Text(
          "Daily Check-In",
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
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            _buildSection(
              "How are you feeling today?",
              "Select your mood",
              "Current mood: $mood",
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: moods.map((m) => _buildChoiceChip(m, mood)).toList(),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              "Sleep Quality",
              "How many hours did you sleep?",
              "😴 ${sleepHours.toStringAsFixed(1)} hours",
              Column(
                children: [
                  Slider(
                    value: sleepHours,
                    min: 0,
                    max: 12,
                    divisions: 24,
                    label: "${sleepHours.toStringAsFixed(1)} hours",
                    onChanged: (val) => setState(() => sleepHours = val),
                    activeColor: Colors.teal,
                    thumbColor: Colors.tealAccent,
                  ),
                  Text(
                    sleepHours >= 7
                        ? "Great sleep duration! 🌟"
                        : "Try to get more sleep 😴",
                    style: TextStyle(
                      fontSize: 18,
                      color: sleepHours >= 7 ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              "Water Intake",
              "How many glasses of water did you drink?",
              "💧 ${waterIntake.toInt()} glasses",
              Column(
                children: [
                  Slider(
                    value: waterIntake,
                    min: 0,
                    max: 12,
                    divisions: 12,
                    label: "${waterIntake.toInt()} glasses",
                    onChanged: (val) => setState(() => waterIntake = val),
                    activeColor: Colors.indigo,
                    thumbColor: Colors.indigoAccent,
                  ),
                  Text(
                    waterIntake >= 8
                        ? "Excellent hydration! 💧"
                        : "Stay hydrated! 💦",
                    style: TextStyle(
                      fontSize: 18,
                      color: waterIntake >= 8 ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              " 🥗 Meal Quality",
              "How were your meals today?",
              "",
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: meals.map((m) => _buildChoiceChip(m, meal)).toList(),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              " 🏃 Activity Level",
              "How active were you today?",
              "",
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children:
                    activities
                        .map((a) => _buildChoiceChip(a, activityLevel))
                        .toList(),
              ),
            ),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.waving_hand, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Welcome to your Daily Check-In!",
                    style: TextStyle(
                      fontSize: 24, // slightly smaller for safety
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Let's track how you're feeling today and make sure you're taking good care of yourself.",
              style: TextStyle(fontSize: 18, color: Colors.white, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    String subtitle,
    String value,
    Widget content,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            if (value.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 20),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label, String selectedValue) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          color: selectedValue == label ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selectedValue == label,
      onSelected: (_) {
        setState(() {
          if (label == selectedValue) return;
          if (moods.contains(label)) mood = label;
          if (meals.contains(label)) meal = label;
          if (activities.contains(label)) activityLevel = label;
        });
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.blue.shade700,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selectedValue == label ? Colors.blue : Colors.grey.shade300,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton.icon(
        onPressed: saveLog,
        icon: const Icon(Icons.check_circle, size: 32),
        label: const Text(
          "Complete Daily Check-In",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
