import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/Event.dart';


class EventDetail extends StatefulWidget {
  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Event event;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  
 
  FirebaseFirestore storage = FirebaseFirestore.instance;
  List<AssetImage> listOfImage;
  bool clicked = false;
  List<String> listOfStr = List();
  String images;
  bool isLoading = false;

  
  void initState() {
    super.initState();
    // getImages();
  }

  void getImages() {
    listOfImage = List();
    for (int i = 0; i < 3; i++) {
      listOfImage.add(AssetImage('assests/images/Image' + i.toString() + '.jpeg'));
    }
    print('$listOfImage');
  }

  // Future getImage() async {
  //   var image = await ImagePicker().getImage(source: ImageSource.gallery);

  //   setState(() {
  //     _image = image as File;
  //   });
  // }

  Future uploadImageToFirebase() async {
    // File path = File('assests/images/Image0.jpeg');
    // File path = File(_image.path);
    // String fileName = basename(_image.path);
    // firebase_storage.Reference firestoreRef = firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    // firebase_storage.UploadTask uploadTask = firestoreRef.putFile(_image);
    // firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => print('Done'));
  }
  
  @override
  Widget build(BuildContext context)  {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Add Event"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: (){save(context);},
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0,),
        child: ListView(children: <Widget>[ Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assests/images/Image0.jpeg'),
                    child: ClipOval(
                      child: new SizedBox(width: 180.0, height: 180.0,),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:60.0),
                  child: IconButton(icon: Icon(Icons.add_a_photo), iconSize: 30.0,
                  onPressed: (){
                    // getImage();
                    uploadImageToFirebase();
                  },
                  ),
                )
              ],
            ),
            
            TextField(
              controller: nameController,
              style: textStyle,
              onChanged: null,
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: textStyle,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0), 
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: null,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
            )
            
          ],)
          ],
        ),
      ),
    );
  }

  // void select(String value) {
  //   switch (value) {
  //     case menuSave:
  //       save();
  //       break;
  //     default:
  //   }
  // }

  void save(BuildContext context) {
    storage.collection('event').add({
      "name": nameController.text,
      "description": descriptionController.text
    }).then((value) {
      Navigator.pop(context);
    });
  }
}