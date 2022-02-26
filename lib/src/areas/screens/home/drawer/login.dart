import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/screens/home/drawer/createAccount.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/areas/services/providers/authentication.dart';
import 'package:cokg/src/resources/utils/circularProgressIndicator.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  StreamSubscription userSubscription;
  String username;

  @override
  void initState() {
    final authenticate = Provider.of<Authentication>(context, listen: false);
    userSubscription = authenticate.user.listen((user) {
      if (user != null)
        Navigator.pushReplacementNamed(context, "/home");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
      ),
      body: _pageBody(context)
    );
  }

  submit() {
    _formKey.currentState.save();
  }

  Widget _pageBody(BuildContext context) {
    final authenticate = Provider.of<Authentication>(context);
    
    return ListView(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * .10),

        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            
              Padding(
                padding: const EdgeInsets.only(left:14.0),
                child: Text("Sign In", style: TextStyles.blackTitle),
              ),

              Padding(
                padding: const EdgeInsets.only(left:14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('New User?', style: TextStyles.suggestion),
                    TextButton(
                      child: Text('Create an account', style: TextStyle(fontSize: 16.0)),
                      style: TextButton.styleFrom(primary: Colors.brown),
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                    )
                  ]
                ),
              )
            ]
          ),
        ),

        StreamBuilder<String>(
          stream: authenticate.email,
          builder: (context, user) {

            return AppTextField(
              labelText: 'Username',
              hintText: 'exemple@gmail.com', 
              textInputType: TextInputType.emailAddress, 
              onChanged: authenticate.setEmail
            );
          }
        ),

        StreamBuilder<String>(
          stream: authenticate.password,
          builder: (context, user){

            return AppTextField(labelText: 'Password', onChanged: authenticate.setPassword, obscureText: true);
          },
        ),

        StreamBuilder<bool>(
          stream: authenticate.isValid,
          builder: (context, user) {

            return AppButton(labelText: 'Log In', buttonType: ButtonType.LightBlue, 
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.loadingSnackBar('Loggin In...'));
                
                await authenticate.login().then((user) {
                  if (user != null) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.snackBar('${user.displayName} Logged'));
                    Navigator.pushNamed(context, '/home');
                  }
                });
              },
            );
          },
        ),

        AppButton(
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
          labelText: 'Sign In with Google',
          isAnimatedButton: false, 
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.loadingSnackBar('Loggin In...'));
            
            // await createUserInFirestore();

            await authenticate.signInWithGoogle().then((userData) {
              authenticate.createUser(userData.user).whenComplete(() {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.snackBar(userData.user.displayName + ' Logged'));
                Navigator.pushNamed(context, '/home');
              });
            });
          }
        )
      ],
    );
  }

  createUserInFirestore() async {
    // 1) check if the user exists in users collection in database (according tp their id)
    final GoogleSignInAccount user = GoogleSignIn().currentUser;
    
    if (user != null) {
      final DocumentSnapshot doc = await userRef.doc(user.id).get();  

      // 2) If the user doesn't exists, then we want to take them to the create account page
      if (!doc.exists) {
        final username = Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));

        // 3) get username from create account, use it to make new user document in users collection
        userRef.doc(user.id).set({
          "id": user.id,
          "username": username,
          "photoUrl": user.photoUrl,
          "email": user.email,
          "displayName": user.displayName,
          "bio": null, 
          "createdBy": null,
          "createdOn": timestamp
        });
      }
    }
  }

  @override
  void dispose() {
    if (userSubscription != null)
      userSubscription.cancel();
    super.dispose();
  }
}