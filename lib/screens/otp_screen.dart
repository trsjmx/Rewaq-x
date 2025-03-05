import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  int _secondsRemaining = 60; // Countdown Timer
  bool _canResend = false;
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    startTimer();
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
            startTimer();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  void resendOTP() {
    if (_canResend) {
      setState(() {
        _secondsRemaining = 60;
        _canResend = false;
        startTimer();
      });
      // OTP resending logic must be here.
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
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
              'We just sent an email',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please enter the OTP sent to your email 4110400@upm.edu.sa',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 12,
                color: Color.fromRGBO(108, 114, 120, 1),
              ),
            ),
            const SizedBox(height: 20),

            /// OTP Input
            Center(
              child: Pinput(
                length: 6,
                controller: _otpController,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(237, 241, 243, 1),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(228, 229, 231, 0.24),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Verify Button
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
                    onPressed: () {
                      // Handle OTP Verification
                      // After verifying the OTP, navigate to the HomeScreen
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromRGBO(122, 29, 255, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Verify',
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
            const SizedBox(height: 10),

            /// Resend OTP with Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Didn’t get the code? ",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    MouseRegion(
                      cursor: _canResend
                          ? SystemMouseCursors.click
                          : MouseCursor.defer,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _canResend ? resendOTP : null,
                          borderRadius: BorderRadius.circular(4.0),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Resend it',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _canResend
                                    ? const Color.fromRGBO(122, 29, 255, 1)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$_secondsRemaining',
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
