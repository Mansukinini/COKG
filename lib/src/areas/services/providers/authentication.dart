import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/services/data/firestore.dart';
import 'package:cokg/src/resources/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    
class Authentication {
  final FirestoreService _firestoreService = FirestoreService.instance;
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  // Singleton setup: prevents multiple instances of this class
  Authentication._();
  static final Authentication _authService = Authentication._();
  factory Authentication() => _authService;

  static Authentication get instance => _authService;

  // Declare variable
  final _firstName = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmPassword = BehaviorSubject<String>();
  final _user = BehaviorSubject<AuthUser>();

  //setters
  Function(String) get setFirstName => _firstName.sink.add;
  Function(String) get setLastName => _lastName.sink.add;
  Function(String) get setEmail => _email.sink.add;
  Function(String) get setPassword => _password.sink.add;
  Function(String) get setConfirmPassword => _confirmPassword.sink.add;

  //getters
  Stream<String> get firstName => _firstName.stream.transform(_validateName);
  Stream<String> get lastName => _lastName.stream.transform(_validateName);
  Stream<String> get email => _email.stream.transform(_validateEmail);
  Stream<String> get password => _password.stream.transform(_validatePassword);
  Stream<String> get confirmPassword => _confirmPassword.stream;
  Stream<AuthUser> get user => _user.stream;
  Stream<bool> get isValid => CombineLatestStream.combine2(email, password, (email, password) => true);

  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  User get currentUser => _firebaseAuth.currentUser;

  Future<AuthUser> login() async {
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: _email.value, password: _password.value);
     
      var user = await _firestoreService.getUserById(userCredential.user.uid);
      _user.sink.add(user);
      return user;
    }on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signOut() async {
    try {
      await _firebaseAuth.signOut().then((value) => _user.sink.add(null));
     
      return _firebaseAuth.currentUser;
    }on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    var currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      var userData = await _firestoreService.getUserById(currentUser.uid);
      _user.add(userData);
    } else {
      return false;
    }

    return true;
  }

  Future<User> signup() async {
    UserCredential userCredential;

    try {
      if (_email.hasValue && _password.hasValue) {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: _email.value, password: _password.value);
          
        if (userCredential != null && userCredential.user.uid.isNotEmpty) {
          return await _firestoreService.createUser(AuthUser(id: userCredential.user.uid, displayName: _firstName.value.trim(),
            email: _email.value.trim()));
        }
      }
        
      return (userCredential != null && userCredential.user != null) ? userCredential.user: null;
    } on FirebaseAuthException catch (error) {
      print(error.stackTrace);
      return null;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        );

        return _firebaseAuth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      // showAlertDialog(context, e.message ?? 'Sign In with Google failed');
      print(e.message ?? 'Sign In with Google failed');
    }
      return null;
    
  }

  Future<User> createUser(User userData) async {
   
    final authUser = await _firestoreService.getUserById(userData.uid);

    if (authUser != null && authUser.displayName == userData.displayName) {
      return _firestoreService.createUser(AuthUser(id: userData.uid, displayName: userData.displayName, 
              email: userData.email, contactNo: userData.phoneNumber, photoUrl: userData.photoURL)).then((value) => null);

              // _user.sink.add(AuthUser(id: userData.uid, firstName: userData.displayName, 
              // email: userData.email, contactNo: userData.phoneNumber, imageUrl: userData.photoURL,
              // createdOn: DateTime.now().toIso8601String()));
    }
    return null;
  }


  final _validateName = StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(name)) {
      sink.addError(StringConstant.nameValidateMessage);
    } else {
      sink.add(name);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(handleData: (password, sink) {
    if (password.length >= 5) {
      sink.add(password.trim());
    } else {
      sink.addError(StringConstant.passwordValidateMessage);
    }
  });

  final _validateEmail = StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError(StringConstant.emailValidateMessage);
    }
  });

  dispose() {
    _confirmPassword.close();
    _password.close();
    _email.close();
    _lastName.close();
    _firstName.close();
    _user.close();
  }
}