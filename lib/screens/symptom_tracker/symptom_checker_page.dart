import 'package:flutter/material.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({Key? key}) : super(key: key);

  @override
  _SymptomCheckerPageState createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final TextEditingController _symptomController = TextEditingController();
  Map<String, dynamic>? _result;
  List<String> _history = [];

  final List<String> _commonSymptoms = [
    'Fever',
    'Cough',
    'Headache',
    'Fatigue',
    'Sore throat',
    'Nausea',
    'Shortness of breath',
    'Dizziness',
    'Body aches',
    'Chest pain',
  ];

  void _analyzeSymptoms() {
    final input = _symptomController.text.toLowerCase().trim();
    if (input.isEmpty) return;

    _history.add(input);

    // Mock AI Logic (Replace with real model later)
    if (input.contains("fever") && input.contains("cough")) {
      _result = {
        'condition': 'Possible Flu or COVID-19',
        'advice': [
          'Rest in bed and stay hydrated',
          'Monitor your temperature',
          'Take over-the-counter fever reducers if needed',
          'Isolate yourself from others',
          'Contact your doctor for guidance',
        ],
        'urgency': 'high',
      };
    } else if (input.contains("headache")) {
      _result = {
        'condition': 'Possible Tension Headache',
        'advice': [
          'Rest in a quiet, dark room',
          'Stay hydrated with water',
          'Try gentle neck stretches',
          'Avoid bright screens',
          'Take recommended pain relievers if needed',
        ],
        'urgency': 'medium',
      };
    } else {
      _result = {
        'condition': 'General Health Advice',
        'advice': [
          'Keep monitoring your symptoms',
          'Maintain good hydration',
          'Get adequate rest',
          'Eat nutritious meals',
          'Contact your doctor if symptoms worsen',
        ],
        'urgency': 'low',
      };
    }

    setState(() {});
    _symptomController.clear();
  }

  void _selectSymptom(String symptom) {
    final current = _symptomController.text;
    if (!current.toLowerCase().contains(symptom.toLowerCase())) {
      _symptomController.text =
          current.isEmpty ? symptom : '$current, $symptom';
    }
  }

  void _clearAll() {
    setState(() {
      _symptomController.clear();
      _result = null;
      _history.clear();
    });
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'high':
        return Colors.red.shade50;
      case 'medium':
        return Colors.orange.shade50;
      default:
        return Colors.green.shade50;
    }
  }

  Color _getUrgencyIconColor(String urgency) {
    switch (urgency) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData _getUrgencyIcon(String urgency) {
    switch (urgency) {
      case 'high':
        return Icons.warning_rounded;
      case 'medium':
        return Icons.info_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      appBar: AppBar(
        title: const Text(
          "How Are You Feeling?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.refresh, size: 28),
              onPressed: _clearAll,
              tooltip: "Start Over",
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Common Symptoms",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children:
                  _commonSymptoms
                      .map(
                        (symptom) => Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.blue.shade100,
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => _selectSymptom(symptom),
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: Text(
                                symptom,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              "Describe Your Symptoms",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: _symptomController,
                maxLines: 3,
                style: const TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  hintText: "Example: I have a fever and headache",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade400,
                    fontFamily: 'Poppins',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(20),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.medical_information, size: 28),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _analyzeSymptoms,
                icon: const Icon(Icons.search_rounded, size: 28),
                label: const Text(
                  "Check Symptoms",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 32),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: _getUrgencyColor(_result!['urgency'] as String),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getUrgencyIcon(_result!['urgency'] as String),
                            size: 32,
                            color: _getUrgencyIconColor(
                              _result!['urgency'] as String,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _result!['condition'] as String,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Recommended Actions:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(_result!['advice'] as List<String>)
                          .map(
                            (advice) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 24,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      advice,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ],
            if (_history.isNotEmpty) ...[
              const SizedBox(height: 32),
              const Text(
                "Previous Symptoms",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(_history.length, (index) {
                final reversedIndex = _history.length - 1 - index;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.history,
                        size: 28,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      _history[reversedIndex],
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
