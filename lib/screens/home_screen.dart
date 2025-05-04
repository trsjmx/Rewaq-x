import 'dart:math';
import 'package:flutter/material.dart';
import 'voucher_screen.dart';
import 'package:rewaqx/services/backend_service.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; 
import 'package:rewaqx/services/health_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:rewaqx/services/stress_management_service.dart';
import 'package:rewaqx/services/notification_service.dart';
import 'package:rewaqx/services/ollama_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String userName = "Loading...";
  int userPoints = 0;
  bool isLoading = true;
  String? userImage;
  bool _healthDialogShown = false;
  bool _isFetchingHealthData = false;
  List<HealthDataPoint> _healthDataPoints = [];
  DateTime? _lastHealthSync;
  Timer? _healthCheckTimer;
  final Duration _healthCheckInterval = Duration(minutes: 5); // Check every 5 minutes

  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchUserData();
    _initHealthMonitoring();
    _initServices();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _healthCheckTimer?.cancel();
    super.dispose();
  }

  // new method to initialize our services:
Future<void> _initServices() async {
  try {
    // Initialize notification service
    await NotificationService.initialize();
    
    // Initialize stress management service
    await StressManagementService.initialize();
    
    // Initialize DeepSeek with API key (replace with your actual API key)
    // In production, you would get this from a secure source
   await OllamaService.initialize(
   customApiUrl: 'ht://172.20.10.2:11434/api/generate', // Your Ollama server IP
   customModelName: 'deepseek-r1', // Or another model you have pulled
);
    
  } catch (e) {
    print('Failed to initialize services: $e');
  }
}
  // Handle app lifecycle changes to refresh health data when app returns to foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh health data when app comes to foreground
      _fetchHealthDataWithLogging();
    }
  }

 
  Future<void> _initHealthMonitoring() async {
    final hasPermission = await HealthService.hasPermissions;
    
    if (!hasPermission) {
      // Show dialog only if permissions not granted
      await _showPermissionDialog();
    } else {
      // Start with immediate fetch if permissions are already granted
      await _fetchHealthDataWithLogging();
      // Then set up the periodic timer for automatic updates
      _startHealthCheckTimer();
    }
  }

  void _startHealthCheckTimer() {
    // Cancel existing timer if any
    _healthCheckTimer?.cancel();
    
    // Start new periodic timer
    _healthCheckTimer = Timer.periodic(_healthCheckInterval, (timer) {
      if (mounted) {
        _fetchHealthDataWithLogging();
      }
    });
  }

  Future<void> _fetchHealthDataWithLogging() async {
    if (_isFetchingHealthData || !mounted) return;
    
    setState(() => _isFetchingHealthData = true);

    try {
      print('Starting health data fetch automatically...');
      final healthData = await HealthService.fetchHealthData();
      
      if (healthData.isEmpty) {
        print('No health data available');
        return;
      }

      setState(() {
        _healthDataPoints = healthData;
        _lastHealthSync = DateTime.now();
      });

      _logHealthDataDetails(healthData);
      await _processHealthDataForStress(healthData);
      
    } catch (e) {
      print('Error in health data fetch: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch health data')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFetchingHealthData = false);
      }
    }
  }

  void _logHealthDataDetails(List<HealthDataPoint> healthData) {
    print('=== HEALTH DATA SUMMARY ===');
    print('Total data points fetched: ${healthData.length}');
    
    // Count data points by type
    final typeCounts = <HealthDataType, int>{};
    for (var point in healthData) {
      typeCounts.update(point.type, (value) => value + 1, ifAbsent: () => 1);
    }
    
    typeCounts.forEach((type, count) {
      print('$type: $count points');
    });
    
    // Print sample data points with proper value handling
    if (healthData.isNotEmpty) {
      print('\n=== SAMPLE DATA POINTS ===');
      for (var i = 0; i < min(3, healthData.length); i++) {
        final point = healthData[i];
        final value = point.value is NumericHealthValue
            ? (point.value as NumericHealthValue).numericValue
            : point.value.toString();
        print('${point.type}: $value at ${point.dateFrom}');
      }
    }
    
    print('=== END OF SUMMARY ===');
  }

  Future<void> _processHealthDataForStress(List<HealthDataPoint> healthData) async {
    try {
      // Extract heart rate data
      final heartRates = healthData
          .where((point) => point.type == HealthDataType.HEART_RATE)
          .toList();

      // Extract hrv data    
      final hrvReadings = healthData
          .where((point) => point.type == HealthDataType.HEART_RATE_VARIABILITY_SDNN)
          .toList();

      // Extract workout data
      final workouts = healthData
          .where((point) => point.type == HealthDataType.WORKOUT)
          .toList();
      
      print('Found ${heartRates.length} heart rate readings and ${workouts.length} workouts');
      
      if (heartRates.isEmpty) {
        print('No heart rate data available for stress detection');
        return;
      }
      
      // Get the most recent heart rate
      final latestHeartRate = heartRates.reduce((a, b) => a.dateFrom.isAfter(b.dateFrom) ? a : b);
      
      // Get most recent values
      final latestHR = _extractNumericValue(
        heartRates.reduce((a, b) => a.dateFrom.isAfter(b.dateFrom) ? a : b).value
      );
      
      double? latestHRV;
      if (hrvReadings.isNotEmpty) {
        latestHRV = _extractNumericValue(
          hrvReadings.reduce((a, b) => a.dateFrom.isAfter(b.dateFrom) ? a : b).value
        );
      }
    
      // Check if user is currently exercising
      final isExercising = workouts.any((workout) => 
          workout.dateFrom.isAfter(DateTime.now().subtract(Duration(minutes: 30))));
      
      print('Latest values - HR: $latestHR, HRV: $latestHRV, Exercising: $isExercising');
      
      await _sendToStressDetectionAPI(latestHR, latestHRV, isExercising);
      
    } catch (e) {
      print('Error processing health data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing health data: ${e.toString()}')),
        );
      }
    }
  }
  
  double _extractNumericValue(dynamic healthValue) {
    if (healthValue is NumericHealthValue) {
      return healthValue.numericValue.toDouble();
    } else if (healthValue is num) {
      return healthValue.toDouble();
    }
    return double.tryParse(healthValue.toString()) ?? 0.0;
  }

  Future<void> _sendToStressDetectionAPI(
    double heartRate, 
    double? hrv,
    bool isExercising,
  ) async {
    const maxRetries = 3;
    int attempt = 0;
    
    while (attempt < maxRetries) {
      try {
        final payload = {
          'user_id': 1, // Replace with actual user ID
          'heart_rate': heartRate,
          'hrv': hrv,
          'is_exercising': isExercising,
          'timestamp': DateTime.now().toIso8601String(),
        };
        
        final response = await http.post(
          Uri.parse('http://172.20.10.2:8000/api/detectstress'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        ).timeout(const Duration(seconds: 10));
        
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('Stress result: ${responseData['is_stressed']}, Score: ${responseData['stress_score']}');
          
          if (mounted && responseData['is_stressed'] == true) {
            _showStressAlert(responseData['stress_score']);
          }
          return; // Success - exit retry loop
        }
      } catch (e) {
        print('Attempt ${attempt + 1} failed: $e');
        if (attempt == maxRetries - 1 && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send health data')),
          );
        }
      }
      
      attempt++;
      await Future.delayed(Duration(seconds: attempt * 2)); // Exponential backoff
    }
  }

  // Replace the _showStressAlert method with this:
void _showStressAlert(double stressScore) {
  // Process the stress detection with our new service
  StressManagementService.processStressData(
    context: context,
    isStressed: true,
    stressScore: stressScore,
    userName: userName,
    heartRate: _getLatestHeartRate(),
    hrv: _getLatestHRV(),
    isExercising: _isCurrentlyExercising(),
  );

}

// Add these helper methods to extract the latest health data:
int? _getLatestHeartRate() {
  final heartRates = _healthDataPoints
      .where((point) => point.type == HealthDataType.HEART_RATE)
      .toList();
  
  if (heartRates.isEmpty) return null;
  
  final latest = heartRates.reduce((a, b) => 
      a.dateFrom.isAfter(b.dateFrom) ? a : b);
  
  return _extractNumericValue(latest.value).round();
}

double? _getLatestHRV() {
  final hrvReadings = _healthDataPoints
      .where((point) => point.type == HealthDataType.HEART_RATE_VARIABILITY_SDNN)
      .toList();
  
  if (hrvReadings.isEmpty) return null;
  
  final latest = hrvReadings.reduce((a, b) => 
      a.dateFrom.isAfter(b.dateFrom) ? a : b);
  
  return _extractNumericValue(latest.value);
}

bool _isCurrentlyExercising() {
  return _healthDataPoints
      .where((point) => point.type == HealthDataType.WORKOUT)
      .any((workout) => 
          workout.dateFrom.isAfter(DateTime.now().subtract(Duration(minutes: 30))));
}


  // Updated permission dialog handler
  Future<void> _showPermissionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Health Data Access'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This app needs access to your health data to monitor stress levels.'),
                SizedBox(height: 10),
                Text('Allow access to heart rate and workout data?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final granted = await HealthService.requestPermissions();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('healthDialogShown', true);
                
                if (granted) {
                  await _fetchHealthDataWithLogging();
                  _startHealthCheckTimer();
                }
              },
              child: const Text("Allow"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('healthDialogShown', true);
              },
              child: const Text("Don't Allow"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchUserData() async {
    try {
      print('Fetching user data...');
      final userData = await BackendService.fetchUserData('1');
      print('Received data: $userData');
      
      setState(() {
        userName = userData['name']?.toString() ?? 'User';
        userPoints = (userData['points'] is int) ? userData['points'] : 
                    int.tryParse(userData['points']?.toString() ?? '0') ?? 0;
        userImage = userData['image'];
        isLoading = false;
      });
    } catch (e) {
      print('Error in _fetchUserData: $e');
      setState(() {
        userName = "User";
        userPoints = 0;
        userImage = null;
        isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: userImage != null 
                        ? NetworkImage(userImage!) as ImageProvider
                        : const AssetImage('assets/images/avatar.png') as ImageProvider,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, $userName 👋",
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
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
                              Text(
                                "$userPoints Points",
                                style: const TextStyle(
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
              // Show health sync status with a more subtle indicator
              if (_isFetchingHealthData)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7A1DFF)),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Syncing health data...',
                        style: TextStyle(
                          color: Color(0xFF7A1DFF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_lastHealthSync != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Last health sync: ${_formatDateTime(_lastHealthSync!)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      // Remove the floating action button to make sync automatic
    );
  }
  
  // Helper to format the timestamp nicely
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
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