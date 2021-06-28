import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/Event.dart';
import 'package:cokg/src/areas/models/devotion.dart';
import 'package:cokg/src/areas/models/group.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../config.dart';

class DatabaseService {
  var uuid = Uuid();
   
  //create user
  static Future createUser(UserAuth userApp) {
    
    return FirebaseFirestore.instance.collection('user')
      .doc(userApp.id).set(userApp.toMap())
      .then((value) {

        FirebaseAuth.instance.currentUser.updateProfile(displayName: userApp.firstName, photoURL: userApp.imageUrl);
        return FirebaseAuth.instance.currentUser;
    });
  }

  static Future createAdmin() {
    return FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: Config.admin, password: Config.password);
  }

  static Future<UserAuth> getUserById(String id) {

    return FirebaseFirestore.instance.collection('user').doc(id).get()
          .then((user) => UserAuth.fromFirestore(user.data()));
  }

  // Create
  static Future saveEvent(Event event) {
    var option = SetOptions(merge: true);
    
    return FirebaseFirestore.instance.collection('event')
      .doc(event.id)
      .set(event.toMap(), option);
  }

  // Get Event
  static Stream<List<Event>> getEvents() {

    return FirebaseFirestore.instance.collection('event')
    .orderBy('date', descending: true)
    .snapshots()
    .map((event) => event.docs
    .map((doc) => Event.fromFirestore(doc.data()))
    .toList());
  }

  static Future<Event> getEventById(String id) {
   
    return FirebaseFirestore.instance.collection('event')
      .doc(id)
      .get().then((event) => Event.fromFirestore(event.data()));
  }

  static Future<void> deleteEvent(String id) {

    return FirebaseFirestore.instance.collection('event')
      .doc(id)
      .delete()
      .then((value) => print("Event Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
  }

  // Get group
  static Stream<List<Group>> getGroups() {

    return FirebaseFirestore.instance.collection('group')
    .orderBy('name', descending: true)
    .snapshots()
    .map((group) => group.docs
    .map((doc) => Group.fromFirestore(doc.data()))
    .toList());
  }

  static Future<Group> getGroupById(String id) {
   
    return FirebaseFirestore.instance.collection('group')
      .doc(id)
      .get().then((group) => Group.fromFirestore(group.data()));
  }

  static Future saveGroup(Group group) {
    var option = SetOptions(merge: true);

    return FirebaseFirestore.instance.collection('group')
      .doc(group.id)
      .set(group.toMap(), option);
  }

  static Future<void> deleteGroup(String id) {

    return FirebaseFirestore.instance.collection('group')
      .doc(id)
      .delete()
      .then((value) => print("group Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
  }

  //create Devotion
  static Future<void> createDevotion(Devotion devotion) {

    return FirebaseFirestore.instance.collection('devotion')
      .doc(devotion.id)
      .set(devotion.toMap()).then((value) => null);
  }

  static Stream<List<Devotion>> getDevotions() {


    return FirebaseFirestore.instance.collection('devotion')
    .orderBy('createdOn', descending: true)
    .snapshots()
    .map((devotion) => devotion.docs
    .map((doc) => Devotion.fromFirestore(doc.data()))
    .toList());
  }
  
  static Future<Devotion> getDevotionById(String id) {

    return FirebaseFirestore.instance.collection('devotion')
      .doc(id).get()
      .then((devotion) => Devotion.fromFirestore(devotion.data()));
  }

  static Future<void> deleteDevotion(String id) {

    return FirebaseFirestore.instance.collection('devotion')
      .doc(id)
      .delete()
      .then((value) => print("devotion Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
  }
}