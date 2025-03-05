import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Column(
        children: [
          // Top Effect Background
          Container(
            width: double.infinity,
            height: 204,
            decoration: BoxDecoration(
              color: Color.fromRGBO(122, 29, 255, 0.08),
            ),
          ),

          // User Photo with Edit Icon
          Transform.translate(
            offset: Offset(0, -35),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Profile Image with Border
                Container(
                  width: 120, 
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromRGBO(122, 29, 255, 1), 
                      width: 2, 
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60, 
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

          SizedBox(height: 8), 
          
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
          
          SizedBox(height: 5),

          Text(
            'Sw Engineer IT Department',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 14,
              fontWeight: FontWeight.w400, 
              color: Color.fromRGBO(108, 114, 120, 1),
            ),
          ),
          SizedBox(height: 40),

          // Options Container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(228, 229, 231, 1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildOptionRow('Edit Profile Information', 'assets/images/My Details icon.svg', "assets/images/back arrow.svg"),
                  Divider(height: 1, color: Colors.grey[300], indent: 12, endIndent: 12), 
                  _buildOptionRow('My Posts', 'assets/images/mypost.svg', "assets/images/back arrow.svg"),
                  Divider(height: 1, color: Colors.grey[300], indent: 12, endIndent: 12), 
                  _buildOptionRow('Log Out', 'assets/images/logout.svg', "assets/images/back arrow.svg"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for Profile options
  Widget _buildOptionRow(String text, String iconPath, String backIconPath) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 18, height: 18),
          SizedBox(width: 20),
          Text(
            text,
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.w500, 
              color: Color.fromRGBO(27, 29, 54, 1),
              fontFamily: 'Quicksand', 
            ),
          ),
          Spacer(),
          SvgPicture.asset(backIconPath, width: 8.28, height: 13.45),
        ],
      ),
    );
  }
}
