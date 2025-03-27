import 'package:flutter/material.dart';

class HealthMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> healthData;

  const HealthMetricsWidget({
    super.key,
    required this.healthData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            "Your Health Metrics",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
        ),
        _buildBloodPressureCard(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildMetricCard(
              "Blood Sugar",
              "${healthData['bloodSugar']['value']}",
              healthData['bloodSugar']['unit'],
              healthData['bloodSugar']['lastChecked'],
              Icons.water_drop,
              Colors.red.shade100,
              Colors.red,
            )),
            const SizedBox(width: 12),
            Expanded(
                child: _buildMetricCard(
              "Heart Rate",
              "${healthData['heartRate']['value']}",
              healthData['heartRate']['unit'],
              healthData['heartRate']['lastChecked'],
              Icons.favorite,
              Colors.pink.shade100,
              Colors.pink,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildBloodPressureCard() {
    return Card(
      elevation: 2,
      color: Colors.blue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite_border,
                    size: 24, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Text(
                  "Blood Pressure",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPressureValue(
                    "Systolic", "${healthData['bloodPressure']['systolic']}"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "/",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildPressureValue(
                    "Diastolic", "${healthData['bloodPressure']['diastolic']}"),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Last checked: ${healthData['bloodPressure']['lastChecked']}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPressureValue(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String unit,
    String lastChecked,
    IconData icon,
    Color backgroundColor,
    Color iconColor,
  ) {
    return Card(
      elevation: 2,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "$value $unit",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                "Last: $lastChecked",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
