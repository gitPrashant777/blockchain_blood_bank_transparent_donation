import 'package:flutter/material.dart';

class Onboarding {
  final String imgPath;
  final String title;
  final String description;

  Onboarding({
    required this.imgPath,
    required this.title,
    required this.description,
  });

  static final List<Onboarding> onboardingList = [
    Onboarding(
      imgPath: "assets/images/onboarding1.png",
      title: "Become a Lifesaver",
      description: "Donate blood, earn rewards, and help save lives in your community.",
    ),
    Onboarding(
      imgPath: "assets/images/onboarding2.png",
      title: "Track Your Impact",
      description: "Manage your donations, earn NFTs and badges, and see your progress on the leaderboard.",
    ),
    Onboarding(
      imgPath: "assets/images/onboarding3.png",
      title: "Transparent & Secure",
      description: "Our blockchain-based platform ensures every donation is secure and fully transparent.",
    ),
  ];
}