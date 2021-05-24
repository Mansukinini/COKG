
import 'package:cokg/src/areas/services/providers/authentication.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

 @override
 void initState() {
  //  final authenticate = Provider.of<AuthenticationBloc>(context, listen: false);
   super.initState();
 }

  @override
  Widget build(BuildContext context) {
    final authenticate = Provider.of<Authentication>(context);

    return Scaffold(body: _pageBody(context, authenticate));
  }

  Widget _pageBody(BuildContext context, Authentication authenticate) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 30.0,),

        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text("Create your Christ Our King Account", style: TextStyles.title),
        ),

        StreamBuilder<String>(
          stream: authenticate.firstName,
          builder: (context, snapshot) {

            return AppTextField(
              hintText: 'Name',
              textInputType: TextInputType.emailAddress,
              onChanged: authenticate.setFirstName,
            );
          }
        ),

        StreamBuilder<String>(
          stream: authenticate.lastName,
          builder: (context, snapshot) {

            return AppTextField(
              hintText: 'Surname',
              textInputType: TextInputType.emailAddress,
              onChanged: authenticate.setLastName,
            );
          }
        ),

        StreamBuilder<String>(
          stream: authenticate.email,
          builder: (context, snapshot) {

            return AppTextField(
              hintText: 'Email',
              textInputType: TextInputType.emailAddress,
              onChanged: authenticate.setEmail,
            );
          }
        ),

        StreamBuilder<String>(
          stream: authenticate.password,
          builder: (context, snapshot) {

            return AppTextField(
              hintText: 'Password',
              obscureText: true,
              onChanged: authenticate.setPassword,
            );
          }
        ),

        StreamBuilder<String>(
          stream: authenticate.confirmPassword,
          builder: (context, snapshot) {

            return AppTextField(
              hintText: 'Confirm - Password',
              obscureText: true,
              onChanged: authenticate.setConfirmPassword,
            );
          }
        ),

        AppButton(
          labelText: 'Sign Up', 
          buttonType: ButtonType.LightBlue,
          onPressed: () { 
            authenticate.signup().then((value) {
              if (value != null && value.email.isNotEmpty) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            });
          },
        ),

        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Already have an account?', style: TextStyles.suggestion),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('Log In', style: TextStyle(fontSize: 20.0)),
                textColor: AppColors.brown,
                onPressed: () => Navigator.pushNamed(context, '/login'),
              )
            ]
          ),
        )
        
      ],
    );
  }
}