import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final dbname = 'student.db';
  static final dbversion = 1;
  static final tableName = 'Student';

  static final columnID = '_id';
  static final columnName = 'name';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbname);
    return await openDatabase(path, version: dbversion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE $tableName (
    $columnID INTEGER PRIMARY KEY,
    $columnName TEXT NOT NULL ) 
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnID];
    return await db
        .update(tableName, row, where: '$columnID=?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: '$columnID=?', whereArgs: [id]);
  }
}
