// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io'; // Import for checking internet connectivity
import '../controllers/auth_controller.dart'; // Import AuthController
import 'home_view.dart'; // Import HomeView
import 'login_view.dart'; // Import LoginView

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // Navigate to the appropriate screen after a delay
  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 5)); // Simulate loading

    try {
      // Check for internet connectivity
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Check if the user is logged in
        final isLoggedIn = authController.userRole.value.isNotEmpty;

        // Navigate to the appropriate screen
        if (isLoggedIn) {
          Get.off(() => HomeView());
        } else {
          Get.off(() => LoginView());
        }
      }
    } on SocketException catch (_) {
      // Handle offline scenario
      Get.snackbar(
        'No Internet Connection',
        'Please check your internet connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            CircleAvatar(
              backgroundImage: AssetImage("assets/logo.png"),
              radius: 50,
            ),
            SizedBox(height: 16),
            // App Name
            Text(
              'korlinks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
