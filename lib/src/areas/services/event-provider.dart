import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/services/database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class EventProvider with ChangeNotifier {
  // String _name;
  // String _description;
  // DateTime _date;
  var uuid = Uuid();

  final databaseService = DatabaseService();

  Stream<List<Event>> get events => databaseService.getEvents();
}