import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
  String? _imagePath;
  XFile? _imageFile;
  bool _isPosting = false;
  bool _showSuccessScreen = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _imageFile = pickedFile;
      });
    } else {
      print('No image selected');
    }
  }

  void _removeImage() {
    setState(() {
      _imagePath = null;
      _imageFile = null;
    });
  }

  Future<void> createPost(String content, String? imagePath) async {
<<<<<<< HEAD
    final url = Uri.parse('http://172.20.10.3:8000/api/posts'); // Replace with your API endpoint

    // Create a multipart request
=======
    final url = Uri.parse('http://rewaqx.test/api/posts');
>>>>>>> 664f412ada2dcaa3120907ce4437367dc8b22dc7
    var request = http.MultipartRequest('POST', url);
    request.fields['content'] = content;

    if (_imageFile != null) {
      if (kIsWeb) {
        final bytes = await _imageFile!.readAsBytes();
        var multipartFile = http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: _imageFile!.name,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      } else {
        var file = File(_imageFile!.path);
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(file.path),
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      print('Post created successfully');
    } else {
      print('Failed to create post: ${response.statusCode}');
    }
  }

  void _showSuccessAndNavigate(BuildContext context) {
    setState(() {
      _showSuccessScreen = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showSuccessScreen = false;
      });
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Create Post',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF7A1DFF),
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
                    setState(() {});
                  },
                ),
                if (_imagePath != null)
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: kIsWeb
                              ? Image.network(
                                  _imagePath!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                )
                              : Image.file(
                                  File(_imagePath!),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 15,
                        child: GestureDetector(
                          onTap: _removeImage,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),

                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: _pickImage,
                      icon: Icon(
                        Icons.image,
                        color: Color(0xFF2AD2C9),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _postController.text.trim().isEmpty || _isPosting
                          ? null
                          : () async {
                              final postContent = _postController.text.trim();
                              if (postContent.isNotEmpty) {
                                setState(() {
                                  _isPosting = true;
                                });

                                try {
                                  await createPost(postContent, _imagePath);
                                  _showSuccessAndNavigate(context);
                                } catch (e) {
                                  print('Error creating post: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to create post. Please try again.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    _isPosting = false;
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _postController.text.trim().isEmpty || _isPosting
                            ? Colors.grey[300]
                            : Color(0xFF2AD2C9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      ),
                      child: _isPosting
                          ? CircularProgressIndicator(color: Colors.white)
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

          if (_showSuccessScreen)
            Container(
              color: Colors.black.withOpacity(0.5),
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
                        color: Color(0xFF8028FF),
                        size: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Success 🎉!',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF8028FF),
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