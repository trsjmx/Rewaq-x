import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_init;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  static const String _notificationChannelId = 'rewaqx_wellness';
  static const String _notificationChannelName = 'Wellness Notifications';
  static const String _notificationChannelDesc = 'Notifications for wellness and motivation';
  
  // Initialize notification service
  static Future<void> initialize() async {
    tz_init.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
        print('Notification tapped: ${response.payload}');
      },
    );
    
  
    await _createNotificationChannel();
    
    // Request permissions for iOS
    await _requestIOSPermissions();
  }
  
  // Create the notification channel for Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _notificationChannelId,
      _notificationChannelName,
      description: _notificationChannelDesc,
      importance: Importance.high,
    );
    
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  
  // Request permissions for iOS
  static Future<void> _requestIOSPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  
  // Show a motivation notification
  static Future<void> showMotivationalNotification({
    required String title,
    required String message,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _notificationChannelId,
      _notificationChannelName,
      channelDescription: _notificationChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notificationsPlugin.show(
      Random().nextInt(1000), 
      title,
      message,
      platformDetails,
      payload: payload,
    );
    
    // Log showed a notification
    await _logNotification(message);
  }
  
  // Schedule a notification for later
  static Future<void> scheduleMotivationalNotification({
    required String title,
    required String message,
    required Duration delay,
    String? payload,
  }) async {
    final scheduledTime = tz.TZDateTime.now(tz.local).add(delay);
    
    await _notificationsPlugin.zonedSchedule(
      Random().nextInt(1000),
      title,
      message,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _notificationChannelId,
          _notificationChannelName,
          channelDescription: _notificationChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
    
    // Log scheduled a notification
    await _logNotification(message);
  }
  
  // Log notifications to prevent sending duplicates
  static Future<void> _logNotification(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final recentNotifications = prefs.getStringList('recent_notifications') ?? [];
    
    // Add notification to the list
    recentNotifications.add('${DateTime.now().toIso8601String()}:$message');
    
    // Keep only the last 10 notifications
    if (recentNotifications.length > 10) {
      recentNotifications.removeAt(0);
    }
    
    await prefs.setStringList('recent_notifications', recentNotifications);
  }
  
  // Check if we've sent a similar notification recently (within minutes)
  static Future<bool> hasSentSimilarNotificationRecently(
    String message, {
    int withinMinutes = 30,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final recentNotifications = prefs.getStringList('recent_notifications') ?? [];
    final now = DateTime.now();
    
    for (final entry in recentNotifications) {
      final parts = entry.split(':');
      if (parts.length >= 2) {
        try {
          final timestamp = DateTime.parse(parts[0]);
          final storedMessage = entry.substring(parts[0].length + 1);
          
          // Check if this is a similar message sent recently
          if (now.difference(timestamp).inMinutes <= withinMinutes &&
              _areMessagesSimilar(message, storedMessage)) {
            return true;
          }
        } catch (e) {
          print('Error parsing notification log: $e');
        }
      }
    }
    
    return false;
  }
  
  
  // Check if two messages are similar enough to be considered duplicates
  static bool _areMessagesSimilar(String a, String b) {
    // Simple heuristic: if the first 10 characters match
    if (a.length >= 10 && b.length >= 10) {
      return a.substring(0, 10) == b.substring(0, 10);
    }
    return a == b;
  }

  
}