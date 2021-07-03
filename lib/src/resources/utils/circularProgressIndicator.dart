import 'package:flutter/material.dart';

class ProgressIndicator  {
  static Center circularProgressIndicator() {
    return Center(child: CircularProgressIndicator());
  }
} 

class ShowSnabar {
  static Widget loadingSnackBar(String text) {
    return SnackBar(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(width:20),
          Text(text)
        ],
      )
    );
  }

  static Widget snackBar(String text) {
    return SnackBar(content: Text(text), backgroundColor: Colors.green);
  }

}