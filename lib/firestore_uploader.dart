import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final data = await rootBundle.loadString('assets/firestore_data.json');
  final Map<String, dynamic> jsonData = json.decode(data);

  final medicineData = jsonData['medicines'] as Map<String, dynamic>;
  final firestore = FirebaseFirestore.instance;

  for (final entry in medicineData.entries) {
    final id = entry.key;
    final fields = entry.value;
    await firestore.collection('medicines').doc(id).set(fields);
    print('Uploaded: $id');
  }

  print('✅ All data uploaded successfully!');
}
