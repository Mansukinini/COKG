import 'dart:async';
import 'package:cokg/src/areas/services/providers/authentication.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  StreamSubscription _userSubscription;

  @override
  void initState() {
    final authenticate = Provider.of<Authentication>(context, listen: false);
    _userSubscription = authenticate.user.listen((user) {
      if (user != null)
        Navigator.pushReplacementNamed(context, "/home");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( body: _pageBody(context));
  }

  Widget _pageBody(BuildContext context) {
    final authenticate = Provider.of<Authentication>(context);
    
    return ListView(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * .15),

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

            return AppTextField(hintText: 'Email', textInputType: TextInputType.emailAddress, onChanged: authenticate.setEmail);
          }
        ),

        StreamBuilder<String>(
          stream: authenticate.password,
          builder: (context, user){

            return AppTextField(hintText: 'Password', onChanged: authenticate.setPassword, obscureText: true);
          },
        ),

        StreamBuilder<bool>(
          stream: authenticate.isValid,
          builder: (context, user) {

            return AppButton(labelText: 'Log In', buttonType: ButtonType.LightBlue, 
              onPressed: () {
                authenticate.login().then((response) {
                  if (response != null) {
                    Navigator.pop(context);
                  }
                });
              },
            );
          },
        ),

        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 12.0, left: 12.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.brown,
              onPrimary: Colors.white,
              minimumSize: Size(double.infinity, 45)
            ),
            icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
            onPressed: (){
              authenticate.signInWithGoogle().then((userData) {
                print(userData.user);
                authenticate.createUser(userData.user);
              });
            }, 
            label: Text('Sign Up with Google')
          ),
        ),
      ],
    );
  }
}