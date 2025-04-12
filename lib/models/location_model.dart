
class LocationModel {
  int? id;
  String? name;
  String? description;
  final String imagePath;

  LocationModel({this.id, required this.name, this.description, required this.imagePath});


    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
    };
  }

  // Convert a map into a LocationModel
    factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imagePath: map['imagePath'],
    );
  }
}

