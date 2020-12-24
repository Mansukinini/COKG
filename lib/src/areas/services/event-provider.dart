import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/services/database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class EventProvider with ChangeNotifier {
  final databaseService = DatabaseService();
  String _id;
  String _name;
  String _description;
  DateTime _date;
  var uuid = Uuid();
  
  String get id => _id;
  String get name => _name;
  String get description => _description;
  DateTime get date => _date;

  set id(String id) {
    _id = id;
    notifyListeners();
  }

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set description(String description) {
    _description = description;
    notifyListeners();
  }

  set date(DateTime date) {
    _date = date;
    notifyListeners();
  }
  
  Stream<List<Event>> get events => databaseService.getEvents();

  setChanges(Event event) {
    if (event.id != null) {
      _id = event.id;
      _name = event.name;
      _description = event.description;
      _date = DateTime.parse(event.date);
    } 
  }

  save() {
    if (_id == null) {
      var initialValues = Event(id: uuid.v4(), name: _name, description: _description, date: _date.toIso8601String());
      databaseService.saveChanges(initialValues).then((value) => print(value))
      .catchError((error) => print(error));
    } else {
      var event = Event(id: _id, name: _name, description: _description, date: _date.toIso8601String());
      databaseService.saveChanges(event).then((value) => print(value))
      .catchError((error) => print(error));
    }
  }
}