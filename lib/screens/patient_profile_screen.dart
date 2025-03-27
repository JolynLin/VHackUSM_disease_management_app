import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  File? _imageFile;

  // Hardcoded patient data
  final Map<String, String> _patientData = {
    'name': 'John Doe',
    'ic': 'A123456789',
    'age': '65',
    'medicalHistory': 'Hypertension, Type 2 Diabetes',
    'allergies': 'Penicillin, Pollen',
    'currentMedications':
        'Metformin 500mg twice daily, Lisinopril 10mg once daily',
  };

  // Form controllers
  late final TextEditingController _nameController;
  late final TextEditingController _icController;
  late final TextEditingController _ageController;
  late final TextEditingController _medicalHistoryController;
  late final TextEditingController _allergiesController;
  late final TextEditingController _currentMedicationsController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with hardcoded data
    _nameController = TextEditingController(text: _patientData['name']);
    _icController = TextEditingController(text: _patientData['ic']);
    _ageController = TextEditingController(text: _patientData['age']);
    _medicalHistoryController =
        TextEditingController(text: _patientData['medicalHistory']);
    _allergiesController =
        TextEditingController(text: _patientData['allergies']);
    _currentMedicationsController =
        TextEditingController(text: _patientData['currentMedications']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _icController.dispose();
    _ageController.dispose();
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    _currentMedicationsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _savePatientData() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _patientData['name'] = _nameController.text;
      _patientData['ic'] = _icController.text;
      _patientData['age'] = _ageController.text;
      _patientData['medicalHistory'] = _medicalHistoryController.text;
      _patientData['allergies'] = _allergiesController.text;
      _patientData['currentMedications'] = _currentMedicationsController.text;
      _isEditing = false;
    });

    _showSuccess('Profile updated successfully');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      appBar: AppBar(
        title: const Text(
          "Patient Profile",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, size: 28),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _imageFile != null ? FileImage(_imageFile!) : null,
                      child: _imageFile == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 18),
                            onPressed: _pickImage,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: 'Full Name',
                controller: _nameController,
                enabled: _isEditing,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'IC Number',
                controller: _icController,
                enabled: _isEditing,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter your IC number'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Age',
                controller: _ageController,
                enabled: _isEditing,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your age' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Medical Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Medical History',
                controller: _medicalHistoryController,
                enabled: _isEditing,
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter your medical history'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Allergies',
                controller: _allergiesController,
                enabled: _isEditing,
                maxLines: 2,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter any allergies'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Current Medications',
                controller: _currentMedicationsController,
                enabled: _isEditing,
                maxLines: 2,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter current medications'
                    : null,
              ),
              if (_isEditing) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _savePatientData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _isEditing = false),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: !enabled,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
