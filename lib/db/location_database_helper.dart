import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/location_model.dart';

class LocationDatabaseHelper {
  static final LocationDatabaseHelper _instance = LocationDatabaseHelper._internal();
  factory LocationDatabaseHelper() => _instance;
  LocationDatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'locations.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE locations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertLocation(LocationModel location) async {
    final db = await database;
    await db.insert('locations', location.toMap());
  }

  Future<List<LocationModel>> getAllLocations() async {
    final db = await database;
    final maps = await db.query('locations');
    return List.generate(maps.length, (i) => LocationModel.fromMap(maps[i]));
  }

  Future<void> updateLocation(LocationModel location) async {
    final db = await database;
    await db.update('locations', location.toMap(), where: 'id = ?', whereArgs: [location.id]);
  }

  Future<void> deleteLocation(int id) async {
    final db = await database;
    await db.delete('locations', where: 'id = ?', whereArgs: [id]);
  }
}
