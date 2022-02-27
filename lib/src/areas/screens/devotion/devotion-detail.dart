import 'dart:async';
import 'dart:io';

import 'package:cokg/src/areas/models/firebase-file.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/areas/services/data/firebase-storage.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class DevotionDetail extends StatefulWidget {
 final String id;
 DevotionDetail({ this.id });
  @override
  _DevotionDetailState createState() => _DevotionDetailState();
}

class _DevotionDetailState extends State<DevotionDetail> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController;
  TextEditingController descriptionController;
  String name;
  String description;
  Future<List<FirebaseFile>> fileList;
  bool isEdit = false;
  User user;
  var uuid = Uuid().v4();
  String medialUrl;
  bool isUploading = true;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 25.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
        title: Center(child: Text("Devation", style: TextStyles.navTitle)),
        actions: <Widget>[

          widget.id != null && isUploading ? IconButton(onPressed: handleUploadAudio, icon: Icon(Icons.cloud_upload_outlined), iconSize: 25.0) : Text(''),
          !isUploading ? IconButton(onPressed: submit, icon: Icon(Icons.check), iconSize: 25.0) : Text(''),

        ]
      ),

      body: Form(
        autovalidateMode: AutovalidateMode.always, key: _formKey,
        child: widget.id != null ?  buildDevotionalSeries() : buildDevotionBucket(),
      )
    );
  }

  Column buildDevotionalSeries() {
    
    return Column(
      children: <Widget>[
        isUploading ? linearProgress() : Text(''),
        Padding(
          padding: EdgeInsets.only(top: 25.0),
          child: Center(child: Text("Enter Devotional title", style: TextStyle(fontSize: 25.0))),
        ),

        Container(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            validator: (val) {
              if (val.trim().length < 3 || val.isEmpty) {
                return 'Title too short';
              } else if(val.trim().length > 23) {
                return "Title too long";
              } else {
                return null;
              }
            },
            onSaved: (val) => name = val,
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Title",
              labelStyle: TextStyle(fontSize: 15.0),
              hintText: "Must be at least 3 characters",
            ),
          ),
        ),
        
        // SizedBox(height: 10.0),
        // GestureDetector(
        //   onTap: handleUploadAudio,
        //   child: Container(
        //     padding: const EdgeInsets.only(top: 10.0, right: 12.0, left: 12.0),
        //     height: 50.0,
        //     width: 350.0,
        //     decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(7.0)),
        //     child: Center(child: Text("Upload Audio", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
        //   ),
        // ),
      ],
    );
  }

  handleUploadAudio() async{
    FilePickerResult filePicker = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (filePicker != null) {
      setState(() {
          isUploading = true;
        });
      File file = File(filePicker.files.single.path);
      medialUrl = await FirebaseStorageService.uploadAudio(file, uuid);

      if (medialUrl != null) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  Column buildDevotionBucket() {

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 25.0),
          child: Center(child: Text("Create a Devotion bucket", style: TextStyle(fontSize: 25.0))),
        ),

        Container(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            validator: (val) {
              if (val.trim().length < 3 || val.isEmpty) {
                return 'Title too short';
              } else if(val.trim().length > 23) {
                return "Title too long";
              } else {
                return null;
              }
            },
            onSaved: (val) => name = val,
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Title",
              labelStyle: TextStyle(fontSize: 15.0),
              hintText: "Must be at least 3 characters",
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            validator: (val) {
              if (val.trim().length < 3 || val.isEmpty) {
                return 'Title too short';
              } else if(val.trim().length > 23) {
                return "Title too long";
              } else {
                return null;
              }
            },
            onSaved: (val) => description = val,
            controller: descriptionController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Description",
              labelStyle: TextStyle(fontSize: 15.0),
              hintMaxLines: 2,
            ),
          ),
        ),
        
        // SizedBox(height: 10.0),

        // GestureDetector(
        //   onTap: submit,
        //   child: Container(
        //     padding: const EdgeInsets.only(top: 10.0, right: 12.0, left: 12.0),
        //     height: 50.0,
        //     width: 350.0,
        //     decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(7.0)),
        //     child: Center(child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
        //   ),
        // ),
      ],
    );
  }

  submit() {
    final form =_formKey.currentState;
    
    // create devotion bucket
    if (form.validate() && widget.id == null) {
      devotionRef.doc(uuid)
        .set({
          "id": uuid,
          "title": titleController.text,
          "description": descriptionController.text,
          "ordinal": null,
          "createdOn": timestamp
        });

        setState(() {
          uuid = Uuid().v4();
        });

      form.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Devotion ${titleController.text} Created')),
      );

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);    
      });
    }

    // Create devotional series
    if (form.validate() && widget.id != null) {
      devotionRef.doc(widget.id).collection('devotionalSeries')
      .add({
          "id": uuid,
          "title": titleController.text,
          "mediaUrl": medialUrl,
          "ordinal": null,
          "createdBy": currentUser.id,
          "createdOn": timestamp
        });

        setState(() {
          uuid = Uuid().v4();
        });

      form.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Devotion ${titleController.text} Created')),
      );

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);    
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }
}