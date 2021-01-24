import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( body: _pageBody(context));
  }

  Widget _pageBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * .1),

        Container(
          height: MediaQuery.of(context).size.height * .25,
          child: CircleAvatar(
            backgroundImage: AssetImage('assests/images/Image0.jpeg'),
            radius: 50.0,
          ),
        ),
        
        AppTextField(
          hintText: 'Username',
        ),

        AppTextField(
          hintText: 'Password',
          obscureText: true,
        ),

        FlatButton(
          onPressed: (){},
          textColor: AppColors.black,
          child: Text('Forgot Password'),
        ),

        AppButton(labelText: 'Log In', buttonType: ButtonType.LightBlue),

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