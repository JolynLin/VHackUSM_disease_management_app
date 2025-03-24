import 'package:flutter/material.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({Key? key}) : super(key: key);

  @override
  _SymptomCheckerPageState createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final TextEditingController _symptomController = TextEditingController();
  String _result = '';
  List<String> _history = [];

  final List<String> _commonSymptoms = [
    'Fever',
    'Cough',
    'Headache',
    'Fatigue',
    'Sore throat',
    'Nausea',
    'Shortness of breath'
  ];

  void _analyzeSymptoms() {
    final input = _symptomController.text.toLowerCase().trim();
    if (input.isEmpty) return;

    _history.add(input);

    // Mock AI Logic (Replace with real model later)
    if (input.contains("fever") && input.contains("cough")) {
      _result =
          "🦠 Possible Illness: Flu or COVID-19\n\n💡 Advice: Drink fluids, isolate, rest, and consult a doctor.";
    } else if (input.contains("headache")) {
      _result =
          "🧠 Possible Illness: Migraine or Stress-related headache\n\n💡 Advice: Reduce screen time, stay hydrated, rest in a dark room.";
    } else {
      _result =
          "✅ No major illness detected.\n\n💡 Advice: Keep monitoring, eat healthily, and stay hydrated.";
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
      _result = '';
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🧪 AI Symptom Checker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearAll,
            tooltip: "Clear All",
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Describe your symptoms or select from common ones:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _commonSymptoms
                  .map((symptom) => ActionChip(
                        label: Text(symptom),
                        onPressed: () => _selectSymptom(symptom),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _symptomController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Your symptoms",
                hintText: "e.g. fever, headache, cough",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _symptomController.clear(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text("Analyze Symptoms"),
                onPressed: _analyzeSymptoms,
              ),
            ),
            const SizedBox(height: 30),
            if (_result.isNotEmpty)
              Card(
                color: Colors.blue[50],
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _result,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (_history.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("📝 Symptom History",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._history.reversed.map((symptom) => ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(symptom),
                      ))
                ],
              )
          ],
        ),
      ),
    );
  }
}
