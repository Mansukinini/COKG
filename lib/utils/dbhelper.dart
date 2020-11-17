import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';


class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  static Database _database;
  DbHelper._internal();
  
  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> get db async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "COKG.db";

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb() {

  }
}
