import 'package:disease_management_app/screens/medicine_lookup.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/symptom_checker.dart';
import 'screens/ai_diagnosis.dart';
import 'screens/discussion_forum.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disease Management',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/symptom-tracker': (context) => const SymptomCheckerPage(),
        '/ai-diagnosis': (context) => const AIDiagnosisScreen(),
        '/forum': (context) => const DiscussionForumScreen(),
        '/medicine-lookup': (context) => const MedicineLookupPage(),
      },
    );
  }
}
