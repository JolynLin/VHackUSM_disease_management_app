// lib/screens/reminder_scheduler.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReminderSchedulerPage extends StatefulWidget {
  const ReminderSchedulerPage({super.key});

  @override
  State<ReminderSchedulerPage> createState() => _ReminderSchedulerPageState();
}

class _ReminderSchedulerPageState extends State<ReminderSchedulerPage> {
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedType = "Capsules";
  List<String> selectedDays = [];
  String mealPreference = "After eat";
  bool enableNotification = true;

  final List<Map<String, dynamic>> types = [
    {"label": "Pills", "icon": Icons.medication},
    {"label": "Capsules", "icon": Icons.bubble_chart},
    {"label": "Liquid", "icon": Icons.water_drop},
    {"label": "Eyedrops", "icon": Icons.remove_red_eye},
    {"label": "Sachet", "icon": Icons.local_pharmacy},
  ];

  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final List<String> mealOptions = ["Before eat", "While eating", "After eat"];

  Future<void> saveReminder() async {
    if (medicineController.text.isEmpty || doseController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    final now = DateTime.now();
    final DateTime fullDate = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    await FirebaseFirestore.instance.collection("reminders").add({
      "medicine": medicineController.text,
      "dose": doseController.text,
      "type": selectedType,
      "time": fullDate,
      "days": selectedDays,
      "note": mealPreference,
      "notification": enableNotification,
      "createdAt": Timestamp.now(),
    });

    Fluttertoast.showToast(msg: "Reminder Saved");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text("Schedule your medicine"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose the type of medicine",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: types.length,
                itemBuilder: (context, index) {
                  final type = types[index];
                  final isSelected = selectedType == type['label'];
                  return GestureDetector(
                    onTap: () => setState(() => selectedType = type['label']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurpleAccent : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(type['icon'], color: isSelected ? Colors.white : Colors.black54),
                          const SizedBox(height: 5),
                          Text(
                            type['label'],
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: medicineController,
              decoration: InputDecoration(
                labelText: "Medicine name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: doseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Dose",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Select Days"),
            Wrap(
              spacing: 8,
              children: days.map((day) => FilterChip(
                label: Text(day),
                selected: selectedDays.contains(day),
                onSelected: (val) => setState(() {
                  val ? selectedDays.add(day) : selectedDays.remove(day);
                }),
              )).toList(),
            ),
            const SizedBox(height: 20),
            const Text("Select Time"),
            Row(
              children: [
                Text(DateFormat.jm().format(DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute))),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) setState(() => selectedTime = picked);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Meal Time Preference"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: mealOptions.map((option) => ChoiceChip(
                label: Text(option),
                selected: mealPreference == option,
                onSelected: (_) => setState(() => mealPreference = option),
              )).toList(),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: enableNotification,
              onChanged: (val) => setState(() => enableNotification = val),
              title: const Text("Enable Notification"),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: saveReminder,
                child: const Text("Save changes", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}