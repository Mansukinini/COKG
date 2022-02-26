import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/areas/screens/timeline.dart';
import 'package:cokg/src/config.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:flutter/material.dart';


class EditProfile extends StatefulWidget {
 final String currentUserId;
 EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scafforldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  bool _displayNameValid = true;
  bool isLoading = false;
  AuthUser user;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });

    DocumentSnapshot doc = await userRef.doc(widget.currentUserId).get();

    user = AuthUser.fromFirestore(doc.data());
    displayNameController.text = user.displayName;
    usernameController.text = user.username;
    aboutController.text = user.bio;
    phoneController.text = user.contactNo;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scafforldKey,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        leading: Config.admin == currentUser.email ? 
        IconButton(
          icon: Icon(Icons.arrow_back), iconSize: 25.0, color: Colors.white,
          onPressed: () { 
            updateProfileData();
            Navigator.push(context, MaterialPageRoute(builder: (context) => Timeline(currentUser)));
          }
        ) : null,
        title: Center(child: Text("Edit Profile", style: TextStyle(color: Colors.white))),
        actions: <Widget>[
          IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.done, size: 30.0, color: Colors.green))
        ],
      ),
      body: isLoading ? circularProgress() : 
        ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 16.0, bottom: 5.0),
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: (user != null && user.photoUrl != null) ? CachedNetworkImageProvider(user.photoUrl) : AssetImage('assets/images/user.jpg'),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Column(
                     children: <Widget>[
                        buildDisplayNameField(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }

  Column buildDisplayNameField() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Display Name", style: TextStyle(color: Colors.grey)
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Display Name",
            // errorText: _displayNameValid ? null : "Display Name too short"
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Username", style: TextStyle(color: Colors.grey)
          ),
        ),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "Username",
            // errorText: _displayNameValid ? null : "Display Name too short"
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("About", style: TextStyle(color: Colors.grey)
          ),
        ),
        TextField(
          controller: aboutController,
          decoration: InputDecoration(
            hintText: "About",
            // errorText: _displayNameValid ? null : "Display Name too short"
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Phone", style: TextStyle(color: Colors.grey)
          ),
        ),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            hintText: "Phone",
            // errorText: _displayNameValid ? null : "Display Name too short"
          ),
        ),

      ],
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length > 3 || displayNameController.text.isEmpty ? 
      _displayNameValid = false : _displayNameValid = true;
    });

    if (_displayNameValid) {
      userRef.doc(widget.currentUserId).update({});
      SnackBar snackBar = SnackBar(content: Text("Profile Updated!"));
      // ignore: deprecated_member_use
      _scafforldKey.currentState.showSnackBar(snackBar);
    }
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }
}