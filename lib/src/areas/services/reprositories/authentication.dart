import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/services/data/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  // Declare variable
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmPassword = BehaviorSubject<String>();
  final _user = BehaviorSubject<Users>();

  //setters
  Function(String) get setEmail => _email.sink.add;
  Function(String) get setPassword => _password.sink.add;
  Function(String) get setConfirmPassword => _confirmPassword.sink.add;

  //getters
  Stream<String> get email => _email.stream;
  Stream<String> get password => _password.stream;
  Stream<String> get confirmPassword => _confirmPassword.stream;

  dispose() {
    _confirmPassword.close();
    _password.close();
    _email.close();
    _user.close();
  }

  signup() async {
    try {
      UserCredential userAuth = await _auth.createUserWithEmailAndPassword(email: _email.value, password: _password.value);
      var user = Users(id: userAuth.user.uid, email: _email.value.trim());
      print(user.email);
      print(user.toString());
      await _databaseService.createUser(user);
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }
}