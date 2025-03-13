import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
  String? _imagePath;
  bool _isPosting = false; // To track if the post is being created
  bool _showSuccessScreen = false; // To control the visibility of the success screen

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  // Method to handle image selection
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image from the gallery
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    } else {
      // Handle the case when no image is selected
      print('No image selected');
    }
  }

  // Method to send the post data to the backend
  Future<void> createPost(String content, String? imagePath) async {
    final url = Uri.parse('http://rewaqx.test/api/posts'); // Replace with your API endpoint

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add the post content
    request.fields['content'] = content;

    // Add the image file if it exists
    if (imagePath != null) {
      var file = File(imagePath);
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: basename(file.path),
        contentType: MediaType('image', 'jpeg'), // Adjust the content type if needed
      );
      request.files.add(multipartFile);
    }

    // Send the request
    var response = await request.send();

    // Check the response
    if (response.statusCode == 201) {
      print('Post created successfully');
    } else {
      print('Failed to create post: ${response.statusCode}');
    }
  }

  // Method to show the success screen and navigate back
  void _showSuccessAndNavigate(BuildContext context) {
    setState(() {
      _showSuccessScreen = true; // Show the success screen
    });

    // Wait for 2 seconds and then navigate back to the community screen
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showSuccessScreen = false; // Hide the success screen
      });
      Navigator.pop(context, true); // Pass `true` to indicate a refresh is needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Set the height to your desired value
        child: AppBar(
          backgroundColor: Colors.white, // White background
          elevation: 0, // Remove default shadow
          title: const Text(
            'Create Post',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold, // Bold text
              fontSize: 18, // Font size 18
              color: Color(0xFF7A1DFF), // Color #7A1DFF
            ),
          ),
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/images/chevron-left.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true, // Center the title
          shadowColor: const Color(0x1A1B1D36), // Shadow color with 10% opacity
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
                  color: Color(0x1A1B1D36), // Shadow color with 10% opacity
                  offset: Offset(0, 4), // Position: y = 4
                  blurRadius: 20, // Blur radius: 20
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _postController,
                  decoration: InputDecoration(
                    hintText: "What's happening?!",
                    hintStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      color: Colors.grey[600],
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: 4,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16.0,
                  ),
                  onChanged: (text) {
                    // Update the state to enable/disable the Share button
                    setState(() {});
                  },
                ),
                if (_imagePath != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(
                        File(_imagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),

                const Spacer(),
                Row(
                  children: [
                    // Add Image Button
                    IconButton(
                      onPressed: _pickImage,
                      icon: Icon(
                        Icons.image,
                        color: Color(0xFF2AD2C9),
                      ),
                    ),
                    const Spacer(),
                    // Share Button
                    ElevatedButton(
                      onPressed: _postController.text.trim().isEmpty || _isPosting
                          ? null // Disable the button if there's no text or posting is in progress
                          : () async {
                              // Handle post creation
                              final postContent = _postController.text.trim();
                              if (postContent.isNotEmpty) {
                                setState(() {
                                  _isPosting = true; // Set posting state to true
                                });

                                try {
                                  // Send the post data to the backend
                                  await createPost(postContent, _imagePath);

                                  // Show success screen and navigate back
                                  _showSuccessAndNavigate(context);
                                } catch (e) {
                                  print('Error creating post: $e');
                                  // Show an error message to the user
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to create post. Please try again.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    _isPosting = false; // Reset posting state
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _postController.text.trim().isEmpty || _isPosting
                            ? Colors.grey[300] // Disabled color
                            : Color(0xFF2AD2C9), // Enabled color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      ),
                      child: _isPosting
                          ? CircularProgressIndicator(color: Colors.white) // Show a loader while posting
                          : const Text(
                              'Share',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Success Screen Overlay
          if (_showSuccessScreen)
            Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Success!',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Your post shared successfully!',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}