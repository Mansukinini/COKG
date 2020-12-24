import 'package:flutter/material.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final String date;

  Event({@required this.id, this.name, this.description, this.date});

  // Event.withId(this.id, this.name, this.description, this.date);

  // String get id => id;
  // String get name => name;
  // String get description => description;
  // String get date => date;

  set name(String name) {
    this.name = name;
  }

  set description(String description) {
    this.description = description;
  }

  set date(String date) {
    this.date = date;
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: json['date']
    );
  }

  Map <String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date
    };
  }
}