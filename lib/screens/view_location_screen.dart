

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:notes_app/models/location_model.dart';
import 'package:notes_app/db/location_database_helper.dart';
import 'edit_location_screen.dart';

class ViewLocationsScreen extends StatefulWidget {
  @override
  _ViewLocationsScreenState createState() => _ViewLocationsScreenState();
}

class _ViewLocationsScreenState extends State<ViewLocationsScreen> {
  late Future<List<LocationModel>> _locations;

  @override
  void initState() {
    super.initState();
    _locations = LocationDatabaseHelper().getAllLocations();
  }

  void _refresh() {
    setState(() {
      _locations = LocationDatabaseHelper().getAllLocations();
    });
  }

  void _delete(int id) async {
    await LocationDatabaseHelper().deleteLocation(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location Deleted")));
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Locations")),
      body: FutureBuilder<List<LocationModel>>(
        future: _locations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("No locations yet."));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final location = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.file(File(location.imagePath), width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(location.name!),
                  subtitle: Text(location.description!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditLocationScreen(location: location),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(location.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
