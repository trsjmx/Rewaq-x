import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Navigate to login Screen after 3 seconds
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(
              255, 255, 255, 1), // Set background color to pure white
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -48,
              left: -48,
              right: -48,
              child: Image.asset(
                'assets/images/bottom_design.png', // Ensure the image is in assets
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: TweenAnimationBuilder(
                duration: const Duration(seconds: 2),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/images/rewaqx_logo.png', // Ensure the logo is in assets
                  width: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
