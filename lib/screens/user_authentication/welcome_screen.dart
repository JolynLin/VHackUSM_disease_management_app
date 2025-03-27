import 'package:flutter/material.dart';
import 'dart:async';
import 'signorlog.dart'; // Import SignOrLogScreen

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState(); // ✅ No underscore
}

class WelcomeScreenState extends State<WelcomeScreen> { // ✅ No underscore
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    // Start transition after 600ms, fade out over 300ms, then navigate
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _opacity = 0.0;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SignOrLogScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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

          // Logo with Fade-Out Effect
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: _opacity,
              child: Image.asset(
                "assets/images/logo.png", // Ensure this file exists
                height: 600, // Adjust as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
