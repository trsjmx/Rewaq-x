import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xFFFAFAFC),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0), // Set the height to your desired value
            child: AppBar(
              automaticallyImplyLeading: false, // Disable the back arrow
              backgroundColor: Colors.white,           // White background
              elevation: 0,                             // Remove default shadow
              title: const Text(
                'Rewards Store',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,          // Bold text
                  fontSize: 18,                         // Font size 18
                  color: Color(0xFF7A1DFF),             // Color #7A1DFF
                ),
              ),
              centerTitle: true,                        // Center the title
              shadowColor: const Color(0x1A1B1D36),     // Shadow color with 10% opacity
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(0),
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A1B1D36),          // Shadow color with 10% opacity
                      offset: Offset(0, 4),              // Position: y = 4
                      blurRadius: 20,                    // Blur radius: 20
                    ),
                  ],
                ),
              ),
            ),
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // White rectangle and shadow
           
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  // Rectangle with triangle SVG and text
                  Container(
                    width: 370,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(122, 29, 255, 1), 
                      borderRadius: BorderRadius.circular(20), 
                    ),
                    child: Stack(
                      children: [
                        // Triangle SVG placed behind the text
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SvgPicture.asset(
                            'assets/images/traingleEffect.svg', 
                            width: 100, 
                            height: 100,
                          ),
                        ),
                        // Text content
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Turn Your Points into Rewards! 🎟️',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white, 
                                
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Your hard work deserves a treat! 🎉 \nRedeem your points for exclusive vouchers and enjoy amazing deals on your favorite brands, services, and more.',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white, 
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 27),
                  Text(
                    'Get rewarded',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Quicksand",
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  VoucherCard(
                    title: 'Jarir Book Store',
                    points: '300 Points',
                    value: '200 SAR',
                    iconPath: 'assets/images/ga.png', 
                    svgPath: 'assets/images/voucher.svg',
                  ),
                  VoucherCard(
                    title: 'Half Million Coffee',
                    points: '100 Points',
                    value: '50 SAR',
                    iconPath: 'assets/images/Mel.png', 
                    svgPath: 'assets/images/voucher.svg', 
                  ),
                  VoucherCard(
                    title: 'Beauty Spa',
                    points: '150 Points',
                    value: '75 SAR',
                    iconPath: 'assets/images/Beauty.png', 
                    svgPath: 'assets/images/voucher.svg', 
                  ),
                 
                  VoucherCard(
                    title: 'Car Washer',
                    points: '500 Points',
                    value: '250 SAR',
                    iconPath: 'assets/images/car.png', 
                    svgPath: 'assets/images/cut.svg', // Different SVG
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /*
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
            _buildBottomBarIcon('assets/images/bottom_nav/Message.svg', 'Community', Color.fromRGBO(108, 114, 120, 1)),
            _buildBottomBarIcon('assets/images/bottom_nav/coloredGift.svg', 'Rewards', Color.fromRGBO(122, 29, 255, 1)),
            _buildBottomBarIcon('assets/images/bottom_nav/calendar (7) 1.svg', 'Events', Color.fromRGBO(108, 114, 120, 1)),
            _buildBottomBarIcon('assets/images/bottom_nav/uncoloredProfile.svg', 'Profile', Color.fromRGBO(108, 114, 120, 1)),
          ],
        ),
      ),
      */
    );
  }




  // Helper method to build bottom bar icons with text
  /*
  Widget _buildBottomBarIcon(String iconP, String text, Color textColor) {
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
            color: textColor, //use whats provided
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }*/
}

class VoucherCard extends StatelessWidget {
  final String title;
  final String points;
  final String value;
  final String iconPath; // Icon for the voucher card
  final String svgPath; // SVG for the voucher card

  const VoucherCard({super.key, 
    required this.title,
    required this.points,
    required this.value,
    required this.iconPath,
    required this.svgPath, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //of voucher card
      width: 358, 
      height: 103, 
      margin: EdgeInsets.only(bottom: 16), // Spacing between cards
      child: Row(
        children: [
          // White rectangle (coupon part)
          Container(
            width: 300, 
            height: 103, 
            decoration: BoxDecoration(
              color: Colors.white, // White background
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ), // Rounded corners on the left
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color
                  blurRadius: 5, // Shadow blur
                  offset: Offset(0, 2), // Shadow position
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icon for the voucher card (PNG)
                  Image.asset(
                    iconPath, // Path to the PNG icon
                    width: 34, 
                    height: 34, 
                  ),
                  SizedBox(width: 16), // Spacing between icon and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Quicksand",
                          ),
                        ),
                        Text(
                          '$value = $points',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: "Quicksand",
                          ),
                        ),
                        SizedBox(height: 8), // Spacing between text and button
                        // Redeem Voucher Button
                        Container(
                          width: 130, 
                          height: 30, 
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10), 
                            border: Border.all(
                              width: 1, // Border width
                              color: Colors.black.withOpacity(0.1), // Border color
                            ),
                            color: Color.fromRGBO(42, 210, 201, 1), // Button background color
                          ),
                          child: Center(
                            child: Text(
                              'Redeem Voucher',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Quicksand",
                                color: Color.fromRGBO(255, 255, 255, 1), // Text color
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SVG connected to the right (coupon design)
          SvgPicture.asset(
            svgPath, // Use the provided SVG path
            width: 45, // Adjust SVG size as needed
            height: 103, // Match the height of the voucher card
          ),
        ],
      ),
    );
  }
}