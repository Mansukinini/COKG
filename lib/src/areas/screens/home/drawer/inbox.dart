import 'package:flutter/material.dart';

class Inbox extends StatefulWidget {
  // const Inbox({ Key? key }) : super(key: key);

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
        
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