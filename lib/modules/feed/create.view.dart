import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/models/feed.model.dart';
import 'package:magadige/utils/index.dart';
import 'package:magadige/widgets/custom.filled.button.dart';
import 'package:magadige/widgets/custom.input.field.dart';
import 'package:path/path.dart' as path;

class CreateFeedView extends StatefulWidget {
  final Feed? feed;
  const CreateFeedView({Key? key, this.feed}) : super(key: key);

  @override
  _CreateFeedViewState createState() => _CreateFeedViewState();
}

class _CreateFeedViewState extends State<CreateFeedView> {
  final TextEditingController _captionController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _location = TextEditingController();
  bool _isLoading = false;
  String selectedCategory = "hotel";
  String? _existingImageUrl;
  final List<String> categories = ["hotel", "flight", "bus", "board"];
  @override
  void initState() {
    super.initState();
    if (widget.feed != null) {
      _captionController.text = widget.feed!.caption;
      _location.text = widget.feed!.location ?? '';
      _existingImageUrl = widget.feed!.imageUrl;
    }
  }

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a caption')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = _existingImageUrl;
      if (_image != null) {
        // Upload new image to Firebase Storage
        final ref = FirebaseStorage.instance.ref().child('post_images').child(
            '${DateTime.now().toIso8601String()}${path.extension(_image!.path)}');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final postData = {
        'userId': userId,
        'caption': _captionController.text,
        'imageUrl': imageUrl,
        'location': _location.text,
        'category': selectedCategory,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (widget.feed == null) {
        // Create new post in Firestore
        await FirebaseFirestore.instance.collection('feeds').add(postData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully')),
        );
      } else {
        // Update existing post in Firestore
        await FirebaseFirestore.instance
            .collection('feeds')
            .doc(widget.feed!.id)
            .update(postData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post updated successfully')),
        );
      }

      Navigator.of(context).pop(); // Go back to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error ${widget.feed == null ? 'creating' : 'updating'} post: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.feed == null ? 'Create Post' : 'Edit Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.data == null) {
                      return const SizedBox.shrink();
                    }
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage('${snapshot.data?["imageUrl"]}'),
                      ),
                      title: Text('${snapshot.data?["fullName"]}'),
                      subtitle: Text(DateTime.now().formatDate()),
                    );
                  }),
              TextField(
                controller: _captionController,
                decoration: const InputDecoration(
                  hintText: 'Write your caption here...',
                  border: InputBorder.none,
                ),
                maxLines: 3,
              ),
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : _existingImageUrl != null
                          ? Image.network(_existingImageUrl!, fit: BoxFit.cover)
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, size: 50),
                                  Text('Add Images'),
                                  Text('Click Here to Upload'),
                                ],
                              ),
                            ),
                ),
              ),
              const SizedBox(height: 16),
              CustomInputField(
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: primaryColor,
                ),
                controller: _location,
                label: "Location",
                hint: "Ella, Sri Lanka",
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category, color: primaryColor),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category.toUpperCase()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _isLoading ? () {} : _uploadPost,
                loading: _isLoading,
                text: widget.feed == null ? "Post Now" : "Update Post",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
