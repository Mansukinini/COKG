import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/Event.dart';

class DatabaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get Event
  Stream<List<Event>> getEvents() {
    return _db.collection('event')
    .snapshots()
    .map((event) => event.docs
    .map((doc) => Event.fromJson(doc.data()))
    .toList());
  }

  // Create
  Future saveChanges(Event event) {
    var option = SetOptions(merge: true);
    
    return _db.collection('event')
    .doc(event.id)
    .set(event.toMap(), option);
  }
}