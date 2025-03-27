import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'doctor_details.dart';
import 'appointment_history_details.dart';

class CheckAppointmentScreen extends StatefulWidget {
  const CheckAppointmentScreen({super.key});

  @override
  _CheckAppointmentScreenState createState() => _CheckAppointmentScreenState();
}

class _CheckAppointmentScreenState extends State<CheckAppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> upcomingAppointments = [];
  List<Map<String, dynamic>> historyAppointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      final now = DateTime.now();
      final snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .orderBy('date', descending: true)
          .get();

      setState(() {
        upcomingAppointments = [];
        historyAppointments = [];

        for (var doc in snapshot.docs) {
          final data = doc.data();
          final appointmentDate = (data['date'] as Timestamp).toDate();
          final appointment = {
            'id': doc.id,
            'name': data['doctor'] ?? 'Unknown Doctor',
            'hospital': data['clinic'] ?? 'Unknown Clinic',
            'date': DateFormat('EEEE, d MMMM').format(appointmentDate),
            'time': data['time'] ?? 'Time not specified',
            'status': data['status'] ?? 'Pending',
          };

          if (appointmentDate.isAfter(now)) {
            upcomingAppointments.add(appointment);
          } else {
            historyAppointments.add(appointment);
          }
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error loading appointments: $e');
      setState(() => isLoading = false);
      _showError('Failed to load appointments. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9E80FF),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Go back',
        ),
        title: const Text(
          "My Appointments",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 26,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 4,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
          tabs: const [
            Tab(
              text: "UPCOMING",
              icon: Icon(Icons.event_available, size: 28),
            ),
            Tab(
              text: "HISTORY",
              icon: Icon(Icons.history, size: 28),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Loading appointments...",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                buildAppointmentList(upcomingAppointments, false),
                buildAppointmentList(historyAppointments, true),
              ],
            ),
    );
  }

  Widget buildAppointmentList(
      List<Map<String, dynamic>> appointments, bool isHistory) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isHistory ? Icons.history : Icons.calendar_today,
                size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            Text(
              isHistory
                  ? "No past appointments found"
                  : "No upcoming appointments",
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            if (!isHistory)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/appointment-booking');
                },
                icon: const Icon(Icons.add_circle, size: 28),
                label: const Text(
                  "Book New Appointment",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9E80FF),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return buildAppointmentCard(appointments[index], isHistory);
      },
    );
  }

  Widget buildAppointmentCard(Map<String, dynamic> data, bool isHistory) {
    final bool isUpcoming = !isHistory;
    final Color cardColor =
        isUpcoming ? const Color(0xFFE0EEFF) : const Color(0xFFF0F0F0);
    final Color borderColor = isUpcoming ? Colors.blue : Colors.grey.shade400;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with doctor name and hospital
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUpcoming ? Colors.blue.shade100 : Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: isUpcoming
                        ? Colors.blue.shade700
                        : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isUpcoming
                              ? Colors.blue.shade900
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['hospital'],
                        style: TextStyle(
                          fontSize: 16,
                          color: isUpcoming
                              ? Colors.blue.shade800
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Appointment details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and time info with larger icons
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isUpcoming
                            ? Colors.blue.shade50
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: isUpcoming
                            ? Colors.blue.shade700
                            : Colors.grey.shade700,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        data['date'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isUpcoming
                            ? Colors.blue.shade50
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: isUpcoming
                            ? Colors.blue.shade700
                            : Colors.grey.shade700,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        data['time'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                // Status indicator
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(data['status']),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Status: ${data['status']}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => isHistory
                                  ? AppointmentHistoryDetails(
                                      appointmentId: data['id'],
                                      doctorName: data['name'],
                                      hospitalName: data['hospital'],
                                      date: data['date'],
                                      time: data['time'],
                                    )
                                  : DoctorDetailsScreen(
                                      doctorId: data['id'],
                                      doctorName: data['name'],
                                      hospitalName: data['hospital'],
                                    ),
                            ),
                          );
                        },
                        icon: Icon(
                          isHistory ? Icons.medical_information : Icons.person,
                          size: 24,
                        ),
                        label: Text(
                          isHistory ? "Visit Details" : "View Detail",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isHistory ? const Color(0xFF9E80FF) : Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    if (isUpcoming &&
                        data['status'].toString().toLowerCase() !=
                            'cancelled') ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => showCancelDialog(context, data),
                          icon: const Icon(
                            Icons.cancel_outlined,
                            size: 24,
                          ),
                          label: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red.shade400;
      case 'completed':
        return Colors.blue.shade700;
      default:
        return Colors.grey;
    }
  }

  void showCancelDialog(
      BuildContext context, Map<String, dynamic> appointment) {
    final TextEditingController controller = TextEditingController();
    bool isConfirmed = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are You Sure want to cancel?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  onChanged: (value) {
                    setState(() {
                      isConfirmed = value.trim().toLowerCase() == "cancel";
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Please type "Cancel"',
                    filled: true,
                    fillColor: const Color(0xFFF7EDF7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isConfirmed
                      ? () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('appointments')
                                .doc(appointment['id'])
                                .update({'status': 'Cancelled'});

                            if (!mounted) return;

                            // Update local state to reflect the cancellation
                            setState(() {
                              // Update the status in the appointments list
                              for (var app in upcomingAppointments) {
                                if (app['id'] == appointment['id']) {
                                  app['status'] = 'Cancelled';
                                  break;
                                }
                              }
                            });

                            Navigator.pop(context); // Close dialog
                            _showSuccessDialog();
                          } catch (e) {
                            _showError(
                                'Failed to cancel appointment. Please try again.');
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Confirm",
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 16),
            const Text(
              "You have successfully cancelled your appointment.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
