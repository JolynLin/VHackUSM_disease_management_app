import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final String doctorId;
  final String doctorName;
  final String hospitalName;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.hospitalName,
  });

  Future<Map<String, dynamic>> _getDoctorDetails() async {
    try {
      // Try to fetch from Firebase
      final doc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();

      if (doc.exists) {
        return doc.data() ?? {};
      }
    } catch (e) {
      print('Error fetching doctor details: $e');
    }

    // Return hardcoded data if Firebase fetch fails or document doesn't exist
    return {
      'name': doctorName,
      'specialization': 'Diabetes Specialist',
      'hospital': hospitalName,
      'phone': '605-52515263',
      'email': 'doctor@hospital.com',
      'rating': 4.8,
      'reviews': 156,
      'about':
          'Dr. $doctorName is a highly experienced diabetes specialist with over 10 years of practice. Specializing in type 1 and type 2 diabetes management, metabolic disorders, and preventive care.',
      'specialized_in': [
        'Diabetes Management',
        'Endocrinology',
        'Internal Medicine'
      ],
      'imageUrl': 'https://i.imgur.com/QwhZRyL.png',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Doctor Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getDoctorDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Doctor details not found'));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(data['imageUrl']),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['name'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Professional: ${data['specialization']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.purple[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.phone, color: Colors.black),
                                  const SizedBox(width: 10),
                                  Text('Phone No: ${data['phone']}'),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.email, color: Colors.black),
                                  const SizedBox(width: 10),
                                  Text('Email: ${data['email']}'),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text('Rate: '),
                                      ...List.generate(
                                        5,
                                        (index) => Icon(
                                          Icons.star,
                                          color: index <
                                                  (data['rating'] as num)
                                                      .floor()
                                              ? Colors.yellow
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text('Review: ${data['reviews']}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.purple[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Specialized:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text((data['specialized_in'] as List).join(', ')),
                              const SizedBox(height: 10),
                              const Text(
                                'About Me:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(data['about']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
