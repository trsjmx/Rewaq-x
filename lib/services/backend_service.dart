import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'http://172.20.10.3:8000'; // Replace with your backend URL
  
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
  try {
    final response = await http.get(Uri.parse('$baseUrl/api/posts'));
    print('API Response Status: ${response.statusCode}');
    print('API Response Body: ${response.body}');  // Debug output
    
    if (response.statusCode == 200) {
      final List<dynamic> fetchedPosts = json.decode(response.body);
      return fetchedPosts.map((post) {
        final user = post['user'] ?? {};
        final profile = user['profile'] ?? {};
        
        // Debug print to see what image data we're getting
        print('User image: ${user['image']}');
        print('Profile image: ${profile['image']}');
        
        // Handle image URL - use whichever exists (user.image or profile.image)
        String? imageUrl;
        if (user['image'] != null) {
          imageUrl = user['image'].toString();
        } else if (profile['image'] != null) {
          imageUrl = profile['image'].toString();
        }
        
        // If the URL doesn't start with http, prepend base URL
        if (imageUrl != null && !imageUrl.startsWith('http')) {
          imageUrl = '$baseUrl/storage/$imageUrl';
        }
        
        return {
          'id': post['id'].toString(),
          'user': {
            'name': user['name'] ?? profile['name'] ?? 'Unknown',
            'role': user['role'] ?? profile['role'] ?? 'Member',
            'image': imageUrl,  // Use the processed URL
          },
          'time': _formatTime(post['created_at']),
          'content': post['content'],
          'reactions': _formatReactions(post['reactions'] ?? []),
          'comments': post['comments'].length,
          'image_path': post['image_path'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in fetchPosts: $e');
    throw Exception('Failed to fetch posts: $e');
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