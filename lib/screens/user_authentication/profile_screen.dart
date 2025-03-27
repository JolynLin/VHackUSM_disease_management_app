// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'home_screen.dart';
// import 'edit_profile_screen.dart';

// class ProfileScreen extends StatelessWidget {
//   final String username;
//   final String age;
//   final String gender;
//   final File? profileImage;

//   const ProfileScreen({
//     Key? key,
//     required this.username,
//     required this.age,
//     required this.gender,
//     this.profileImage,
//   }) : super(key: key);

//   void _openSettings(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => FractionallySizedBox(
//         heightFactor: 0.6,
//         child: Center(child: Text("Settings Screen")),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.home),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const HomeScreen()),
//             );
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () => _openSettings(context),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Profile Image
//             CircleAvatar(
//               radius: 75,
//               backgroundColor: Colors.grey.shade300,
//               backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
//               child: profileImage == null
//                   ? const Icon(Icons.person, size: 80, color: Colors.white)
//                   : null,
//             ),
//             const SizedBox(height: 20),
//             // Username
//             Text(
//               username,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             // Profile Info
//             Text('Age: $age'),
//             Text('Gender: $gender'),
//             const Text('Email: abc123@gmail.com'), // Placeholder for email
//             const SizedBox(height: 30),
//             // Edit Profile Button
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const EditProfileScreen()),
//                 );
//               },
//               child: const Text('EDIT PROFILE'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart'; // For storing data
import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import '../dashboard.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String age;
  final String gender;
  final String? profileImage;

  const ProfileScreen({
    super.key,
    this.username = "Guest",
    this.age = "",
    this.gender = "",
    this.profileImage,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "Guest";
  String age = "";
  String gender = "";
  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    setState(() {
      username = widget.username;
      age = widget.age;
      gender = widget.gender;
      profileImagePath = widget.profileImage;
    });
    _loadUserProfile(); // Load saved data
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? widget.username;
      age = prefs.getString('age') ?? widget.age;
      gender = prefs.getString('gender') ?? widget.gender;
      profileImagePath = prefs.getString('profileImage') ?? widget.profileImage;
    });
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.6,
        child: SettingsScreen(onClose: () => Navigator.pop(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE5FFE5), Color(0xFFE5F0FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top bar with settings icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.black87,
                          size: 30,
                        ),
                        onPressed: () => _openSettings(context),
                        tooltip: 'Settings',
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Profile Image
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: profileImagePath != null
                        ? Image.file(
                            File(profileImagePath!),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                // Username
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 32),
                // Profile Info Cards
                _buildInfoCard('Age', age),
                const SizedBox(height: 16),
                _buildInfoCard('Gender', gender),
                const SizedBox(height: 16),
                _buildInfoCard('Email', 'abc123@gmail.com'),
                const SizedBox(height: 40),
                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE3FFA3),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                      _loadUserProfile();
                    },
                    icon: const Icon(Icons.edit, size: 28),
                    label: const Text(
                      'EDIT PROFILE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Let's Start Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF88DCFE),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward, size: 28),
                    label: const Text(
                      "LET'S START",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
