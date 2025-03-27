import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentHistoryDetails extends StatefulWidget {
  final String appointmentId;
  final String doctorName;
  final String hospitalName;
  final String date;
  final String time;

  const AppointmentHistoryDetails({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.hospitalName,
    required this.date,
    required this.time,
  });

  @override
  State<AppointmentHistoryDetails> createState() =>
      _AppointmentHistoryDetailsState();
}

class _AppointmentHistoryDetailsState extends State<AppointmentHistoryDetails> {
  Future<Map<String, dynamic>>? _appointmentDetailsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentDetailsFuture = _getAppointmentDetails();
  }

  Future<Map<String, dynamic>> _getAppointmentDetails() async {
    // Default hardcoded data - will be used if Firebase fetch fails
    Map<String, dynamic> defaultData = {
      'diagnosis': 'Type 2 Diabetes',
      'blood_pressure': '120/80 mmHg',
      'blood_sugar': '140 mg/dL',
      'weight': '70 kg',
      'symptoms': ['Frequent urination', 'Increased thirst', 'Fatigue'],
      'prescriptions': [
        {
          'medicine': 'Metformin',
          'dosage': '500mg',
          'frequency': 'Twice daily after meals',
          'duration': '3 months'
        },
        {
          'medicine': 'Glipizide',
          'dosage': '5mg',
          'frequency': 'Once daily before breakfast',
          'duration': '3 months'
        }
      ],
      'notes':
          'Patient showing improvement in blood sugar levels. Continue with current medication and lifestyle changes.',
      'next_steps': [
        'Monitor blood sugar daily',
        'Exercise 30 minutes daily',
        'Follow prescribed diet plan',
        'Take medications as prescribed'
      ],
      'next_appointment': '3 months from last visit'
    };

    try {
      final doc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentId)
          .get();

      if (doc.exists && doc.data() != null) {
        // Merge Firebase data with default data to ensure all fields exist
        return {...defaultData, ...doc.data()!};
      }
    } catch (e) {
      print('Error fetching appointment details: $e');
      // Continue with default data
    }

    return defaultData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Visit Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _appointmentDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading details",
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Go Back"),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  title: 'Appointment Information',
                  color: Colors.blue[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.person, 'Doctor', widget.doctorName),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.local_hospital, 'Hospital',
                          widget.hospitalName),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.calendar_today, 'Date', widget.date),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.access_time, 'Time', widget.time),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'Health Measurements',
                  color: Colors.green[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.favorite, 'Blood Pressure',
                          data['blood_pressure'] ?? 'Not recorded'),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.water_drop, 'Blood Sugar',
                          data['blood_sugar'] ?? 'Not recorded'),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.monitor_weight, 'Weight',
                          data['weight'] ?? 'Not recorded'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'Diagnosis & Symptoms',
                  color: Colors.orange[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.medical_services, 'Diagnosis',
                          data['diagnosis'] ?? 'Not diagnosed'),
                      const SizedBox(height: 12),
                      const Text(
                        'Symptoms Reported:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (data.containsKey('symptoms') &&
                          data['symptoms'] is List &&
                          (data['symptoms'] as List).isNotEmpty)
                        ...List<Widget>.from(
                          (data['symptoms'] as List).map(
                            (symptom) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.circle, size: 8),
                                  const SizedBox(width: 8),
                                  Text(
                                    symptom.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.only(left: 8, top: 4),
                          child: Text('No symptoms recorded',
                              style: TextStyle(
                                  fontSize: 16, fontStyle: FontStyle.italic)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (data.containsKey('prescriptions') &&
                    data['prescriptions'] is List &&
                    (data['prescriptions'] as List).isNotEmpty)
                  _buildSection(
                    title: 'Prescribed Medications',
                    color: Colors.red[100]!,
                    child: Column(
                      children: [
                        ...(data['prescriptions'] as List).map(
                          (med) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  med['medicine'] ?? 'Unknown medication',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(Icons.medication, 'Dosage',
                                    med['dosage'] ?? 'Not specified'),
                                const SizedBox(height: 4),
                                _buildInfoRow(Icons.schedule, 'Frequency',
                                    med['frequency'] ?? 'Not specified'),
                                const SizedBox(height: 4),
                                _buildInfoRow(Icons.calendar_today, 'Duration',
                                    med['duration'] ?? 'Not specified'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  _buildSection(
                    title: 'Prescribed Medications',
                    color: Colors.red[100]!,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No medications prescribed during this visit',
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'Doctor\'s Notes',
                  color: Colors.purple[100]!,
                  child: Text(
                    data['notes'] ?? 'No notes provided for this visit.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'Next Steps',
                  color: Colors.teal[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.containsKey('next_steps') &&
                          data['next_steps'] is List &&
                          (data['next_steps'] as List).isNotEmpty)
                        ...(data['next_steps'] as List).map(
                          (step) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    size: 24),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    step.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            'No specific next steps provided',
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.event,
                        'Next Appointment',
                        data['next_appointment'] ?? 'Not scheduled',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
