import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/models/location_model.dart';
import 'package:notes_app/db/location_database_helper.dart';

class EditLocationScreen extends StatefulWidget {
  final LocationModel location;

  EditLocationScreen({required this.location});

  @override
  _EditLocationScreenState createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.location.name!;
    descriptionController.text = widget.location.description!;
    _image = File(widget.location.imagePath!);
  }

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void updateLocation() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final updatedLocation = LocationModel(
        id: widget.location.id,
        name: nameController.text,
        description: descriptionController.text,
        imagePath: _image!.path,
      );
      await LocationDatabaseHelper().updateLocation(updatedLocation);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location Updated")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Location")),
      body: Padding(
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
                onPressed: updateLocation,
                child: Text("Update Location"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
