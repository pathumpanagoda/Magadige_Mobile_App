import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magadige/constants.dart';
import 'dart:io';

import 'package:magadige/models/travel.location.model.dart';
import 'package:magadige/modules/home/travel.location.service.dart';
import 'package:magadige/widgets/custom.filled.button.dart';
import 'package:magadige/widgets/custom.input.field.dart';

class AddLocationView extends StatefulWidget {
  const AddLocationView({Key? key}) : super(key: key);

  @override
  _AddLocationViewState createState() => _AddLocationViewState();
}

class _AddLocationViewState extends State<AddLocationView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _categoryController = TextEditingController();

  final TravelLocationService _locationService = TravelLocationService();
  File? _imageFile;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      setState(() {
        _isUploading = true;
      });
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('locations/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final downloadUrl = await _uploadImage(_imageFile!);

      if (downloadUrl != null) {
        final newLocation = TravelLocation(
          id: FirebaseFirestore.instance.collection('locations').doc().id,
          name: _nameController.text,
          description: _descriptionController.text,
          imageUrl: downloadUrl,
          address: _addressController.text,
          locationLatitude: double.parse(_latitudeController.text),
          locationLongitude: double.parse(_longitudeController.text),
          category: _categoryController.text,
        );

        try {
          await _locationService.addTravelLocation(newLocation);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location added successfully')),
          );
          Navigator.pop(context); // Go back to the previous screen
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding location: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and upload an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Location',
          style: TextStyle(color: titleGrey),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomInputField(
                controller: _nameController,
                hint: "Example Name",
                label: "Name",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              CustomInputField(
                controller: _descriptionController,
                label: "Description",
                hint: "Sample desc",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              CustomInputField(
                controller: _addressController,
                hint: "Colombo",
                label: "Location",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an address' : null,
              ),
              CustomInputField(
                controller: _latitudeController,
                label: "Latitude",
                hint: "10.12",
                inputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Please enter a valid latitude'
                        : null,
              ),
              CustomInputField(
                controller: _longitudeController,
                label: "Longitude",
                hint: "0.12",
                inputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Please enter a valid longitude'
                        : null,
              ),
              CustomInputField(
                controller: _categoryController,
                label: "Category",
                hint: "Hotel",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a category' : null,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: Center(
                          child: Text('Tap to pick an image'),
                        ),
                      ),
              ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: _isUploading ? () {} : _submitForm,
                loading: _isUploading,
                text: "Add Location",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
