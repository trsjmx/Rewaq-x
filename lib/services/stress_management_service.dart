import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:rewaqx/services/ollama_service.dart';
import 'package:rewaqx/services/notification_service.dart';
import 'package:rewaqx/services/backend_service.dart';

class StressManagementService {
  // Cooldown period to avoid too many notifications
  static const Duration _notificationCooldown = Duration(minutes: 45);
  static const Duration _highStressCooldown = Duration(minutes: 20);
  
  // Thresholds for different stress levels
  static const double _highStressThreshold = 0.75;
  static const double _moderateStressThreshold = 0.50;

  // Track the last time we sent a notification
  static DateTime? _lastNotificationTime;
  
  /// Initialize the stress management service
  static Future<void> initialize() async {
    // Load last notification time from preferences
    final prefs = await SharedPreferences.getInstance();
    final lastNotificationTimeStr = prefs.getString('last_stress_notification_time');
    if (lastNotificationTimeStr != null) {
      _lastNotificationTime = DateTime.parse(lastNotificationTimeStr);
    }
  }
  
  /// Process stress data and generate appropriate notifications
  static Future<void> processStressData({
    required BuildContext context,
    required bool isStressed,
    required double stressScore,
    required String userName,
    int? heartRate,
    double? hrv,
    bool? isExercising,
  }) async {
    final now = DateTime.now();
    final timeOfDay = _getTimeOfDay(now);
    
    // Determine if we should send a notification based on cooldown and stress level
    final canSendNotification = await _canSendNotification(stressScore);
    if (!canSendNotification) {
      print('Skipping notification due to cooldown period');
      return;
    }
    
    try {
      // Generate personalized message using DeepSeek
      final message = await OllamaService.generateMotivationalMessage(
        userName: userName,
        stressScore: stressScore,
        isStressed: isStressed,
        heartRate: heartRate,
        hrv: hrv,
        isExercising: isExercising,
        timeOfDay: timeOfDay,
      );
      
      // Check if we've sent a similar notification recently
      final isSimilarToRecent = await NotificationService.hasSentSimilarNotificationRecently(
        message,
        withinMinutes: 60,
      );
      
      if (isSimilarToRecent) {
        print('Skipping similar notification sent recently');
        return;
      }
      
      // Determine notification title based on stress level
      String title;
      if (stressScore >= _highStressThreshold) {
        title = 'Take a Moment';
      } else if (stressScore >= _moderateStressThreshold) {
        title = 'Wellness Check';
      } else {
        title = 'Wellness Tip';
      }
      
      // Show notification
      await NotificationService.showMotivationalNotification(
        title: title,
        message: message,
      );
      
      // Update last notification time
      _lastNotificationTime = now;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_stress_notification_time', now.toIso8601String());
      
      // Log this interaction for analytics
      await _logStressInteraction(
        stressScore: stressScore,
        message: message,
        isStressed: isStressed,
      );
      
    } catch (e) {
      print('Error in stress management service: $e');
    }
  }
  
  /// Determine if we can send a notification based on cooldown periods
  static Future<bool> _canSendNotification(double stressScore) async {
    if (_lastNotificationTime == null) {
      return true;
    }
    
    final now = DateTime.now();
    final timeSinceLastNotification = now.difference(_lastNotificationTime!);
    
    // Use shorter cooldown for high stress situations
    if (stressScore >= _highStressThreshold) {
      return timeSinceLastNotification > _highStressCooldown;
    }
    
    // Normal cooldown for other situations
    return timeSinceLastNotification > _notificationCooldown;
  }
  
  /// Get the time of day descriptor
  static String _getTimeOfDay(DateTime dateTime) {
    final hour = dateTime.hour;
    
    if (hour >= 5 && hour < 12) {
      return 'morning';
    } else if (hour >= 12 && hour < 17) {
      return 'afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'evening';
    } else {
      return 'night';
    }
  }
  
  /// Log stress interactions for analytics and improvement
  static Future<void> _logStressInteraction({
    required double stressScore,
    required String message,
    required bool isStressed,
  }) async {
    try {
      await BackendService.logStressInteraction({
        'stress_score': stressScore,
        'is_stressed': isStressed,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Failed to log stress interaction: $e');
    }
  }
}