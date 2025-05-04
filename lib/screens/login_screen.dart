import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false; // Add a loading state

  // Function to send OTP
  Future<void> sendOtp() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse('http://172.20.10.2:8000/api/send-otp'), // Backend URL
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": _emailController.text}),
      );

      if (response.statusCode == 200) {
        // Navigate to OTP screen with the email as an argument
        Navigator.pushNamed(
          context,
          '/otp',
          arguments: _emailController.text, // Pass the email to OTPScreen
        );
      } else {
        // Show an error message if OTP sending fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to send OTP: ${response.body}"),
          ),
        );
      }
    } catch (e) {
      // Handle network or server errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 252, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/chevron-left.svg',
                    width: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/images/rewaqx_screenlogo.svg',
                      width: 150,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Log in',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please enter your organization email to log in. Ensure your organization is registered with us to proceed.',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 12,
                color: Color.fromRGBO(108, 114, 120, 1),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Organization Email',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromRGBO(237, 241, 243, 1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(228, 229, 231, 0.24),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -150,
                  bottom: -420,
                  child: Container(
                    width: 356.96,
                    height: 356.96,
                    decoration: BoxDecoration(
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
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : sendOtp, // Disable button when loading
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromRGBO(122, 29, 255, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Log In',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
