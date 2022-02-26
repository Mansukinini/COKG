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

          // (isEdit) ? 
          // IconButton(icon: Icon(Icons.check), iconSize: 25.0, color: Colors.white, 
          //   onPressed: () async {
          //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Adding devotion ...')));

          //     await devotionProvider.saveDevotion().then((value) => Navigator.pop(context));
          //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Devotion Added'), backgroundColor: Colors.green));
          //   }
          // ) : Container(),

          // (user != null && user.email == Config.admin) ? 
          //   !(isEdit) ? popupMenuButton(context) : Container() : Container(),
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


  // Scaffold _scafford(BuildContext context, DevotionRepositry devotionProvider, AsyncSnapshot<Devotion> devotion) {
  //   var action = devotion.data != null ? (isEdit) ? "Edit Devotion" : "" : "Add Devotion";
    
  //   // devotionProvider.setDevotion(devotion.data, widget.id);

  //   return Scaffold(
  //     appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 25.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
  //       title: Center(child: Text(action, style: TextStyles.navTitle)),
  //         actions: <Widget>[
  //           (isEdit) ? 
  //             IconButton(icon: Icon(Icons.check), iconSize: 25.0, color: Colors.white, 
  //             onPressed: () async {
  //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Adding devotion ...')));

  //             await devotionProvider.saveDevotion().then((value) => Navigator.pop(context));
  //             ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Devotion Added'), backgroundColor: Colors.green));
  //           }) : Container(),

  //           (user != null && user.email == Config.admin) ? 
  //             !(isEdit) ? popupMenuButton(context) : Container() : Container(),
  //         ]
  //       ),

  //     body: _pageBody(context, devotionProvider, devotion.data),
  //   );
  // }

  // PopupMenuButton popupMenuButton(BuildContext context) {
  //   return PopupMenuButton<String>(
  //     itemBuilder: (context) {
  //       return Config.menuList.map((e) => PopupMenuItem<String>(value: e, child: Text(e),)).toList();
  //     },
  //     onSelected: _itemSelected,
  //   );
  // }

  // void _itemSelected(String item) {
    
  //   if (item == Config.edit) {
  //     setState(() => isEdit = true);
  //   } else
  //   if(item == Config.delete) {
  //     // devotionProvider.deleteDevotion(widget.id).then((value) => Navigator.pop(context));
  //   }
  // }
    
  // Widget _pageBody(BuildContext context, DevotionRepositry devotionRepositry, Devotion devotion) {
    
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         StreamBuilder<String>(
  //           stream: devotionRepositry.getTitle,
  //           builder: (context, snapshots) {

  //             return AppTextField(labelText: "Title",
  //               readOnly: !isEdit,
  //               initialText: (devotion != null && devotion.title != null) ? devotion.title : null,
  //               onChanged: devotionRepositry.setTitle,
  //             );
  //           }
  //         ),

  //         StreamBuilder<String>(
  //           stream: devotionRepositry.getDescription,
  //           builder: (context, snapshot) {

  //             return AppTextField(labelText: "Description",
  //               maxLines: 2,
  //               readOnly: !isEdit,
  //               onChanged: devotionRepositry.setDescription,
  //               initialText: (devotion != null && devotion.description != null) ? devotion.description : null
  //             );
  //           }
  //         ),

  //         StreamBuilder<String>(
  //           stream: devotionRepositry.getUrl,
  //           builder: (context, snapshot) {
              
  //             // if (!snapshot.hasData || snapshot.data == "") {
  //             //   return AppButton(
  //             //     labelText: "Upload Audio", 
  //             //     onPressed: () {
  //             //       devotionRepositry.uploadFile().then((value) {
  //             //         ScaffoldMessenger.of(context).showSnackBar(ShowSnabar.loadingSnackBar('Uploading...'));
  //             //       });
  //             //     }
  //             //   );
  //             // }
              
  //             return Column(
  //               children: <Widget>[
  //                 SizedBox(height: 30.0),

  //                 (snapshot.hasData) ? FutureBuilder<List<FirebaseFile>>(
  //                   future: fileList,
  //                   builder: (context, snapshot) {

  //                     return AppButton(labelText: 'Download',
  //                       onPressed: () async {
  //                         // await FirebaseStorageService.downloadAudioFromUrl(snapshot.data.first.ref);
  //                         // Todo: pass the file reference
  //                         await FirebaseStorageService.downloadFile(snapshot.data.first.ref, context);
  //                       },
  //                     );
  //                   }
  //                 ) : Container(),
  //               ],
  //             );
  //           }
  //         ),
  //       ],
  //     ),
  //   );
  // }
}