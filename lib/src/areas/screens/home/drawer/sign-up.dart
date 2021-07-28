
import 'dart:async';
import 'package:cokg/src/areas/services/providers/authentication.dart';
import 'package:cokg/src/resources/utils/circularProgressIndicator.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  StreamSubscription userSubscription;

 @override
 void initState() {
  final authenticate = Provider.of<Authentication>(context, listen: false);
    userSubscription = authenticate.user.listen((user) {
      if (user != null)
        Navigator.pushNamed(context, '/home');
    });
   super.initState();
 }

  @override
  Widget build(BuildContext context) {
    final authenticate = Provider.of<Authentication>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
      ),
      body: _pageBody(context, authenticate)
    );
  }

  Widget _pageBody(BuildContext context, Authentication authenticate) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 30.0,),

        StreamBuilder<String>(
          stream: authenticate.firstName,
          builder: (context, snapshot) {

            return AppTextField(
              labelText: 'Name',
              textInputType: TextInputType.emailAddress,
              onChanged: authenticate.setFirstName,
            );
          }
        ),

        StreamBuilder<String>(
          stream: authenticate.lastName,
          builder: (context, snapshot) {

            return AppTextField(
              labelText: 'Surname',
              textInputType: TextInputType.emailAddress,
              onChanged: authenticate.setLastName,
            );
          }
        ),

        StreamBuilder<String>(
          stream: authenticate.email,
          builder: (context, snapshot) {

            return AppTextField(
             labelText: 'Email',
              textInputType: TextInputType.emailAddress,
              onChanged: authenticate.setEmail,
            );
          }
        ),

        StreamBuilder<String>(
          stream: authenticate.password,
          builder: (context, snapshot) {

            return AppTextField(
              labelText: 'Password',
              obscureText: true,
              onChanged: authenticate.setPassword,
            );
          }
        ),

        StreamBuilder<String>(
          stream: authenticate.confirmPassword,
          builder: (context, snapshot) {

            return AppTextField(
              labelText: 'Confirm - Password',
              obscureText: true,
              onChanged: authenticate.setConfirmPassword,
            );
          }
        ),

        AppButton(
          labelText: 'Sign Up', 
          buttonType: ButtonType.LightBlue,
          onPressed: () async{ 
            ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.loadingSnackBar('Loggin up...'));
            
            await authenticate.signup().then((user) {
              if (user != null && user.email.isNotEmpty) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.snackBar(user.displayName + ' Successfully Logged'));
                Navigator.pushNamed(context, '/home');
              }
            });
          },
        ),

        AppButton(
          labelText: 'Sign Up with Google',
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
          isAnimatedButton: false, 
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.loadingSnackBar('Loggin Up...'));

            await authenticate.signInWithGoogle().then((userData) {
              authenticate.createUser(userData.user).whenComplete(() {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.snackBar(userData.user.displayName + ' Successfully Logged'));
                Navigator.pushNamed(context, '/home');
              });
            });
          }
        ),

      ],
    );
  }

  @override
  void dispose() {
    if (userSubscription != null)
      userSubscription.cancel();
    super.dispose();
  }
}