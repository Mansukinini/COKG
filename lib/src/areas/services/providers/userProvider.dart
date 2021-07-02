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
  final _contactNo = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _imageUrl = BehaviorSubject<String>();
  final _isValid = BehaviorSubject<bool>();
  final _createdBy = BehaviorSubject<String>();
  final _createdOn = BehaviorSubject<DateTime>();
  final _lastUpdatedBy = BehaviorSubject<String>();
  final _lastUpdatedOn = BehaviorSubject<DateTime>();

  final _userAuth = BehaviorSubject<UserAuth>();

  //Get Data
  Stream<String> get getId => _id.stream;
  Stream<String> get getFirstName => _firstName.stream;
  Stream<String> get getLastName => _lastName.stream;
  Stream<String> get getContactNo => _contactNo.stream;
  Stream<String> get getEmail => _email.stream;
  Stream<String> get getImageUrl => _imageUrl.stream;
  Stream<bool> get getIsValid => _isValid.stream;
  Stream<String> get getCreatedBy => _createdBy.stream;
  Stream<DateTime> get getCreatedOn => _createdOn.stream;
  Stream<String> get getLastUpdatedBy => _lastUpdatedBy.stream;
  Stream<DateTime> get getLastUpdatedOn => _lastUpdatedOn.stream;

  Stream<UserAuth> get getUserAuth => _userAuth.stream;

  //Set Data
  Function(String) get setId => _id.sink.add;
  Function(String) get setFirstName => _firstName.sink.add;
  Function(String) get setLastName => _lastName.sink.add;
  Function(String) get setContactNo => _contactNo.sink.add;
  Function(String) get setEmail => _email.sink.add;
  Function(String) get setImageUrl => _imageUrl.sink.add;
  Function(bool) get setIsValid => _isValid.sink.add;
  Function(String) get setCreatedBy => _createdBy.sink.add;
  Function(DateTime) get setCreatedOn => _createdOn.sink.add;
  Function(String) get setLastUpdatedBy => _lastUpdatedBy.sink.add;
  Function(DateTime) get setLastUpdatedOn => _lastUpdatedOn.sink.add;

  Function(UserAuth) get setUsers => _userAuth.sink.add;

  void setUser(UserAuth userAuth, String id) {
    setId(id);

    if (id != null) {
      setFirstName(userAuth.firstName);
      setLastName(userAuth.lastName);
      setContactNo(userAuth.contactNo);
      setEmail(userAuth.email);

      if (userAuth != null && userAuth.imageUrl != null) {
        setImageUrl(userAuth.imageUrl);
      }

    } else {
      setImageUrl(null);
      setFirstName(null);
      setLastName(null);
      setContactNo(null);
      setEmail(null);
    }
  }

  Future<UserAuth> getUserData(String id) async {
    var result;

    await _firestoreService.getUserById(id).then((value) {
      result = value;
    });

    return result;
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
        UserAuth user = UserAuth(
        id: FirebaseAuth.instance.currentUser.uid ?? uuid.v4(), 
        firstName: _firstName.value ?? null, 
        lastName: _lastName.value ?? null, 
        contactNo: _contactNo.value ?? null, 
        imageUrl: _imageUrl.value ?? null, 
        isValid: true, 
        email: _email.value ?? null);

      return await _firestoreService.createUser(user);
    }on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  void dispose() {
    _id.close();
    _firstName.close();
    _lastName.close();
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