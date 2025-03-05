import 'package:flutter/material.dart'; 
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';




class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
   String? _imagePath;

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


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Set the height to your desired value
        child: AppBar(
          backgroundColor: Colors.white,           // White background
          elevation: 0,                             // Remove default shadow
          title: const Text(
            'Create Post',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,          // Bold text
              fontSize: 18,                         // Font size 18
              color: Color(0xFF7A1DFF),             // Color #7A1DFF
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
      body: Padding(
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
                  onPressed: _postController.text.trim().isEmpty
                      ? null // Disable the button if there's no text
                      : () {
                          // Handle post creation
                          final postContent = _postController.text.trim();
                          if (postContent.isNotEmpty) {
                            // Navigate back to the community screen with the new post
                            Navigator.pop(context, {
                              'content': postContent,
                              'image': _imagePath,
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _postController.text.trim().isEmpty
                        ? Colors.grey[300] // Disabled color
                        : Color(0xFF2AD2C9), // Enabled color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  ),
                  child: const Text(
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
    );
  }
}