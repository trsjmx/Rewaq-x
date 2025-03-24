import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'http://rewaqx.test'; // Replace with your backend URL

  static Future<List<dynamic>> fetchPosts() async {
  final response = await http.get(Uri.parse('$baseUrl/api/posts'));
  if (response.statusCode == 200) {
    final List<dynamic> fetchedPosts = json.decode(response.body);
    return fetchedPosts.map((post) {
      // Extract profile data from the post
      final profile = post['user']['profile'] ?? {};

      return {
        'id': post['id'].toString(), // Convert to String
        'user': {
          'name': profile['name'] ?? 'Unknown', // Use the name from the profile or fallback
          'role': profile['role'] ?? 'Member', // Use the role from the profile or fallback
        },
        'time': _formatTime(post['created_at']), // Format time
        'content': post['content'],
        'reactions': _formatReactions(post['reactions'] ?? []), // Ensure reactions is a list
        'comments': post['comments'].length, // Count comments
        'image_path': post['image_path'],
      };
    }).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}

static Future<void> addReaction(String postId, String emoji, int points) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts/$postId/reactions'),
      body: json.encode({'emoji': emoji, 'points': points}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add reaction');
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