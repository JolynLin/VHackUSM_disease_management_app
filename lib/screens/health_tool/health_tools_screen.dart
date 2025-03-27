import 'package:flutter/material.dart';

class HealthToolsScreen extends StatelessWidget {
  const HealthToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      appBar: AppBar(
        title: const Text(
          "Health Tools",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildDashboardCard(
              context,
              "Appointment Booking",
              "Schedule your medical appointments",
              Icons.calendar_month,
              '/appointment',
            ),
            const SizedBox(height: 16),
            _buildDashboardCard(
              context,
              "Medicine Information",
              "Find details about your medicines",
              Icons.medication,
              '/medicine-lookup',
            ),
            const SizedBox(height: 16),
            _buildDashboardCard(
              context,
              "How Are You Feeling?",
              "Check your health symptoms",
              Icons.health_and_safety,
              '/symptom-tracker',
            ),
            const SizedBox(height: 16),
            _buildDashboardCard(
              context,
              "AI Diagnosis",
              "Get AI-powered health insights",
              Icons.smart_toy_outlined,
              '/ai-diagnosis',
            ),
            const SizedBox(height: 16),
            _buildDashboardCard(
              context,
              "Community Forum",
              "Connect with others",
              Icons.people_outline,
              '/forum',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 36, color: Colors.blue),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
