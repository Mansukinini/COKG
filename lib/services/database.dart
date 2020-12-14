import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference event = FirebaseFirestore.instance.collection('event');

  Future updateEvent(String name, String description, String date) async {
    return await event.doc(uid).set({
      'name': name,
      'description': description,
      'date': date
    });
  }

}