import 'package:flutter/material.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final String date;
  final String imageUrl;
  final bool isUploaded;
  final String createdBy;
  final String createdOn;
  final String lastUploadBy;
  final String lastUploadOn;
  

  Event({@required this.id, @required this.name, this.description, 
    this.date, this.imageUrl = "", this.isUploaded = false, this.createdBy, this.createdOn,
    this.lastUploadBy, this.lastUploadOn});

  factory Event.fromFirestore(Map<String, dynamic> firestore) {
    return Event(
      id: firestore['id'],
      name: firestore['name'],
      description: firestore['description'],
      date: firestore['date'],
      imageUrl: firestore['imageUrl'],
      isUploaded: firestore['isUploaded'],
      createdBy: firestore['createdBy'],
      createdOn: firestore['createdOn'],
      lastUploadBy: firestore['lastUpdatedBy'],
      lastUploadOn: firestore['lastUpdatedOn']
    );
  }

  Map <String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date,
      'imageUrl': imageUrl,
      'isUploaded': isUploaded,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'lastUpdatedBy': lastUploadBy,
      'lastUpdatedOn': lastUploadOn
    };
  }
}