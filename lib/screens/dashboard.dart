import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Disease Management Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/symptom-tracker'),
              child: const Text("Symptom Checker"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/ai-diagnosis'),
              child: const Text("AI Diagnosis"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/forum'),
              child: const Text("Community Forum"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/medicine-lookup'),
              child: const Text("Medicine Lookup"),
            ),
          ],
        ),
      ),
    );
  }
}
