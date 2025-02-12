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
      // Navigate to login screen after 3 seconds
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(
          children: [
            /// Top Circular Effect
            Positioned(
              left: 20,
              top: -305,
              child: Container(
                width: 356.96,
                height: 356.96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(122, 29, 255, 0.4),
                      blurRadius: 225.88,
                      spreadRadius: 0,
                      offset: const Offset(20, 20),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom Circular Effect
            Positioned(
              right: -100,
              bottom: -300,
              child: Container(
                width: 356.96,
                height: 356.96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(42, 210, 201, 0.8),
                      blurRadius: 225.88,
                      spreadRadius: 0,
                      offset: const Offset(20, 20),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom Image
            Positioned(
              bottom: -48,
              left: -48,
              right: -48,
              child: Image.asset(
                'assets/images/bottom_design.png',
                fit: BoxFit.cover,
              ),
            ),

            ///Logo
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
                  'assets/images/rewaqx_logo.png',
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
