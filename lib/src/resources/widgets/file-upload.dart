import 'package:flutter/material.dart';

class FileUpload extends StatefulWidget {
  final String fileName;
  final void Function() onPressed; 
  final IconData icon;

  FileUpload({this.fileName, @required this.icon, this.onPressed});

  @override
  _FileUploadState createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 120.0, left: 120.0),
      child: MaterialButton(onPressed: widget.onPressed, color: Colors.brown,
        child: Icon(widget.icon, color: Colors.black, size: 24.0,),
        shape: CircleBorder(),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }
} 