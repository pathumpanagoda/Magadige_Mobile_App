import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:magadige/widgets/custom.filled.button.dart';
import 'package:magadige/widgets/custom.input.field.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  bool _loading = false;

  late String? _userName;
  late String? _userEmail;
  late String? _userId;
  String? _profileImageUrl;
  String? _userBio;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _loading = true;
    });

    User? user = _auth.currentUser;
    if (user != null) {
      _userEmail = user.email;
      _userId = user.uid;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_userId).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc.get('fullName');
          _profileImageUrl = userDoc.get('imageUrl');
          _userBio = userDoc.get('bio') ?? "";
        });
        _nameController.text = _userName ?? '';
        _bioController.text = _userBio ?? '';
      }
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
      _uploadImageToFirestore();
    }
  }

  Future<void> _uploadImageToFirestore() async {
    setState(() {
      _loading = true;
    });

    try {
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$_userId.jpg');
      UploadTask uploadTask = storageRef.putFile(File(_pickedImage!.path));

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'imageUrl': downloadUrl,
      });

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error uploading image')),
      );
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      await _firestore.collection('users').doc(_userId).set({
        'fullName': _nameController.text,
        'email': _userEmail,
        'imageUrl': _profileImageUrl ?? '',
        'bio': _bioController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving profile')),
      );
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/logo.png')
                                as ImageProvider,
                        child: _pickedImage == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      controller: _nameController,
                      hint: "John Doe",
                      label: "Full name",
                    ),
                    const SizedBox(height: 10),
                    CustomInputField(
                      controller: _bioController,
                      hint: "Tell us about yourself",
                      label: "Bio",
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _userEmail ?? 'Loading email...',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: _saveProfile,
                      text: "Save Profile",
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
