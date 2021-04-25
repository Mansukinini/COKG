import 'dart:async';

import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/services/data/database.dart';
import 'package:cokg/src/resources/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    
class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Declare variable
  final _firstName = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmPassword = BehaviorSubject<String>();
  final _user = BehaviorSubject<Users>();

  //setters
  Function(String) get setFirstName => _firstName.sink.add;
  Function(String) get setLastName => _lastName.sink.add;
  Function(String) get setEmail => _email.sink.add;
  Function(String) get setPassword => _password.sink.add;
  Function(String) get setConfirmPassword => _confirmPassword.sink.add;


  //getters
  Stream<String> get firstName => _firstName.stream.transform(_validateName);
  Stream<String> get lastName => _lastName.stream.transform(_validateName);
  Stream<String> get email => _email.stream;
  Stream<String> get password => _password.stream.transform(_validatePassword);
  Stream<String> get confirmPassword => _confirmPassword.stream;
  Stream<Users> get user => _user.stream;
  Stream<bool> get isValid => CombineLatestStream.combine2(email, password, (email, password) => true);


  Future<Users> signup() async {

    try {
      UserCredential userAuth = await _auth.createUserWithEmailAndPassword(email: _email.value, password: _password.value);
      if (_firstName.value != '' && _lastName.value != '') {
        User user = userAuth.user;
        user.updateProfile(displayName: _firstName.value + ' ' + _lastName.value);
      }
      
      return await DatabaseService.createUser(Users(id: userAuth.user.uid, firstName: _firstName.value, lastName: _lastName.value,
      email: _email.value.trim(), createdOn: DateTime.now().toIso8601String()));
    } on FirebaseAuthException catch (error) {
        print(error);
        return null;
    }
  }

  Future<Users> login() async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: _email.value, password: _password.value);
     
      var user = await DatabaseService.getUserById(userCredential.user.uid);
      _user.sink.add(user);
      return user;
 
    }on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signOut() async {
    try
    {
      await _auth.signOut().then((value) => _user.sink.add(null));
     
      return _auth.currentUser;
    }on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    var currentUser = _auth.currentUser;

    if (currentUser != null) {
      var userData = await DatabaseService.getUserById(currentUser.uid);
      _user.add(userData);
    } else {
      return false;
    }

    return true;
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

  dispose() {
    _confirmPassword.close();
    _password.close();
    _email.close();
    _lastName.close();
    _firstName.close();
    _user.close();
  }
}