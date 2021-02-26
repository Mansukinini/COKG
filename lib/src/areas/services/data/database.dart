import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  //create user
  Future<Users> createUser(Users userApp) {
    return _db.collection('user').doc(userApp.id).set(userApp.toMap()).then((value) {
      if (userApp.firstName != null) {
        _auth.currentUser.updateProfile(displayName: userApp.firstName + ' '+ userApp.lastName, photoURL: userApp.imageUrl);
        _auth.currentUser.reload();
      }
      return null;
    });
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
   
    return _db
      .collection('event')
      .doc(id)
      .get().then((event) => Event.fromFirestore(event.data()));
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