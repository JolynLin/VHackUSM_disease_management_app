// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../widgets/toggle_switch.dart';

// class AccountSettingsScreen extends StatelessWidget {
//   const AccountSettingsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth <= 640;
//     final isMediumScreen = screenWidth <= 991;

//     return Scaffold(
//       body: Center(
//         child: Container(
//           width: isSmallScreen ? double.infinity : (isMediumScreen ? screenWidth * 0.9 : 481),
//           margin: isSmallScreen ? EdgeInsets.zero : EdgeInsets.symmetric(vertical: 20),
//           padding: isSmallScreen ? const EdgeInsets.all(15) : const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 16,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Account Settings',
//                 style: GoogleFonts.rubik(fontSize: isSmallScreen ? 16 : 18, color: Colors.grey),
//               ),
//               const SizedBox(height: 30),
//               Column(
//                 children: [
//                   _buildSettingsItem(
//                     context,
//                     title: 'Edit profile',
//                     trailing: const Icon(Icons.chevron_right, color: Colors.black54),
//                     onTap: () => Navigator.pushNamed(context, '/edit-profile'),
//                   ),
//                   const SizedBox(height: 30),
//                   _buildSettingsItem(
//                     context,
//                     title: 'Push notifications',
//                     trailing: ToggleSwitch(
//                       initialValue: true,
//                       onToggle: (value) {
//                         if (value) _showNotificationDialog(context);
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   _buildSettingsItem(
//                     context,
//                     title: 'Language',
//                     trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
//                     onTap: () => _showLanguageSelection(context),
//                   ),
//                   const SizedBox(height: 40),
//                   Center(
//                     child: GestureDetector(
//                       onTap: () => _showLogoutDialog(context),
//                       child: Container(
//                         width: isSmallScreen ? 90 : 98,
//                         height: isSmallScreen ? 28 : 31,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(15.5),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'Logout',
//                             style: GoogleFonts.rubik(fontSize: isSmallScreen ? 16 : 18, color: Colors.black),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingsItem(BuildContext context, {
//     required String title,
//     required Widget trailing,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: GoogleFonts.rubik(fontSize: 18, color: Colors.black),
//             ),
//             trailing,
//           ],
//         ),
//       ),
//     );
//   }

//   void _showNotificationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Enable Notifications'),
//         content: const Text('Get updates and alerts from our app. Would you like to turn on notifications?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Don't Allow")),
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Allow")),
//         ],
//       ),
//     );
//   }

//   void _showLanguageSelection(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SizedBox(
//           height: 250,
//           child: ListView(
//             children: ['English', 'Chinese', 'Malay', 'Hindi', 'Korean', 'Japanese']
//                 .map((lang) => ListTile(
//                       title: Text(lang),
//                       onTap: () => Navigator.pop(context),
//                     ))
//                 .toList(),
//           ),
//         );
//       },
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to Logout?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Yes")),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/toggle_switch.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onClose; // Add close function

  const SettingsScreen({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 640;
    final isMediumScreen = screenWidth <= 991;

    return GestureDetector(
      onTap: onClose, // Close settings when tapped outside
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height *
            0.6, // Ensure it stays inside HomeScreen
        padding: isSmallScreen
            ? const EdgeInsets.all(15)
            : const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Account Settings',
                  style: GoogleFonts.rubik(fontSize: 18, color: Colors.grey),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context), // Close button
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                _buildSettingsItem(
                  context,
                  title: 'Edit profile',
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.black54),
                  onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                ),
                const SizedBox(height: 30),
                _buildSettingsItem(
                  context,
                  title: 'Push notifications',
                  trailing: ToggleSwitch(
                    initialValue: true,
                    onToggle: (value) {
                      if (value) _showNotificationDialog(context);
                    },
                  ),
                ),
                const SizedBox(height: 30),
                _buildSettingsItem(
                  context,
                  title: 'Language',
                  trailing: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.black54),
                  onTap: () => _showLanguageSelection(context),
                ),
                const SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: () => _showLogoutDialog(context),
                    child: Container(
                      width: 98,
                      height: 31,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15.5),
                      ),
                      child: Center(
                        child: Text(
                          'Logout',
                          style: GoogleFonts.rubik(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context,
      {required String title, required Widget trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.rubik(fontSize: 18, color: Colors.black),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Notifications'),
        content: const Text('Would you like to turn on notifications?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Don't Allow")),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Allow")),
        ],
      ),
    );
  }

  void _showLanguageSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: ListView(
            children:
                ['English', 'Chinese', 'Malay', 'Hindi', 'Korean', 'Japanese']
                    .map((lang) => ListTile(
                          title: Text(lang),
                          onTap: () => Navigator.pop(context),
                        ))
                    .toList(),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to Logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("No")),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Yes")),
        ],
      ),
    );
  }
}
