import 'package:cokg/src/resources/widgets/textfield.dart';
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
        AppTextField(
          hintText: 'Username',
          materialIcon: Icons.supervised_user_circle,
        )
      ],
    );
  }
}