import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/Event.dart';

class DatabaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get Event
  Stream<List<Event>> getEvents() {
    return _db.collection('event')
    .snapshots()
    .map((event) => event.docs
    .map((doc) => Event.fromFirestore(doc.data()))
    .toList());
  }

  Future<Event> getEventById(String id) {
    print(id);
    
    return _db.collection('event')
      .doc(id).get()
      .then((event) => Event.fromFirestore(event.data()));
  }

  // Create
  Future saveChanges(Event event) {
    var option = SetOptions(merge: true);
    
    //Todo: Implemente the lastUpdateBy and LastUpdatedOn
    if (event.createdOn != null) {
      // print(event.toMap());
    }

    return _db.collection('event')
    .doc(event.id)
    .set(event.toMap(), option);
  }
}