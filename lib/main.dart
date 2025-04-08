import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rewaqx/screens/profile_screen.dart';
import 'package:rewaqx/screens/home_screen.dart';
import 'package:rewaqx/screens/community_screen.dart';
import 'package:rewaqx/screens/voucher_screen.dart';
import 'package:rewaqx/screens/events_screen.dart';
import 'package:rewaqx/screens/splash_screen.dart';
import 'package:rewaqx/screens/login_screen.dart';
import 'package:rewaqx/screens/otp_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(122, 29, 255, 0.08),
      ),
      initialRoute: '/', // Set initial screen to SplashScreen
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/otp': (context) {
          // Retrieve the email argument passed during navigation
          final email = ModalRoute.of(context)!.settings.arguments as String?;
          return OTPScreen(email: email ?? ""); // Pass the email to OTPScreen
        },
        '/home': (context) => MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to Home Page

  final List<Widget> _pages = [
    HomeScreen(),
    CommunityScreen(),
    VoucherScreen(),
    EventsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 22, bottom: 55),
        decoration: BoxDecoration(
          color: Colors.white, // Set background color
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(228, 229, 231, 1), // Shadow color
              blurRadius: 10, // Soften the shadow
              spreadRadius: 2, // Extend the shadow
              offset: Offset(0, -4), // Shadow position (x, y) - negative y for top shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomBarIcon(
                'assets/images/bottom_nav/Home.svg', 'Home', 0),
            _buildBottomBarIcon(
                'assets/images/bottom_nav/Message.svg', 'Community', 1),
            _buildBottomBarIcon(
                'assets/images/bottom_nav/coloredGift.svg', 'Rewards', 2),
            _buildBottomBarIcon(
                'assets/images/bottom_nav/calendar (7) 1.svg', 'Events', 3),
            _buildBottomBarIcon(
                'assets/images/bottom_nav/uncoloredProfile.svg', 'Profile', 4),
          ],
        ),
      ),
    );
  }

  // Helper method to build bottom bar icons with text
  Widget _buildBottomBarIcon(String iconPath, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
                isSelected
                    ? Color.fromRGBO(122, 29, 255, 1)
                    : Color.fromRGBO(108, 114, 120, 1),
                BlendMode.srcIn),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 12,
              color: isSelected
                  ? Color.fromRGBO(122, 29, 255, 1)
                  : Color.fromRGBO(108, 114, 120, 1),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
