import 'package:flutter/material.dart';

class AIDiagnosisScreen extends StatelessWidget {
  const AIDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Diagnosis")),
      body: const Center(child: Text("Enter symptoms for analysis.")),
    );
  }
}
