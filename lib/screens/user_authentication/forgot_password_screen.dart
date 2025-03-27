import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isResetLinkSent = false;

  void sendResetLink() {
    setState(() {
      isResetLinkSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
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
                const SizedBox(height: 20),
                const Text("Forgot Password", style: TextStyle(fontSize: 38, fontFamily: 'Poppins', fontWeight: FontWeight.w800, color: Colors.black)),
                const SizedBox(height: 20),
                _buildTextField(label: "Username", controller: usernameController),
                _buildTextField(label: "Email", controller: emailController),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: sendResetLink,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE3FFA3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const SizedBox(width: double.infinity, height: 50, child: Center(child: Text("SEND RESET LINK", style: TextStyle(fontSize: 16, color: Colors.black)))),
                ),
                if (isResetLinkSent)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("A password reset link has been sent to your email. Please check your Email.", style: TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Colors.black)),
                  ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text(
                        "Not Received? ",
                        style: TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Colors.black),
                      ),
                       Text(
                        "Resend Link",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: Color(0xFF0022FF),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.black)),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)]),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10)),
          ),
        ),
      ],
    );
  }
}