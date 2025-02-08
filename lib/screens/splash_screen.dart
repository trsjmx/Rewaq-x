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
      // Navigate to Home Screen after 3 seconds
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromRGBO(122, 29, 255, 0.4), // Adjusted purple shade
              const Color.fromRGBO(42, 210, 201, 0.8), // Adjusted blue shade
            ],
          ),
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
