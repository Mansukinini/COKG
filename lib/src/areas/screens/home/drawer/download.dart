import 'package:flutter/material.dart';

class Download extends StatefulWidget {
  // const Download({ Key? key }) : super(key: key);

  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<Download> {

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