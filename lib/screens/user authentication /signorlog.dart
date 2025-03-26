import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui'; // For blur effect

class SignOrLogScreen extends StatelessWidget {
  const SignOrLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),

          // Blur Layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),

          // Blurred Logo Above the White Box
          Positioned(
            top: screenHeight * 0.15, // Adjusted for better positioning
            left: 0,
            right: 0,
            child: Center(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 200, // Adjusted for better look
                  ),
                ),
              ),
            ),
          ),

          // White Box with Animation
          Align(
            alignment: Alignment.bottomCenter,
            child: BounceInUp(
              duration: const Duration(seconds: 1),
              child: Container(
                height: screenHeight * 0.6, // 60% of screen height
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome Text with Shadow
                    const Text(
                      "Welcome to MedEase",
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0022FF),
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle Text
                    const Text(
                      "Your personal healthcare assistant starts here!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Login & Sign Up Buttons
                    _buildButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function for buttons with same size and spacing
  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/login"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF88DCFE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: const Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15), // Spacing

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/signup"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD6BFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: const Text(
              "SIGN UP",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
