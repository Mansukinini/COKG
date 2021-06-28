

import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About ChristOurKing', style: TextStyles.navTitle)),
      body: _pageBody(context),
    );
  }

  Widget _pageBody(BuildContext context) {

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 0),
            child: Text('Version 0.0.1', textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
          ),
          
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Text('Developed by ', textAlign: TextAlign.left, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400)),
                Text('Softcision', textAlign: TextAlign.left, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26)),
      )
    );
  }
}