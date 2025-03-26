// lib/screens/appointment_booking.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'booking_history.dart';

class AppointmentBookingPage extends StatefulWidget {
  const AppointmentBookingPage({super.key});

  @override
  State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  String selectedDoctor = '';
  String selectedClinic = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> doctorsForClinic = [];
  List<Map<String, dynamic>> clinicData = [];
  LocationData? _userLocation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() => isLoading = true);
    Location location = Location();

    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        final enableResult = await location.requestService();
        if (enableResult == false) {
          _showError('Location services are required to find nearby clinics.');
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _showError('Location permission is required to find nearby clinics.');
          return;
        }
      }

      final userLoc = await location.getLocation();
      setState(() {
        _userLocation = userLoc;
        _loadNearbyClinics();
      });
    } catch (e) {
      _showError('Failed to get location. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _loadNearbyClinics() async {
    try {
      // For testing, let's add some sample clinics if none exist
      final clinicsRef = FirebaseFirestore.instance.collection('clinics');
      final snapshot = await clinicsRef.get();

      if (snapshot.docs.isEmpty) {
        // Add sample clinics if none exist
        await clinicsRef.add({
          'name': 'Sunway Medical Centre',
          'address':
              '5, Jalan Lagoon Selatan, Bandar Sunway, 47500 Petaling Jaya, Selangor',
          'phone': '+603-7491 9191',
          'latitude': 3.0738,
          'longitude': 101.5183,
        });

        await clinicsRef.add({
          'name': 'Klinik Kesihatan Subang Jaya',
          'address':
              'Jalan PJS 11/15, Bandar Sunway, 47500 Petaling Jaya, Selangor',
          'phone': '+603-5634 1234',
          'latitude': 3.0745,
          'longitude': 101.5190,
        });

        await clinicsRef.add({
          'name': 'Island Hospital',
          'address': 'Jalan Tun Dr Awang, 11900 Bayan Lepas, Penang',
          'phone': '+604-6433 3888',
          'latitude': 5.3557,
          'longitude': 100.3020,
        });
      }

      final userLat =
          _userLocation?.latitude ??
          3.0738; // Default to Sunway area if location not available
      final userLng = _userLocation?.longitude ?? 101.5183;

      List<Map<String, dynamic>> results = [];
      for (var doc in snapshot.docs) {
        final clinicLat = doc['latitude'] as double;
        final clinicLng = doc['longitude'] as double;
        final distance = _calculateDistance(
          userLat,
          userLng,
          clinicLat,
          clinicLng,
        );

        results.add({
          'id': doc.id,
          'name': doc['name'] as String,
          'address': doc['address'] as String,
          'phone': doc['phone'] as String,
          'distance': distance.toStringAsFixed(1),
        });
      }

      results.sort(
        (a, b) =>
            double.parse(a['distance']).compareTo(double.parse(b['distance'])),
      );

      setState(() {
        clinicData = results;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading clinics: $e'); // For debugging
      _showError('Failed to load nearby clinics. Please try again.');
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadDoctors(String clinicName) async {
    try {
      final doctorsRef = FirebaseFirestore.instance.collection('doctors');
      final snapshot =
          await doctorsRef.where('clinic', isEqualTo: clinicName).get();

      if (snapshot.docs.isEmpty) {
        // Add sample doctors if none exist
        await doctorsRef.add({
          'name': 'Dr. Lim Mei Hua (General)',
          'clinic': clinicName,
          'specialization': 'General Medicine',
        });

        await doctorsRef.add({
          'name': 'Dr. Ahmad Razif (Diabetes Specialist)',
          'clinic': clinicName,
          'specialization': 'Diabetes',
        });

        await doctorsRef.add({
          'name': 'Dr. Tan Siew Ling (Cardiologist)',
          'clinic': clinicName,
          'specialization': 'Cardiology',
        });
      }

      setState(() {
        doctorsForClinic =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print('Error loading doctors: $e'); // For debugging
      _showError('Failed to load doctors. Please try again.');
    }
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    return ((lat1 - lat2).abs() + (lng1 - lng2).abs()) * 111;
  }

  Future<void> _submitAppointment() async {
    if (selectedDoctor.isEmpty || selectedClinic.isEmpty) {
      _showError('Please select doctor and clinic.');
      return;
    }

    try {
      // Create appointment data
      final appointmentData = {
        'clinic': selectedClinic,
        'doctor': selectedDoctor,
        'date': Timestamp.fromDate(selectedDate),
        'time': selectedTime.format(context),
        'status': 'pending', // pending, confirmed, cancelled
        'createdAt': Timestamp.now(),
      };

      // Save to Firebase
      await FirebaseFirestore.instance
          .collection('appointments')
          .add(appointmentData);

      // Show success dialog
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text(
                'Appointment Confirmed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your appointment has been booked successfully!',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Doctor: $selectedDoctor',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Clinic: $selectedClinic',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Time: ${selectedTime.format(context)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to previous screen
                  },
                  child: const Text('OK', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
      );
    } catch (e) {
      print('Error booking appointment: $e'); // For debugging
      _showError('Failed to book appointment. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FA),
      appBar: AppBar(
        title: const Text(
          "Book Appointment",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          Tooltip(
            message: 'View Appointment History',
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookingHistoryPage(),
                  ),
                );
              },
              icon: const Icon(Icons.history, size: 32, color: Colors.white),
              label: const Text(
                'History',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body:
          isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "Loading nearby clinics...",
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('📍 Select Nearby Clinic'),
                    if (clinicData.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No clinics found nearby. Please try again later.',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      ...clinicData.map((clinic) => _buildClinicCard(clinic)),
                    if (selectedClinic.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _sectionTitle('Choose Doctor'),
                      if (doctorsForClinic.isEmpty)
                        const Center(child: CircularProgressIndicator())
                      else
                        ...doctorsForClinic.map(
                          (doc) => _buildSelectableCard(
                            label: doc,
                            selected: selectedDoctor == doc,
                            onTap: () => setState(() => selectedDoctor = doc),
                          ),
                        ),
                      const SizedBox(height: 24),
                      _sectionTitle('Pick Date and Time'),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.date_range, size: 32),
                                  label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(
                                        const Duration(days: 365),
                                      ),
                                    );
                                    if (picked != null) {
                                      setState(() => selectedDate = picked);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.access_time, size: 32),
                                  label: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      selectedTime.format(context),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: selectedTime,
                                    );
                                    if (picked != null) {
                                      setState(() => selectedTime = picked);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 32,
                          ),
                          label: const Text(
                            "Book Appointment",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _submitAppointment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildClinicCard(Map<String, dynamic> clinic) {
    final bool isSelected = selectedClinic == clinic['name'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: isSelected ? 4 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: 3,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? Colors.blue.shade100 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    size: 40,
                    color: isSelected ? Colors.blue.shade700 : Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic['name'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:
                              isSelected
                                  ? Colors.blue.shade900
                                  : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.directions_walk,
                            size: 24,
                            color:
                                isSelected
                                    ? Colors.blue.shade900
                                    : Colors.blue.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${clinic['distance']} km away',
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  isSelected
                                      ? Colors.blue.shade900
                                      : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 24,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? Colors.blue.shade200 : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 24,
                    color:
                        isSelected
                            ? Colors.blue.shade700
                            : Colors.blue.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      clinic['address'],
                      style: TextStyle(
                        fontSize: 20,
                        color:
                            isSelected
                                ? Colors.blue.shade900
                                : Colors.grey.shade800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    selectedClinic = clinic['name'];
                    selectedDoctor = ''; // Reset doctor selection
                  });
                  _loadDoctors(clinic['name']);
                },
                icon: Icon(
                  isSelected ? Icons.check_circle : Icons.check_circle_outline,
                  size: 28,
                ),
                label: Text(
                  isSelected ? 'Selected Clinic' : 'Select This Clinic',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected ? Colors.green.shade700 : Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableCard({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: selected ? 4 : 1,
        color: selected ? Colors.lightBlue.shade50 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 22,
              color: selected ? Colors.blue.shade800 : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
