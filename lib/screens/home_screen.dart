import 'package:flutter/material.dart';
import 'voucher_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _showPermissionDialog();
  }

  void _showPermissionDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevents dismissing without a choice
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Color(0xB3B3B3D1), // Background color
            insetPadding: const EdgeInsets.symmetric(horizontal: 10), // Adjust horizontal padding
            child: Container(
              width: 220, // Reduced width for a more compact dialog
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Smaller padding to compact it
              decoration: BoxDecoration(
                color: Color.fromARGB(179, 252, 252, 255), // Dialog background color
                borderRadius: BorderRadius.only( // Adjusted corners to align the top corners
                  topLeft: Radius.circular(8), 
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Light shadow for contrast
                    blurRadius: 8, // Slightly smaller blur for the shadow
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title text with updated font size and weight
                  const Text(
                    '"Rewaq" Would Like to Access Your "Fitness" App Data',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w700,
                      fontSize: 12, // Smaller font size for compactness
                      color: Color.fromARGB(255, 5, 5, 5), // Text color
                      letterSpacing: -0.4,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10), // Reduced space between title and content
                  // Content text with updated font size
                  const Text(
                    "We use your smartwatch data to analyze stress, fatigue, and emotional states, helping you stay at your best.",
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w300,
                      fontSize: 10, // Smaller font size for compactness
                      color: Color.fromARGB(255, 8, 8, 8), // Text color
                      height: 1.4, // Adjusted line height for clarity
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15), // Reduced space between content and buttons
                  // Divider between content and buttons
                  const Divider(color: Colors.grey, thickness: 0.5),
                  const SizedBox(height: 8), // Space after divider
                  Column(
                    children: [
                      // "Allow" button with updated styling
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Rounded corners for buttons
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18), // Smaller padding for buttons
                        ),
                        child: const Text(
                          "Allow",
                          style: TextStyle(
                            color: Color(0xFF007AFF), // Blue text color for the buttons
                            fontSize: 13, // Adjusted font size for buttons
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8), // Space between buttons
                      // Divider between buttons
                      const Divider(color: Colors.grey, thickness: 0.5),
                      const SizedBox(height: 8), // Reduced space between buttons
                      // "Don't Allow" button with updated styling
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          // Handle denied action here if needed
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Rounded corners for buttons
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18), // Smaller padding
                        ),
                        child: const Text(
                          "Don’t Allow",
                          style: TextStyle(
                            color: Color(0xFF007AFF), // Blue text color for the buttons
                            fontSize: 13, // Adjusted font size for buttons
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Center(
            child: Image.asset(
              'assets/images/rewaqx_logo.png',
              width: 120,
              fit: BoxFit.contain,
            ),
          ),
          centerTitle: true,
          shadowColor: const Color(0x1A1B1D36),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1A1B1D36),
                  offset: const Offset(0, 4),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hello, Tasneem 👋",
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Let’s make today productive, and filled with small wins.",
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Points Card with Updated Height and Bottom-Aligned Content
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 165, // Increased height for better spacing
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4A00E0), // Deep Blue
                          Color(0xFF7A1DFF), // Darker Blue
                          Color(0xFFB84DC1), // Purple
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Move Text to Bottom-Left
                        Positioned(
                          bottom: -3, // Stick text to the bottom
                          left: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "You can redeem",
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "500 Points",
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Arrow Button at Bottom-Right with Custom Page Transition
                        Positioned(
                          bottom: 0, // Stick arrow to the bottom
                          right: 15,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 500), // Animation speed
                                  pageBuilder: (context, animation, secondaryAnimation) => const VoucherScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0); // Start position (bottom)
                                    const end = Offset.zero; // End position (original)
                                    const curve = Curves.easeInOut; // Smooth animation

                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF3D075D).withOpacity(0.3),
                              ),
                              child: const Icon(
                                Icons.north_east,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Celebrations Section
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Celebrations Title with Updated Color
                    const Text(
                      "Celebrations",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7A1DFF), // Updated to purple
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Celebration Items with Divider
                    Column(
                      children: [
                        const Divider(color: Colors.grey, thickness: 0.3), // Gray line
                        CelebrationItem(title: "Mohammed & 1 other", description: "joined the team today", avatars: ['avatar1.png', 'avatar2.png']),
                        const Divider(color: Colors.grey, thickness: 0.3), // Gray line

                        CelebrationItem(title: "Sara & 2 others", description: "birthday is today", avatars: ['avatar3.png', 'avatar4.png', 'avatar5.png']),
                        const Divider(color: Colors.grey, thickness: 0.3), // Gray line

                        CelebrationItem(title: "Ali Alharbi", description: "5th work anniversary", avatars: ['avatar6.png']),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Celebration Item Widget
class CelebrationItem extends StatelessWidget {
  final String title;
  final String description;
  final List<String> avatars;

  const CelebrationItem({Key? key, required this.title, required this.description, required this.avatars}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: "$title ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: description),
              ]),
            ),
          ),
          // Overlapping Avatars with Purple Borders
          if (avatars.isNotEmpty) // Prevents errors if no avatars exist
            SizedBox(
              width: (avatars.length * 30).clamp(40, 120).toDouble(), // Prevents 0 width issues
              height: 40, // Ensures proper layout
              child: Stack(
                clipBehavior: Clip.none,
                children: avatars.asMap().entries.map((entry) {
                  int index = entry.key;
                  String avatar = entry.value;

                  return Positioned(
                    left: (index * 22).toDouble(), // Adjust overlap spacing
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF7A1DFF), width: 2), // Purple border
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/images/$avatar'),
                        onBackgroundImageError: (_, __) => const AssetImage('assets/images/default_avatar.png'),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
