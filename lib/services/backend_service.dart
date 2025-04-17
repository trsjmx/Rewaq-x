import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'http://rewaqx.test'; // Replace with your backend URL
  
  static Future<Map<String, dynamic>> fetchUserData(String userId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/user/$userId'),
      headers: {'Accept': 'application/json'},
    );

    print('API Response: ${response.body}'); // Debug print

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return {
        'name': jsonData['name']?.toString() ?? 'User',
        'points': (jsonData['points'] is int) ? jsonData['points'] : 
                 int.tryParse(jsonData['points']?.toString() ?? '0') ?? 0,
        'image': jsonData['image']?.toString(), // Add this line for home screen image
      };
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Network Error: $e');
    return {
      'name': 'User',
      'points': 0,
      'image': null, // Add default image path or null
    };
  }
}

static Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/user/$userId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return {
        'name': jsonData['name']?.toString() ?? 'User',
        'role': jsonData['role']?.toString() ?? 'Role not specified',
        'department': jsonData['department']?.toString() ?? 'Department not specified',
        'image': jsonData['image']?.toString(), // Add this line
      };
    } else {
      throw Exception('Failed to load profile data');
    }
  } catch (e) {
    throw Exception('Failed to fetch profile: $e');
  }
}

static Future<List<dynamic>> fetchPosts() async {
  final response = await http.get(Uri.parse('$baseUrl/api/posts'));
  if (response.statusCode == 200) {
    final List<dynamic> fetchedPosts = json.decode(response.body);
    return fetchedPosts.map((post) {
      final user = post['user'] ?? {};
      final profile = user['profile'] ?? {};
      
      return {
        'id': post['id'].toString(),
        'user': {
          'name': user['name'] ?? profile['name'] ?? 'Unknown',
          'role': user['role'] ?? profile['role'] ?? 'Member',
          'image': user['image'] ?? profile['image'], // Get image from user or profile
        },
        'time': _formatTime(post['created_at']),
        'content': post['content'],
        'reactions': _formatReactions(post['reactions'] ?? []),
        'comments': post['comments'].length,
        'image_path': post['image_path'],
      };
    }).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}

static Future<void> addReaction(String postId, String emoji, int points) async {
    try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/posts/$postId/reactions'),
          body: json.encode({'emoji': emoji, 'points': points}),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 201) {
          return;
        } else {
          final errorData = jsonDecode(response.body);
          throw errorData['error'] ?? 'Failed to add reaction';
        }
  } catch (e) {
    throw e.toString();
  }
    
  }
  

  static String _formatTime(String createdAt) {
    // Parse the createdAt string into a DateTime object
    final DateTime postTime = DateTime.parse(createdAt);
    final DateTime now = DateTime.now();

    // Calculate the difference between the current time and the post time
    final Duration difference = now.difference(postTime);

    // Format the difference into a human-readable string
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  static Map<String, int> _formatReactions(List<dynamic> reactions) {
  final Map<String, int> formattedReactions = {};
  for (final reaction in reactions) {
    final emoji = reaction['emoji'] as String;
    formattedReactions[emoji] = (formattedReactions[emoji] ?? 0) + 1;
  }
  return formattedReactions;
}

}