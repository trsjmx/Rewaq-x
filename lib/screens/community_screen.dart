import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rewaqx/screens/create_post.dart';



class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Initialize reactions for posts
  Map<String, int> post1Reactions = {'❤️': 7, '👍': 2, '🫡': 4, '🏆': 1, '🚀': 1};
  Map<String, int> post2Reactions = {'❤️': 10, '😍': 5, '🫡': 5, '🔥': 3};
  Map<String, int> post3Reactions = {'❤️': 7, '👍': 2, '🫡': 4, '🏆': 1, '🚀': 1};

  // Method to update reactions dynamically
  void _updateReactions(Map<String, int> reactions, String emoji) {
    setState(() {
      reactions[emoji] = reactions.containsKey(emoji) ? reactions[emoji]! + 1 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFC),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0), // Set the height to your desired value
            child: AppBar(
              automaticallyImplyLeading: false, // Disable the back arrow
              backgroundColor: Colors.white,           // White background
              elevation: 0,                             // Remove default shadow
              title: const Text(
                'UPM Community',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,          // Bold text
                  fontSize: 18,                         // Font size 18
                  color: Color(0xFF7A1DFF),             // Color #7A1DFF
                ),
              ),
              centerTitle: true,                        // Center the title
              shadowColor: const Color(0x1A1B1D36),     // Shadow color with 10% opacity
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
                      color: Color(0x1A1B1D36),          // Shadow color with 10% opacity
                      offset: Offset(0, 4),              // Position: y = 4
                      blurRadius: 20,                    // Blur radius: 20
                    ),
                  ],
                ),
              ),
            ),
          ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPost(
              name: 'Tosneem Alhattami',
              role: 'SW Eng - IT department',
              time: '2h',
              content:
                  'Just secured the MegaTech partnership! 🌟 This is a huge step forward for our team’s vision and growth goals. Proud of what we’ve accomplished together!',
              reactions: post1Reactions,
              comments: 6,
            ),
            const SizedBox(height: 16.0),
            _buildPost(
              name: 'Lojain Ajash',
              role: 'Project Manager - IT department',
              time: '3h',
              content:
                  'We’re working on a new project — a smart task management system to make work life easier for everyone. Excited to see how this turns out! 🌟 Got ideas? Drop them my way! 😊',
              reactions: post2Reactions,
              comments: 10,
              imageUrl: 'assets/images/office.png',
            ),
            const SizedBox(height: 16.0),
            _buildPost(
              name: 'Rana Ehab',
              role: 'Marketing Specialist ',
              time: '5h',
              content: 'kjjjk',
              reactions: post3Reactions,
              comments: 8,
            ),
          ],
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
            final postContent = newPostData['content'];
            final postImage = newPostData['image'];
            print('New post: $postContent');
            if (postImage != null) {
              print('Post image: $postImage');
            }
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
  

  void _showReactionOverlay(BuildContext context, Map<String, int> reactions) {
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
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Your Reaction',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: Color(0xFF1B1D36)
                  
                ),
                
              ),
              SizedBox(height: 8.0),
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
                  crossAxisCount: 4, // 3 emojis per row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: reactionOptions.length,
                itemBuilder: (context, index) {
                  final reaction = reactionOptions[index];
                  return GestureDetector(
                    onTap: () {
                      // Update reactions on emoji selection
                      _updateReactions(reactions, reaction['emoji']);
                      Navigator.pop(context); // Close the overlay
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
    required String name,
    required String role,
    required String time,
    required String content,
    required Map<String, int> reactions,
    required int comments,
    String? imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Card background color
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
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
          crossAxisAlignment: CrossAxisAlignment.start, // Align everything to the left
          children: [
            // User info
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFF7A1DFF), // The border color
                      width: 1, // Adjust the width as needed
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
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
            const SizedBox(height: 8.0),

            // Post content
            Text(
              content,
              style: const TextStyle(
                fontFamily: 'Quicksand',
              ),
            ),
            const SizedBox(height: 8.0),

            // Display image if provided
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            const SizedBox(height: 8.0),

            // Divider line
            const Divider(
              color: Color(0xFFF4F4F4), // Line color
              thickness: 1.0, // Line thickness
            ),
            const SizedBox(height: 2.0), // Reduced space between line and reactions

            // Reactions and add reaction button
            Row(
              children: [
                // Add reaction button (SVG icon)
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/add_reaction.svg', 
                    height: 18.0, 
                    width: 18.0,
                  ),
                  onPressed: () {
                    _showReactionOverlay(context , reactions); 
                  },
                ),
                const SizedBox(width: 7.0),

                // Display reactions with more space
                ...reactions.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0), // Increased space between reactions
                    child: Row(
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          entry.value.toString(),
                          style: const TextStyle(
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
            const SizedBox(height: 6.0),

            // Comments with SVG icon
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/comments.svg', // Comment SVG icon
                  height: 16.0, // Increased size
                  width: 16.0,
                ),
                const SizedBox(width: 8.0),
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
    );
  }
}