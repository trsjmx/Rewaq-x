import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(122, 29, 255, 0.08),
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the main background color to white
      body: Column(
        children: [
          // Effect at the Top
          Container(
            width: 390,
            height: 204,
            decoration: BoxDecoration(
              color: Color.fromRGBO(122, 29, 255, 0.08),
            ),
          ),

          // User Photo Circle 
          Transform.translate(
            offset: Offset(0, -35), // Adjusted offset to move the circle up less
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Circle with Border
                Container(
                  width: 120, 
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromRGBO(122, 29, 255, 1), // Border color
                      width: 2, // Border thickness
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60, // 120x120 circle
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                ),

                // Edit Icon
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/edite_pic.svg', 
                    width: 24, 
                    height: 24, 
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 1), // Add 15 pixels of space here
          
          // User Name and Job Title
          Text(
            "Tasneem Alhattami",
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 22,
              fontWeight: FontWeight.w600, 
              color: Color.fromRGBO(27, 29, 54, 1),
            ),
          ),
          
          SizedBox(height: 1), // Space between username and job title

          Text(
            'Sw Engineer IT Department',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 14,
              fontWeight: FontWeight.w400, 
              color: Color.fromRGBO(108, 114, 120, 1),
            ),
          ),
          SizedBox(height: 62), // Space between job title and the container below

          // Square Container with Shadow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set color here
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(228, 229, 231, 1), // Shadow color
                    blurRadius: 10, // Soften the shadow
                    spreadRadius: 2, // Extend the shadow
                    offset: Offset(0, 4), // Shadow position (x, y)
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildOptionRow('Edit Profile Information', 'assets/images/My Details icon.svg',"assets/images/back arrow.svg"),
                  Divider(height: 1, color: Colors.grey[300], indent: 12, endIndent: 12), 
                  _buildOptionRow('My Posts', 'assets/images/mypost.svg',"assets/images/back arrow.svg"),
                 Divider(height: 1, color: Colors.grey[300], indent: 12, endIndent: 12), 
                  _buildOptionRow('Log Out', 'assets/images/logout.svg',"assets/images/back arrow.svg"),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Bar with Shadow
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 22, bottom: 55), 
        decoration: BoxDecoration(
          color: Colors.white, // Set color here
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
            _buildBottomBarIcon('assets/images/bottom_nav/Home.svg', 'Home', Color.fromRGBO(108, 114, 120, 1)),
            _buildBottomBarIcon('assets/images/bottom_nav/Message.svg', 'Community',Color.fromRGBO(108, 114, 120, 1)),
            _buildBottomBarIcon('assets/images/bottom_nav/gift-card 1.svg', 'Rewards',Color.fromRGBO(108, 114, 120, 1)),
            _buildBottomBarIcon('assets/images/bottom_nav/calendar (7) 1.svg', 'Events',Color.fromRGBO(108, 114, 120, 1)),
            _buildBottomBarIcon('assets/images/bottom_nav/Profile.svg', 'Profile', Color.fromRGBO(122, 29, 255, 1)),
          ],
        ),
      ),
    );
  }

  // Helper method to build option rows with custom icons \ styled text
  Widget _buildOptionRow(String text, String iconPath,String backIconPath) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath, 
            width: 18, 
            height: 18, 
          ),
          SizedBox(width: 20),
          Text(
            text,
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.w500, 
              color: Color.fromRGBO(27, 29, 54, 1),
              fontFamily: 'Quicksand', 
              letterSpacing: 0, 
            ),
          ),
          Spacer(), // Pushes the back icon to the right
          SvgPicture.asset(
            backIconPath,
            width: 8.28, 
            height: 13.45, 
          ),
        ],
      ),
    );
  }

  // Helper method to build bottom bar icons with text
  Widget _buildBottomBarIcon(String iconP, String text,Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconP, 
          width: 24, 
          height: 24, 
        ),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 12,
            color: textColor, // Use the provided text color
            fontWeight: FontWeight.w500, 
          ),
        ),
      ],
    );
  }
}