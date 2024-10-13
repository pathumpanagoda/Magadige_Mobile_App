import 'dart:io';
import 'package:flutter/material.dart';
import 'package:magadige/models/emergency.contact.model.dart';
import 'package:magadige/modules/shortcuts/emergency.contact.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:magadige/widgets/custom.input.field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class CreateContact extends StatefulWidget {
  const CreateContact({super.key});

  @override
  State<CreateContact> createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact> {
  final EmergencyContactService _service = EmergencyContactService();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image == null) return null;

    try {
      String fileName = path.basename(_image!.path);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('contact_images/$userId/$fileName');

      UploadTask uploadTask = storageRef.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _createContact() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        String? imageUrl = await _uploadImage();

        EmergencyContact newContact = EmergencyContact(
          id: '', // Firebase will generate this
          userId: userId,
          name: _nameController.text.trim(),
          contact: _contactController.text.trim(),
          imageUrl: imageUrl,
        );

        await _service.addContact(newContact);
        Navigator.of(context).pop(true); // Return true to indicate success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding contact: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add Emergency Contact',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _nameController,
                hint: "John Doe",
                label: "Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _contactController,
                hint: "088121231231",
                label: "Contact Number",
                inputType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _createContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Add Contact',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
