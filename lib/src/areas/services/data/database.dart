import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/models/devotion.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
   var uuid = Uuid();
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

  //create Devotion
  static Future<void> createDevotion(Devotion devotion) {
    return FirebaseFirestore.instance.collection('Devotion')
      .doc(devotion.id)
      .set(devotion.toMap()).then((value) => null);
  }

  static Future<Devotion> getDevotionById(String id) {
    return FirebaseFirestore.instance.collection('Devotion').doc(id).get()
    .then((devotion) => Devotion.fromFirestore(devotion.data()));
  }

  Future<Users> getUserById(String id) {
    return _db.collection('user').doc(id).get()
    .then((user) => Users.fromFirestore(user.data()));
  }

  // Get Event
  static Stream<List<Event>> getEvents() {
    return FirebaseFirestore.instance.collection('event')
    .snapshots()
    .map((event) => event.docs
    .map((doc) => Event.fromFirestore(doc.data()))
    .toList());
  }

  static Stream<List<Devotion>> getDevotions() {
    return FirebaseFirestore.instance.collection('Devotion')
    .snapshots()
    .map((devotion) => devotion.docs
    .map((doc) => Devotion.fromFirestore(doc.data()))
    .toList());
  }

  static Future<Event> getEventById(String id) {
   
    return FirebaseFirestore.instance.collection('event')
      .doc(id)
      .get().then((event) => Event.fromFirestore(event.data()));
  }

  // Create
  static Future saveChanges(Event event) {
    var option = SetOptions(merge: true);
    
    //Todo: Implemente the lastUpdateBy and LastUpdatedOn
    if (event.id != null) {
      // event. = uuid.v4();
    }

    return FirebaseFirestore.instance.collection('event')
    .doc(event.id)
    .set(event.toMap(), option);
  }
}