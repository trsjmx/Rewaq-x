// lib/services/health_service.dart
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthService {
  static final HealthFactory health = HealthFactory();

  static final dataTypes = [
    HealthDataType.HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_SDNN,
    HealthDataType.WORKOUT,
  ];

  static Future<bool> get hasPermissions async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('health_permissions_granted') ?? false;
  }

  static Future<bool> requestPermissions() async {
    try {
      final granted = await health.requestAuthorization(dataTypes);
      if (granted) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('health_permissions_granted', true);
      }
      return granted;
    } catch (e) {
      print("Permission error: $e");
      return false;
    }
  }

  static Future<List<HealthDataPoint>> fetchHealthData() async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      
      return await health.getHealthDataFromTypes(yesterday, now, dataTypes);
    } catch (e) {
      print("Error fetching health data: $e");
      return [];
    }
  }
}