import 'dart:async';
import 'package:cokg/src/areas/services/providers/authentication.dart';
import 'package:cokg/src/resources/utils/circularProgressIndicator.dart';
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
  StreamSubscription userSubscription;

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
                    ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.snackBar(user.firstName + ' Logged'));
                    Navigator.pushNamed(context, '/home');
                  }
                });
              },
            );
          },
        ),

        AppButton(
          labelText: 'Sign In with Google',
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
          isAnimatedButton: false, 
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.loadingSnackBar('Loggin In...'));
            
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

  @override
  void dispose() {
    if (userSubscription != null)
      userSubscription.cancel();
    super.dispose();
  }
}