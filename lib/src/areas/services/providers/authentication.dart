import 'dart:async';
import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/services/data/database.dart';
import 'package:cokg/src/resources/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final _user = BehaviorSubject<UserAuth>();

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
  Stream<UserAuth> get user => _user.stream;
  Stream<bool> get isValid => CombineLatestStream.combine2(email, password, (email, password) => true);


  Future<UserAuth> login() async {
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
    try {
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

  Future<User> signup() async {
    UserCredential userCredential;
    try {
      if (_email.hasValue && _password.hasValue) {
        userCredential = await _auth.createUserWithEmailAndPassword(email: _email.value, password: _password.value);
        
        if(_firstName.hasValue && _lastName.hasValue) {
          userCredential.user.updateProfile(displayName: _firstName.value + ' ' + _lastName.value);
        }
          
        if (userCredential.user.uid.isNotEmpty) {
          return await DatabaseService.createUser(UserAuth(id: userCredential.user.uid, firstName: _firstName.value.trim(), lastName: _lastName.value.trim(),
            email: _email.value.trim(), createdOn: DateTime.now().toIso8601String()));
        }
      }
        
      return (userCredential != null && userCredential.user != null) ? userCredential.user: null;
    } on FirebaseAuthException catch (error) {
      print(error.stackTrace);
      return null;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    return await _auth.signInWithCredential(credential);
  }

  void createUser(User userData) async {
   
    // final user = await DatabaseService.getUserById(userData.uid);

    // if (user == null && user.id == null) {
      DatabaseService.createUser(UserAuth(id: userData.uid, firstName: userData.displayName, 
              email: userData.email, contactNo: userData.phoneNumber, imageUrl: userData.photoURL,
              createdOn: DateTime.now().toIso8601String()));

              _user.sink.add(UserAuth(id: userData.uid, firstName: userData.displayName, 
              email: userData.email, contactNo: userData.phoneNumber, imageUrl: userData.photoURL,
              createdOn: DateTime.now().toIso8601String()));
     
    // }
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