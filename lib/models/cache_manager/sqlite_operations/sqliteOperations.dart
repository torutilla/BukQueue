import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteOperations {
  static final SqliteOperations _instance = SqliteOperations._internal();
  Database? db;
  factory SqliteOperations() {
    return _instance;
  }
  SqliteOperations._internal();

  Future<Database> initDatabase() async {
    if (db != null) return db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );

    return db!;
  }

  Future<FutureOr<void>> _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE bookingHistory(id TEXT PRIMARY KEY, Pickup_Location TEXT NOT NULL, Dropoff_Location TEXT NOT NULL, Pickup_Lat REAL NOT NULL, Pickup_Lng REAL NOT NULL, Dropoff_Lat REAL NOT NULL, Dropoff_Lng REAL NOT NULL, Polyline TEXT NOT NULL, Date TEXT NOT NULL, Time TEXT NOT NULL)');
    await db.execute(
        'CREATE TABLE savedPlaces(PlaceID TEXT NOT NULL, Location TEXT NOT NULL, Location_Lat REAL NOT NULL, Location_Lng REAL NOT NULL)');
    await db.execute(
        'CREATE TABLE cachedPlacesResult(PlaceID TEXT NOT NULL, PlaceName TEXT NOT NULL)');
    // await db.execute(
    //     'CREATE TABLE cachedPlacesResult(Location TEXT NOT NULL, Location_Lat REAL NOT NULL, Location_Lng REAL NOT NULL)');
    await db.execute(
        'CREATE TABLE predictions(PlaceID TEXT NOT NULL, PlaceName TEXT NOT NULL)');
  }

  Future<List<Map<String, Object?>>> retrieveValuesInTable(String table,
      {String? condition, List<Object?>? args}) async {
    return await db!.query(
      table,
      where: condition != null && condition.isNotEmpty ? condition : null,
      whereArgs: args,
    );
  }

  Future<void> deleteValueInTable(String table, String condition,
      {List<Object?>? args}) async {
    await db!.delete(table, where: condition, whereArgs: args);
  }

  Future<void> updateValueInTable(
      String table, Map<String, Object?> values, String condition) async {
    await db!.update(
      table,
      values,
      where: condition,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertIntoTable(String table, Map<String, Object?> values,
      {Function(int value)? callback}) async {
    await db!
        .insert(
      table,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then(
      (value) {
        if (callback != null) {
          callback(value);
        }
      },
    );
  }
}
