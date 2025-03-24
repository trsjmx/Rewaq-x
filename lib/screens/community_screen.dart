import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rewaqx/screens/create_post.dart';
import 'package:rewaqx/services/backend_service.dart'; // Import the BackendService

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<dynamic> posts = []; // List to store posts fetched from the backend
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // Fetch posts when the screen loads
  }

  // Fetch posts from the backend
  Future<void> _fetchPosts() async {
    try {
      final fetchedPosts = await BackendService.fetchPosts();
      print('Fetched posts: $fetchedPosts'); // Debug log

      setState(() {
        posts = fetchedPosts.reversed.toList(); // Reverse the list to show the latest post first
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching posts: $e'); // Debug log
      setState(() {
        isLoading = false;
      });
    }
  }

    void _updateReactions(String postId, String emoji, int points) async {
    try {
      await BackendService.addReaction(postId, emoji, points);
      _fetchPosts(); // Refresh posts after reacting
    } catch (e) {
      print('Error updating reactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (posts.isEmpty) {
      return Center(child: Text('No posts available.'));
    }

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'UPM Community',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF7A1DFF),
            ),
          ),
          centerTitle: true,
          shadowColor: const Color(0x1A1B1D36),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(0),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A1B1D36),
                  offset: Offset(0, 4),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: posts
              .map((post) => _buildPost(
                    id: post['id'],
                    name: post['user']['name'],
                    role: post['user']['role'],
                    time: post['time'],
                    content: post['content'],
                    reactions: Map<String, int>.from(post['reactions']),
                    comments: post['comments'],
                    imageUrl: post['image_path'],
                    profileImageUrl: post['user']['profile_image'], // Pass profile image URL
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          // Navigate to the CreatePostScreen and wait for the result
          final newPostData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(),
            ),
          );

          // Handle the new post data
          if (newPostData != null) {
            _fetchPosts(); // Refresh the posts after creating a new one
          }
        },
        backgroundColor: Color(0xFF2AD2C9),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showReactionOverlay(
      BuildContext context, String postId, Map<String, int> reactions) {
    final List<Map<String, dynamic>> reactionOptions = [
      {'emoji': '❤️', 'points': 0},
      {'emoji': '👍', 'points': 10},
      {'emoji': '👏', 'points': 20},
      {'emoji': '😍', 'points': 30},
      {'emoji': '🫡', 'points': 40},
      {'emoji': '🔥', 'points': 50},
      {'emoji': '🎁', 'points': 60},
      {'emoji': '💪', 'points': 70},
      {'emoji': '🏆', 'points': 80},
      {'emoji': '🚀', 'points': 90},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Allow the sheet to take up more space
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7, // Set height to 60% of screen height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Your Reaction',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: Color(0xFF1B1D36),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Show your support and appreciation! Each emoji comes with points that will be added to the post owner\'s score.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                  fontFamily: 'Quicksand',
                ),
              ),
              SizedBox(height: 16.0),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: reactionOptions.length,
                itemBuilder: (context, index) {
                  final reaction = reactionOptions[index];
                  return GestureDetector(
                    onTap: () {
                      _updateReactions(postId, reaction['emoji'], reaction['points']);
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Text(
                          reaction['emoji'],
                          style: TextStyle(fontSize: 32.0),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${reaction['points']} Points',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                            fontFamily: 'Quicksand',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPost({
    required String id,
    required String name,
    required String role,
    required String time,
    required String content,
    required Map<String, int> reactions,
    required int comments,
    String? imageUrl,
    String? profileImageUrl, // Add profile image URL
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0), // Add vertical space
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          border: Border.all(
            color: Color(0xFFF4F4F4), // Border color
            width: 1.0, // Border thickness
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000), // Shadow color
              offset: Offset(0, 2), // Shadow offset
              blurRadius: 10, // Shadow blur
              spreadRadius: 0, // Shadow spread
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage('http://rewaqx.test/storage/$profileImageUrl')
                        : AssetImage('assets/images/avatar.png') as ImageProvider,
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                      Text(
                        '$role • $time',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                content,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                ),
              ),
              if (imageUrl != null && imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    'http://rewaqx.test/storage/$imageUrl',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              SizedBox(height: 8.0),
              Divider(
                color: Color(0xFFF4F4F4),
                thickness: 1.0,
              ),
              SizedBox(height: 2.0),
              Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/add_reaction.svg',
                      height: 18.0,
                      width: 18.0,
                    ),
                    onPressed: () {
                      _showReactionOverlay(context, id, reactions);
                    },
                  ),
                  SizedBox(width: 7.0),
                  ...reactions.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '${entry.value}', // Displaying the count of reactions
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: 6.0),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/comments.svg',
                    height: 16.0,
                    width: 16.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    '$comments comments',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                      fontFamily: 'Quicksand',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}