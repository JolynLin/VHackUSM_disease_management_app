import 'package:flutter/material.dart';
import '../../widgets/back_arrow_icon.dart';
import '../../widgets/dropdown_arrow_icon.dart';
import '../../widgets/upload_icon.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  String? selectedGender;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _ageController.text = prefs.getString('age') ?? '';
      selectedGender = prefs.getString('gender');

      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        _profileImage = File(imagePath);
      }
    });
  }

  Future<void> _saveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('age', _ageController.text);
    if (selectedGender != null) {
      await prefs.setString('gender', selectedGender!);
    }
    if (_profileImage != null) {
      await prefs.setString('profileImage', _profileImage!.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 500,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Change Profile Photo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3FFA3).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library,
                    size: 36, color: Color(0xFF333333)),
              ),
              title: const Text('Choose from Gallery',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              subtitle: const Text('Select a photo from your device',
                  style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3FFA3).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt,
                    size: 36, color: Color(0xFF333333)),
              ),
              title: const Text('Take a Photo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              subtitle: const Text('Use your camera to take a new photo',
                  style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_profileImage != null)
              Column(
                children: [
                  const Divider(thickness: 1, height: 32),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.delete, size: 36, color: Colors.red),
                    ),
                    title: const Text('Remove Current Photo',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _profileImage = null;
                      });
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

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
                // Back Button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back,
                            size: 24, color: Colors.black87),
                      ),
                      iconSize: 40,
                    ),
                    // Title
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 30),
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Empty space to balance the back button
                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 30),

                // Profile Photo Section
                Center(
                  child: Column(
                    children: [
                      _buildProfilePhotoUpload(context),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Tap to change photo',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 193, 235, 254),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),

                      // Username Field
                      _buildFormField(
                        context: context,
                        label: 'Username',
                        icon: Icons.person,
                        child: _buildInputField(
                            context, _usernameController, 'Enter your name'),
                      ),

                      // Age Field
                      _buildFormField(
                        context: context,
                        label: 'Age',
                        icon: Icons.calendar_today,
                        child: _buildInputField(
                            context, _ageController, 'Enter your age'),
                      ),

                      // Gender Field
                      _buildFormField(
                        context: context,
                        label: 'Gender',
                        icon: Icons.people,
                        child: _buildDropdownField(context),
                      ),
                    ],
                  ),
                ),

                // Save Button
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 20),
                  width: double.infinity,
                  child: _buildSaveButton(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoUpload(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceOptions,
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color:
                _profileImage != null ? const Color(0xFFE3FFA3) : Colors.white,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          image: _profileImage != null
              ? DecorationImage(
                  image: FileImage(_profileImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _profileImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Add Photo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3FFA3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE3FFA3),
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
        ),
        onPressed: () async {
          await _saveUserProfile();
          if (mounted) {
            Navigator.pop(context);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.save, size: 28),
            SizedBox(width: 16),
            Text(
              'SAVE CHANGES',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required BuildContext context,
    required String label,
    required Widget child,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 8),
            child: Row(
              children: [
                Icon(icon, size: 24, color: const Color(0xFF333333)),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildInputField(
      BuildContext context, TextEditingController controller, String hint) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade500,
            fontFamily: 'Poppins',
          ),
        ),
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'Poppins',
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            'Select your gender',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
          ),
          value: selectedGender,
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue;
            });
          },
          items: <String>['Male', 'Female', 'Other', 'Prefer not to say']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            );
          }).toList(),
          icon: const Icon(
            Icons.arrow_drop_down_circle,
            color: Color(0xFF333333),
            size: 30,
          ),
          elevation: 2,
          iconSize: 30,
        ),
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
