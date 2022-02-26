import 'package:flutter/material.dart';

class Giving extends StatefulWidget {
  @override
  _GivingState createState() => _GivingState();
}

class _GivingState extends State<Giving> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white, onPressed: () => Navigator.pop(context))
      ),
      body: _pageBody(),
    );
  }

  Widget _pageBody() {
  
    return Container(
      child: Center(child: Text('Empty')),
    );
  }
}