import 'dart:async';
import 'package:cokg/src/areas/services/providers/authentication.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';
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
        SizedBox(height: MediaQuery.of(context).size.height * .1),
          //Todo : Image container Don't delete
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.grey.shade100.withOpacity(0.55),
        //     image: DecorationImage(
        //       image: AssetImage("assets/images/color1.jpg"),
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),

        Container(
          height: MediaQuery.of(context).size.height * .25,
          child: CircleAvatar(
            // radius: 20.0,
            backgroundImage: AssetImage('assets/images/user.jpg',),
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
        
        // Todo: Add forgot password functionality
        FlatButton(
          onPressed: (){},
          textColor: AppColors.black,
          child: Text('Forgot Password'),
        ),

        StreamBuilder<bool>(
          stream: authenticate.isValid,
          builder: (context, user){
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

        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Does not have account?', style: TextStyles.suggestion),

              FlatButton(
                child: Text('Sign up', style: TextStyle(fontSize: 20.0)),
                textColor: AppColors.brown,
                onPressed: () => Navigator.pushNamed(context, '/signup'),
              )
            ]
          ),

        )
      ],
    );
  }
}