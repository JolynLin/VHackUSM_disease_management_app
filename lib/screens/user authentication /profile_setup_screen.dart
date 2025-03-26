 import 'package:flutter/material.dart'; 
 import 'package:image_picker/image_picker.dart';
 import 'dart:io';
 import 'package:shared_preferences/shared_preferences.dart';
 import 'profile_screen.dart';

   class ProfileSetupScreen extends StatefulWidget {
   const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender;
  File? _profileImage;

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _usernameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _selectedGender != null &&
        int.tryParse(_ageController.text) != null; // Ensuring age is a number
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB4F7D2), Color(0xFFA7CBFF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 412),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 40.0),
                        child: Text(
                          "Let's Setup your Profile",
                          style: TextStyle(
                            fontSize: 38, 
                            fontWeight: FontWeight.w800, 
                            fontFamily: 'Poppins', 
                            color: Colors.black
                          ),
                        ),
                      ),
                      _buildInputField(label: 'Username', controller: _usernameController),
                      const SizedBox(height: 32),
                      _buildInputField(label: 'Age', controller: _ageController, keyboardType: TextInputType.number),
                      const SizedBox(height: 32),
                      const Text(
                        'Gender', 
                        style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      _buildDropdownField(),
                      const SizedBox(height: 32),
                      const Text(
                        'Profile Photo', 
                        style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      _buildProfilePhotoSection(),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                         onPressed: _isFormValid
    ? () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _usernameController.text);
        await prefs.setString('age', _ageController.text);
        await prefs.setString('gender', _selectedGender!);
        if (_profileImage != null) {
          await prefs.setString('profileImage', _profileImage!.path);
        }

        // Navigate to ProfileScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
    }
    : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid ? Colors.greenAccent : Colors.grey, // Disable if invalid
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'COMPLETED',
                            style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required TextEditingController controller, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: const TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.black),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: (value) => setState(() {}), // Updates UI when typing
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
       value: _selectedGender,
       hint: const Text('Select your gender', style: TextStyle(color: Color(0xFFD1D3D9), fontSize: 16, fontFamily: 'Poppins')),
       decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
         contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      ),
      onChanged: (value) => setState(() => _selectedGender = value), // Updates UI
      items: const [
        DropdownMenuItem(value: 'Male', child: Text('Male')),
        DropdownMenuItem(value: 'Female', child: Text('Female')),
        DropdownMenuItem(value: 'Prefer not to say', child: Text('Prefer not to say')),
       ],
     );
  }

  Widget _buildProfilePhotoSection() {
     return GestureDetector(
      onTap: _showImageSourceActionSheet,
       child: Center(
       child: CircleAvatar(
         radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
         child: _profileImage == null
             ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
              : null,
         ),
       ),
     );
    }
 }
