import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:magadige/models/event.model.dart';
import 'package:magadige/modules/event/service.dart';
import 'package:magadige/widgets/custom.filled.button.dart';
import 'package:magadige/widgets/custom.input.field.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('events/${DateTime.now().toIso8601String()}.jpg');

    UploadTask uploadTask = storageRef.putFile(_imageFile!);
    TaskSnapshot snapshot = await uploadTask;

    _imageUrl = await snapshot.ref.getDownloadURL();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_imageFile != null) {
        setState(() {
          _isLoading = true;
        });
        await _uploadImage();
      }

      final userId = FirebaseAuth.instance.currentUser!.uid;

      final newEvent = Event(
        id: '',
        name: _nameController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrl ?? '',
        userId: userId,
      );

      await EventService().createEvent(newEvent);

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop(); // Go back to event list
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomInputField(
                controller: _nameController,
                label: "Event Name",
                hint: "Halloween",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              CustomInputField(
                controller: _descriptionController,
                label: "Description",
                hint: "Description about your event..",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      height: 150,
                    )
                  : const Text('No image selected'),
              CustomButton(
                onPressed: _pickImage,
                text: "Pick Image",
              ),
              const SizedBox(height: 20),
              CustomButton(
                loading: _isLoading,
                onPressed: _isLoading ? () {} : _submit,
                text: "Create Event",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
