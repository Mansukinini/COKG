import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/models/devotion.dart';
import 'package:cokg/src/areas/models/group.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  var uuid = Uuid();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Singleton setup: prevents multiple instance of this class
  FirestoreService._();
  static final FirestoreService _service = FirestoreService._();
  factory FirestoreService() => _service;

  static FirestoreService get instance => _service;

   
  //create user
  Future createUser(UserAuth userApp) {
    final CollectionReference collection = _firebaseFirestore.collection('user');
    
    return collection
      .doc(userApp.id).set(userApp.toMap())
      .then((value) {
        FirebaseAuth.instance.currentUser.updateProfile(displayName: userApp.firstName, photoURL: userApp.imageUrl);
        return FirebaseAuth.instance.currentUser;
    });
  }

  Future<UserAuth> getUserById(String id) {
    final CollectionReference collection = _firebaseFirestore.collection('user');

    return collection.doc(id).get()
          .then((user) => UserAuth.fromFirestore(user.data()));
  }

  // Create
  Future<void> saveEvent(Event event) {
    final CollectionReference collection = _firebaseFirestore.collection('event');
    var option = SetOptions(merge: true);
    
    return collection
      .doc(event.id)
      .set(event.toMap(), option);
  }

  // Get Event
  Stream<List<Event>> getEvents() {
    final CollectionReference collection = _firebaseFirestore.collection('event');

    return collection
      .orderBy('date', descending: true)
      .snapshots()
      .map((event) => event.docs
      .map((doc) => Event.fromFirestore(doc.data()))
      .toList());
  }

  Future<Event> getEventById(String id) {
    final CollectionReference collection = _firebaseFirestore.collection('event');

    return collection
      .doc(id)
      .get().then((event) => Event.fromFirestore(event.data()));
  }

  Future<void> deleteEvent(String id) {
    final CollectionReference collection = _firebaseFirestore.collection('event');

    return collection
      .doc(id)
      .delete()
      .then((value) => print("Event Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
  }

  // Get group
  Stream<List<Group>> getGroups() {
    final CollectionReference collection = _firebaseFirestore.collection('group');

    return collection
    .orderBy('name', descending: true)
    .snapshots()
    .map((group) => group.docs
    .map((doc) => Group.fromFirestore(doc.data()))
    .toList());
  }

  Future<Group> getGroupById(String id) {
    final CollectionReference collection = _firebaseFirestore.collection('group');

    return collection.doc(id)
      .get().then((group) => Group.fromFirestore(group.data()));
  }

  Future saveGroup(Group group) {
    final CollectionReference collection = _firebaseFirestore.collection('group');
    var option = SetOptions(merge: true);

    return collection.doc(group.id).set(group.toMap(), option);
  }

  Future<void> deleteGroup(String id) {
    final CollectionReference collection = _firebaseFirestore.collection('group');

    return collection
      .doc(id)
      .delete()
      .then((value) => print("group Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
  }

  //create Devotion
  Future<void> createDevotion(Devotion devotion) {
    final CollectionReference collection = _firebaseFirestore.collection('devotion');

    return collection
      .doc(devotion.id)
      .set(devotion.toMap()).then((value) => null);
  }

  Stream<List<Devotion>> getDevotions() {
    final CollectionReference collection = _firebaseFirestore.collection('devotion');

    return collection
    .orderBy('createdOn', descending: true)
    .snapshots()
    .map((devotion) => devotion.docs
    .map((doc) => Devotion.fromFirestore(doc.data()))
    .toList());
  }
  
  Future<Devotion> getDevotionById(String id) {
    final CollectionReference collection = _firebaseFirestore.collection('devotion');

    return collection
      .doc(id).get()
      .then((devotion) => Devotion.fromFirestore(devotion.data()));
  }

  Future<void> deleteDevotion(String id) {
    final CollectionReference collection = _firebaseFirestore.collection('devotion');

    return collection
      .doc(id)
      .delete()
      .then((value) => print("devotion Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
  }
}