import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/services/data/firestore.dart';
import 'package:cokg/src/areas/services/data/firebase-storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';


class UserProvider {
  final FirestoreService _firestoreService = FirestoreService.instance;
  var uuid = Uuid();
  
  //Declare variables
  final _id = BehaviorSubject<String>();
  final _firstName = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();
  final _username = BehaviorSubject<String>();
  final _contactNo = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _imageUrl = BehaviorSubject<String>();
  final _isValid = BehaviorSubject<bool>();
  final _createdBy = BehaviorSubject<String>();
  final _createdOn = BehaviorSubject<DateTime>();
  final _lastUpdatedBy = BehaviorSubject<String>();
  final _lastUpdatedOn = BehaviorSubject<DateTime>();

  final _userAuth = BehaviorSubject<AuthUser>();

  //Get Data
  Stream<String> get getId => _id.stream;
  Stream<String> get getFirstName => _firstName.stream;
  Stream<String> get getLastName => _lastName.stream;
  Stream<String> get getUsername => _username.stream;
  Stream<String> get getContactNo => _contactNo.stream;
  Stream<String> get getEmail => _email.stream;
  Stream<String> get getImageUrl => _imageUrl.stream;
  Stream<bool> get getIsValid => _isValid.stream;
  Stream<String> get getCreatedBy => _createdBy.stream;
  Stream<DateTime> get getCreatedOn => _createdOn.stream;
  Stream<String> get getLastUpdatedBy => _lastUpdatedBy.stream;
  Stream<DateTime> get getLastUpdatedOn => _lastUpdatedOn.stream;

  Stream<AuthUser> get getUserAuth => _userAuth.stream;

  //Set Data
  Function(String) get setId => _id.sink.add;
  Function(String) get setFirstName => _firstName.sink.add;
  Function(String) get setLastName => _lastName.sink.add;
  Function(String) get setUsername => _username.sink.add;
  Function(String) get setContactNo => _contactNo.sink.add;
  Function(String) get setEmail => _email.sink.add;
  Function(String) get setImageUrl => _imageUrl.sink.add;
  Function(bool) get setIsValid => _isValid.sink.add;
  Function(String) get setCreatedBy => _createdBy.sink.add;
  Function(DateTime) get setCreatedOn => _createdOn.sink.add;
  Function(String) get setLastUpdatedBy => _lastUpdatedBy.sink.add;
  Function(DateTime) get setLastUpdatedOn => _lastUpdatedOn.sink.add;

  Function(AuthUser) get setUsers => _userAuth.sink.add;

  void setUser(AuthUser authUser, String id) {
    setId(id);

    if (id != null) {
      setFirstName(authUser.displayName);
      setContactNo(authUser.contactNo);
      setEmail(authUser.email);

      if (authUser != null && authUser.photoUrl != null) {
        setImageUrl(authUser.photoUrl);
      }

    } else {
      setImageUrl(null);
      setFirstName(null);
      setLastName(null);
      setContactNo(null);
      setEmail(null);
    }
  }

  Future<AuthUser> getUserData(String id) async {
    
    return await _firestoreService.getUserById(id);
  }

  Future pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    //Upload to Firebase
    if (pickedFile != null) {
      var imageUrlDb = await FirebaseStorageService.uploadProfileImage(File(pickedFile.path), uuid.v4());
      
      if (imageUrlDb != null) {
        setImageUrl(imageUrlDb);
      } 
    } else {
      print('fail');
    }
  }

  Future saveProfile() async {
    try {
        AuthUser user = AuthUser(
        id: FirebaseAuth.instance.currentUser.uid ?? uuid.v4(), 
        displayName: _firstName.value ?? null, 
        contactNo: _contactNo.value ?? null, 
        photoUrl: _imageUrl.value ?? null, 
        isActive: true, 
        email: _email.value ?? null
      );

      return await _firestoreService.createUser(user);
    }on FirebaseException catch (e) {
      print(e);
    }
  }

  void dispose() {
    _id.close();
    _firstName.close();
    _lastName.close();
    _username.close();
    _contactNo.close();
    _email.close();
    _imageUrl.close();
    _isValid.close();
    _createdBy.close();
    _createdOn.close();
    _lastUpdatedBy.close();
    _lastUpdatedOn.close();
    _userAuth.close();
  }
}