import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'http://172.20.10.2:8000'; 
  
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
        'image': jsonData['image']?.toString(), 
      };
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Network Error: $e');
    return {
      'name': 'User',
      'points': 0,
      'image': null, 
    };
  }
}

static Future<List<Map<String, dynamic>>> fetchVouchers() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/vouchers'), 
        headers: {'Accept': 'application/json'},
      );
 
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          throw Exception('Failed to fetch vouchers: ${jsonData['message']}');
        }
      } else {
        throw Exception('Failed to load vouchers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching vouchers: $e');
      throw Exception('Failed to fetch vouchers: $e');
    }
  }
 
  static Future<Map<String, dynamic>> redeemVoucher(int voucherId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/vouchers/$voucherId/redeem'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
 
      if (response.statusCode != 200) {
        return {
          'success': false,
          'message': 'Server returned ${response.statusCode}',
        };
      }
 
      final jsonData = json.decode(response.body);
      print('API Response: $jsonData'); // Debug print
 
      if (jsonData['success'] == true) {
        return {
          'success': true,
          'message': jsonData['message'],
          'data': {
            'remaining_points': jsonData['data']['remaining_points'],
            'voucher': {
              'code': jsonData['data']['voucher_code'] ??
                  jsonData['data']['voucher']['code'] ??
                  'GENERATED_${DateTime.now().millisecondsSinceEpoch}' // Fallback
            }
          }
        };
      } else {
        return {
          'success': false,
          'message': jsonData['message'] ?? 'Failed to redeem voucher',
        };
      }
    } catch (e) {
      print('Error redeeming voucher: $e');
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }



/*
static Future<void> logStressInteraction(Map<String, dynamic> data) async {
  try {
    final response = await http.post(
      Uri.parse('http://172.20.10.2:8000/api/stress-interactions'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Failed to log stress interaction: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error logging stress interaction: $e');
    // Silently fail - this is analytics logging and shouldn't interrupt the app
  }
}
*/


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