import 'package:flutter/material.dart';
import '../../widgets/back_arrow_icon.dart';
import '../../widgets/dropdown_arrow_icon.dart';
import '../../widgets/upload_icon.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(_getResponsivePadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: CustomPaint(
                      size: const Size(52, 43),
                      painter: BackArrowIconPainter(),
                    ),
                  ),
                ),

                // Title
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 38),
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ),

                // Form Container
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 337),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username Field
                        _buildFormField(
                          context: context,
                          label: 'Username',
                          child: _buildInputField(context),
                        ),

                        // Age Field
                        _buildFormField(
                          context: context,
                          label: 'Age',
                          child: _buildInputField(context),
                        ),

                        // Gender Field
                        _buildFormField(
                          context: context,
                          label: 'Gender',
                          child: _buildDropdownField(context),
                        ),

                        // Profile Photo
                        _buildFormField(
                          context: context,
                          label: 'Profile Photo',
                          child: _buildProfilePhotoUpload(context),
                        ),

                        // Save Button
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          width: double.infinity,
                          child: _buildSaveButton(context),
                        ),
                      ],
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

  Widget _buildProfilePhotoUpload(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(40, 40),
          painter: UploadIconPainter(),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE3FFA3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        // Implement saving logic here
        Navigator.pop(context); // Closes the Edit Profile Screen
      },
      child: const Text(
        'SAVE CHANGES',
        style: TextStyle(
          color: Color(0xFF1A1C29),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildFormField({
    required BuildContext context,
    required String label,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14),
        ),
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text(
                'Select your gender',
                style: TextStyle(
                  color: Color(0xFFD1D3D9),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              value: selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
              items: <String>['Male', 'Female', 'Other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              icon: const SizedBox.shrink(), // Hide default icon
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: CustomPaint(
                size: const Size(13, 7),
                painter: DropdownArrowIconPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getResponsivePadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width <= 640) {
      return 10;
    } else if (width <= 991) {
      return 15;
    } else {
      return 20;
    }
  }

  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    double width = MediaQuery.of(context).size.width;
    if (width <= 640) {
      return baseSize - 10;
    } else if (width <= 991) {
      return baseSize - 6;
    } else {
      return baseSize;
    }
  }
}
