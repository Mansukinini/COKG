import 'package:cokg/models/Event.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';


class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblEvent = "event";
  String colId = "id";
  String colName = "name";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

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

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $tblEvent($colId INTEGER PRIMARY KEY, $colName TEXT, " +
      "$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)"
    );
  }

  Future<int> insertEvent(Event event) async {
    Database db = await this.db;
    var result = await db.insert(tblEvent, event.toMap());

    return result;
  }

  getEvents() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblEvent");
    return result;
  }
}
