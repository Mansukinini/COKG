import 'package:cloud_firestore/cloud_firestore.dart';

class AuthUser {
  final String id;
  final String authUserRoleId;
  final String eventId;
  final String groupId;
  final String devotionId;
  final String username;
  final String displayName;
  final String bio;
  final String contactNo;
  final String email;
  final String photoUrl;
  final bool isActive;
  final String createdBy;
  final Timestamp createdOn;

  AuthUser({
    this.id, 
    this.authUserRoleId,
    this.eventId,
    this.groupId,
    this.devotionId,
    this.username,
    this.displayName,
    this.bio,
    this.contactNo, 
    this.email, 
    this.photoUrl, 
    this.isActive, 
    this.createdBy, 
    this.createdOn 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authUserRoleId' : authUserRoleId,
      'eventId': eventId,
      'groupId': groupId,
      'devotionId': devotionId,
      'username': username,
      'bio': bio,
      'contactNo': contactNo,
      'email': email,
      'photoUrl': photoUrl,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdOn': createdOn,
    };
  }

  factory AuthUser.fromDocument(DocumentSnapshot doc){

    return AuthUser(
      id: doc.data()['id'],
      // authUserRoleId: doc.data()['authUserRoleId'],
      // eventId: doc.data()['eventId'],
      // groupId: doc.data()['groupId'],
      // devotionId: doc.data()['devotionId'],
      username: doc.data()['username'],
      displayName: doc.data()['displayName'],
      bio: doc.data()['bio'],
      contactNo: doc.data()['contactNo'],
      email: doc.data()['email'],
      photoUrl: doc.data()['photoUrl'],
      isActive: doc.data()['isActive'],
      createdBy: doc.data()['createdBy'],
      createdOn: doc.data()['createdOn']
    );
  }

  AuthUser.fromFirestore(Map<String, dynamic> user)
    : id = user['id'],
    authUserRoleId = user['authUserRoleId'],
    eventId = user['eventId'],
    groupId = user['groupId'],
    devotionId = user['devotionId'],
    username = user['username'],
    displayName = user['displayName'],
    bio = user['bio'],
    contactNo = user['contactNo'],
    email = user['email'],
    photoUrl = user['photoUrl'],
    isActive = user['isActive'],
    createdBy = user['createdBy'],
    createdOn = user['createdOn'];
}