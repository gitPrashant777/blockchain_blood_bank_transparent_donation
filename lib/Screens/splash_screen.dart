import 'dart:async';

import 'package:blockchain_blood_bank_transparent_donation/Screens/HomeScreen.dart';
import 'package:blockchain_blood_bank_transparent_donation/Screens/auth/Onboarding.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Corrected the builder parameter from 'builder' to 'context'
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center( // Center the entire Column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logop.png",
              height: 250,
              width: 250,
            ),
            const SizedBox(height: 20), // Add spacing
            const Text(
              "Version 1.0.1",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24, // Add a font size for better visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}

