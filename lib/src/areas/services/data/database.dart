import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/models/user.dart';

class DatabaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //create user
  Future<void> createUser(Users user) {
    return _db.collection('user').doc(user.id).set(user.toMap());
  }

  Future<Users> getUserById(String id) {
    return _db.collection('user').doc(id).get()
    .then((user) => Users.fromFirestore(user.data()));
  }

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