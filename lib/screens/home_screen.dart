import 'package:flutter/material.dart';
import 'voucher_screen.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _checkAndShowDialog();
  }

  Future<void> _checkAndShowDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final bool dialogShownBefore = prefs.getBool('healthDialogShown') ?? false;
    
    if (!dialogShownBefore) {
      await prefs.setBool('healthDialogShown', true);
      if (mounted) {
        _showPermissionDialog();
      }
    }
  }

  void fetchHealthData() async {
    final HealthFactory health = HealthFactory();

    final types = <HealthDataType>[
      HealthDataType.HEART_RATE,
      HealthDataType.HEART_RATE_VARIABILITY_SDNN,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.WORKOUT,
      HealthDataType.STEPS,
      HealthDataType.MOVE_MINUTES,
    ];

    final bool requested = await health.requestAuthorization(types);

    if (requested) {
      final now = DateTime.now();
      final yesterday = now.subtract(Duration(days: 1));

      try {
        final List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          yesterday,
          now,
          types,
        );

        print('Finished fetching health data. Total points: ${healthData.length}');
      } catch (e) {
        print('Error fetching health data: $e');
      }
    } else {
      print('Authorization not granted');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xB3B3B3D1),
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: 220,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Color.fromARGB(179, 252, 252, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Rewaq wants to access data from your Health app',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Color.fromARGB(255, 5, 5, 5),
                    letterSpacing: -0.4,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "We use your smartwatch data to analyze stress, fatigue, and emotional states, helping you stay at your best.",
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w300,
                    fontSize: 10,
                    color: Color.fromARGB(255, 8, 8, 8),
                    height: 1.4,
                    letterSpacing: 0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 8),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        fetchHealthData(); // This will open the health app permissions
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                      ),
                      child: const Text(
                        "Allow",
                        style: TextStyle(
                          color: Color(0xFF007AFF),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.grey, thickness: 0.5),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                      ),
                      child: const Text(
                        "Don't Allow",
                        style: TextStyle(
                          color: Color(0xFF007AFF),
                          fontSize: 13,
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
                          "Let's make today productive, and filled with small wins.",
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
                    height: 165,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4A00E0),
                          Color(0xFF7A1DFF),
                          Color(0xFFB84DC1),
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
                        Positioned(
                          bottom: -3,
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

                        Positioned(
                          bottom: 0,
                          right: 15,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 500),
                                  pageBuilder: (context, animation, secondaryAnimation) => const VoucherScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

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
                    const Text(
                      "Celebrations",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7A1DFF),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Column(
                      children: [
                        const Divider(color: Colors.grey, thickness: 0.3),
                        CelebrationItem(title: "Mohammed & 1 other", description: "joined the team today", avatars: ['avatar1.png', 'avatar2.png']),
                        const Divider(color: Colors.grey, thickness: 0.3),

                        CelebrationItem(title: "Sara & 2 others", description: "birthday is today", avatars: ['avatar3.png', 'avatar4.png', 'avatar5.png']),
                        const Divider(color: Colors.grey, thickness: 0.3),

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
          if (avatars.isNotEmpty)
            SizedBox(
              width: (avatars.length * 30).clamp(40, 120).toDouble(),
              height: 40,
              child: Stack(
                clipBehavior: Clip.none,
                children: avatars.asMap().entries.map((entry) {
                  int index = entry.key;
                  String avatar = entry.value;

                  return Positioned(
                    left: (index * 22).toDouble(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF7A1DFF), width: 2),
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