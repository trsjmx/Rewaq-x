import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:shared_preferences/shared_preferences.dart';

class OllamaService {
  // API configuration - replace with your Ollama server address
  static const String _ollamaApiUrl = 'http://172.20.10.2:11434/api/generate';
  static const String _ollamaModel = 'deepseek-r1:1.5b';
  
  /// Initialize the Ollama service
  static Future<void> initialize({required String customModelName, required String customApiUrl}) async {
    try {
      // Test connection to the Ollama server
      final testResult = await _testOllamaConnection();
      
      // Save the connection status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('ollama_available', testResult);
      
      print('Ollama service initialized. Server available: $testResult');
    } catch (e) {
      print('Error initializing Ollama service: $e');
      // Save that the connection failed
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('ollama_available', false);
    }
  }
  
  /// Test the connection to the Ollama server
  static Future<bool> _testOllamaConnection() async {
    try {
      // Simple test request with a tiny prompt
      final response = await http.post(
        Uri.parse(_ollamaApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': _ollamaModel,
          'prompt': 'Say hello',
          'stream': false,
          'max_tokens': 10,
        }),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Ollama connection test failed: $e');
      return false;
    }
  }

  /// Generate a motivational message based on stress data
  static Future<String> generateMotivationalMessage({
    required String userName,
    required double stressScore,
    required bool isStressed,
    int? heartRate,
    double? hrv,
    bool? isExercising,
    String? timeOfDay,
  }) async {
    try {
      // Create the prompt for the language model
      final prompt = _createPrompt(
        userName: userName,
        stressScore: stressScore,
        isStressed: isStressed,
        heartRate: heartRate,
        hrv: hrv,
        isExercising: isExercising,
        timeOfDay: timeOfDay,
      );

      // Make the API request
      final response = await http.post(
        Uri.parse(_ollamaApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': _ollamaModel,
          'prompt': prompt,
          'stream': false,
          'temperature': 0.7,
          'max_tokens': 150,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Ollama API error: ${response.statusCode}');
      }

      // Parse the response
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['response'] ?? '';
      
      // Clean the message from any HTML tags
      message = _cleanHtmlContent(message);
      
      // Add fallback if message is empty or too short
      if (message.isEmpty || message.length < 10) {
        message = _getFallbackMessage(isStressed);
      }

      return message;
    } catch (e) {
      print('Error generating motivational message: $e');
      return _getFallbackMessage(isStressed);
    }
  }

  /// Clean HTML content from messages
  static String _cleanHtmlContent(String message) {
    if (message.contains('<') && message.contains('>')) {
      try {
        // Parse HTML and extract text content
        var document = html_parser.parse(message);
        return document.body?.text ?? message;
      } catch (e) {
        // If HTML parsing fails, use regex to remove tags
        return message.replaceAll(RegExp(r'<[^>]*>'), '').trim();
      }
    }
    return message.trim();
  }

  /// Create a prompt for the language model
  static String _createPrompt({
    required String userName,
    required double stressScore,
    required bool isStressed,
    int? heartRate,
    double? hrv,
    bool? isExercising,
    String? timeOfDay,
  }) {
    // Determine stress level descriptor
    String stressLevel;
    if (stressScore > 0.7) {
      stressLevel = 'high';
    } else if (stressScore > 0.5) {
      stressLevel = 'moderate';
    } else {
      stressLevel = 'low';
    }

    // Create the prompt
    return '''
You are a compassionate wellness coach for an app called Rewaqx. The user's name is $userName and they're experiencing $stressLevel stress (score: ${stressScore.toStringAsFixed(2)}).

${heartRate != null ? 'Their heart rate is currently $heartRate bpm. ' : ''}
${hrv != null ? 'Their heart rate variability is $hrv. ' : ''}
${isExercising == true ? 'They are currently exercising. ' : ''}
${timeOfDay != null ? 'It is currently $timeOfDay time. ' : ''}

Write ONE short, supportive wellness message (1-2 sentences) that is:
- Compassionate and human-sounding
- Specific to their current stress level and situation
- Practical and actionable
- Non-judgmental and empowering

DO NOT include any HTML, markdown, or formatting. Provide ONLY the text of the message.
''';
  }

  /// Get a fallback message if API call fails
  static String _getFallbackMessage(bool isStressed) {
    if (isStressed) {
      final messages = [
        "Take a deep breath and remember this moment will pass.",
        "Your feelings are valid. Consider taking a short break to reset.",
        "Find a quiet moment to breathe deeply for just 30 seconds.",
        "Place your hand on your heart and take three slow breaths.",
        "Step outside for fresh air if possible. Small breaks make a difference.",
      ];
      return messages[DateTime.now().second % messages.length];
    } else {
      final messages = [
        "You're doing well today. Keep up the positive momentum.",
        "Notice what's working well for you today and carry it forward.",
        "Take a moment to appreciate your progress, however small.",
        "You've created some balance today. Well done on that achievement.",
        "Remember to celebrate small wins throughout your day.",
      ];
      return messages[DateTime.now().second % messages.length];
    }
  }
}