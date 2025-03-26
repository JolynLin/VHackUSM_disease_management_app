import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/background.png", fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text("Reset Password", style: TextStyle(fontSize: 38, fontFamily: 'Poppins', fontWeight: FontWeight.w800, color: Colors.black)),
                const SizedBox(height: 20),
                _buildPasswordField(label: "New Password", controller: passwordController, isVisible: isPasswordVisible, toggleVisibility: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                }),
                const SizedBox(height: 10),
                _buildPasswordField(label: "Confirm Password", controller: confirmPasswordController, isVisible: isConfirmPasswordVisible, toggleVisibility: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                }),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF88DCFE), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const SizedBox(width: double.infinity, height: 50, child: Center(child: Text("Back to Login", style: TextStyle(fontSize: 16, color: Colors.black)))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({required String label, required TextEditingController controller, required bool isVisible, required VoidCallback toggleVisibility}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.black)),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)]),
          child: TextField(
            controller: controller,
            obscureText: !isVisible,
            decoration: InputDecoration(border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 10), suffixIcon: IconButton(icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, size: 20), onPressed: toggleVisibility)),
          ),
        ),
      ],
    );
  }
}
