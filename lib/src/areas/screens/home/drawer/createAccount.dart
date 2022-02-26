import 'dart:async';

import 'package:cokg/src/resources/widgets/header.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  String username;
  String password;

  submit() {
    final form = _formKey.currentState;
    
    if (form.validate()) {
      form.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome $username')),
      );

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);    
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: header(context, titleText: "Set up your profile", removeNackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text("Create a username", style: TextStyle(fontSize: 25.0),),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 12.0, left: 12.0),
                  child: Container(
                    child: Form(
                      autovalidateMode: AutovalidateMode.always, key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (val) {
                              if (val.trim().length < 3 || val.isEmpty) {
                                return 'Username too short';
                              } else if(val.trim().length > 12) {
                                return "Username too long";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => username = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Username",
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText: "Must be at least 3 characters",
                            ),
                          ),
                          
                          TextFormField(
                            validator: (val) {
                              if (val.trim().length < 3 || val.isEmpty) {
                                return 'Username too short';
                              } else if(val.trim().length > 12) {
                                return "Username too long";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => password = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password",
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText: "Must be at least 3 characters",
                            ),
                          ),
                        ],
                      ), 
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(7.0)),
                    child: Center(child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}