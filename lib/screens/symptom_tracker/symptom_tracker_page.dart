import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SymptomTrackerPage extends StatefulWidget {
  const SymptomTrackerPage({super.key});

  @override
  _SymptomTrackerPageState createState() => _SymptomTrackerPageState();
}

class _SymptomTrackerPageState extends State<SymptomTrackerPage> {
  DateTime selectedDate = DateTime.now();
  int selectedSeverity = 0;
  final TextEditingController _notesController = TextEditingController();

  final List<String> symptoms = [
    'Headache',
    'Fever',
    'Cough',
    'Fatigue',
    'Nausea',
    'Body Pain',
    'Sore Throat',
    'Dizziness',
  ];

  final Map<String, bool> selectedSymptoms = {};
  final Map<String, int> symptomSeverity = {};
  final List<Map<String, dynamic>> symptomHistory = [];

  @override
  void initState() {
    super.initState();
    for (var symptom in symptoms) {
      selectedSymptoms[symptom] = false;
      symptomSeverity[symptom] = 0;
    }
  }

  void _saveSymptomEntry() {
    final selectedSymptomsList = selectedSymptoms.entries
        .where((entry) => entry.value)
        .map((entry) => {
              'name': entry.key,
              'severity': symptomSeverity[entry.key],
            })
        .toList();

    if (selectedSymptomsList.isNotEmpty) {
      setState(() {
        symptomHistory.add({
          'date': selectedDate,
          'symptoms': selectedSymptomsList,
          'notes': _notesController.text,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Symptoms logged successfully!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFFB4E4BE),
        ),
      );

      // Reset form
      _notesController.clear();
      setState(() {
        for (var symptom in symptoms) {
          selectedSymptoms[symptom] = false;
          symptomSeverity[symptom] = 0;
        }
      });
    }
  }

  Widget _buildSeveritySelector(String symptom) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Severity:',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  symptomSeverity[symptom] = index + 1;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: symptomSeverity[symptom]! >= index + 1
                      ? const Color(0xFFC5A8FF)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  (index + 1).toString(),
                  style: GoogleFonts.poppins(
                    color: symptomSeverity[symptom]! >= index + 1
                        ? Colors.white
                        : Colors.black54,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Symptom Tracker',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFB4E4BE),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selector
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Color(0xFFC5A8FF)),
                title: Text(
                  'Date',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  DateFormat('MMMM dd, yyyy').format(selectedDate),
                  style: GoogleFonts.poppins(),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),

            // Symptoms Grid
            Text(
              'Select Symptoms',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: symptoms.length,
              itemBuilder: (context, index) {
                final symptom = symptoms[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedSymptoms[symptom] = !selectedSymptoms[symptom]!;
                      if (!selectedSymptoms[symptom]!) {
                        symptomSeverity[symptom] = 0;
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedSymptoms[symptom]!
                          ? const Color(0xFFA7D8F5)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedSymptoms[symptom]!
                            ? const Color(0xFFA7D8F5)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        symptom,
                        style: GoogleFonts.poppins(
                          color: selectedSymptoms[symptom]!
                              ? Colors.black
                              : Colors.black54,
                          fontWeight: selectedSymptoms[symptom]!
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Severity Selection for Selected Symptoms
            ...selectedSymptoms.entries
                .where((entry) => entry.value)
                .map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildSeveritySelector(entry.key),
                        ],
                      ),
                    ))
                ,

            // Notes Section
            const SizedBox(height: 20),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Additional Notes',
                labelStyle: GoogleFonts.poppins(),
                hintText: 'Add any additional details about your symptoms...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFB4E4BE)),
                ),
              ),
            ),

            // Save Button
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSymptomEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB4E4BE),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Symptoms',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // History Section
            if (symptomHistory.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text(
                'Recent History',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: symptomHistory.length,
                itemBuilder: (context, index) {
                  final entry = symptomHistory[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMMM dd, yyyy')
                                .format(entry['date'] as DateTime),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: (entry['symptoms'] as List)
                                .map((s) => Chip(
                                      label: Text(
                                        '${s['name']} (${s['severity']})',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: const Color(0xFFA7D8F5),
                                    ))
                                .toList(),
                          ),
                          if (entry['notes'].isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              entry['notes'],
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
} 