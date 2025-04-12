import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:notes_app/models/location_model.dart';
import 'package:notes_app/db/location_database_helper.dart';
import 'view_location_screen.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  File? _image;

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void saveLocation() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final newLocation = LocationModel(
        name: nameController.text,
        description: descriptionController.text,
        imagePath: _image!.path,
      );
      await LocationDatabaseHelper().insertLocation(newLocation);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location Saved")));
      Navigator.push(context, MaterialPageRoute(builder: (_) => ViewLocationsScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Location")),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Location Name'),
                  validator: (val) => val!.isEmpty ? "Enter name" : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (val) => val!.isEmpty ? "Enter description" : null,
                ),
                SizedBox(height: 10),
                _image != null ? Image.file(_image!, height: 150) : Text("No Image Selected"),
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text("Select Image"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveLocation,
                  child: Text("Save Location"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}