import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/services/providers/userProvider.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/file-upload.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _auth = FirebaseAuth.instance;

class Profile extends StatefulWidget {
  final String id;
  Profile({this.id});
  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  User user;

  @override
  void initState() {
    user = _auth.currentUser;
    super.initState();
  }

  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    if (widget.id != null) {
      return displayProfileById(userProvider, widget.id);
    } else {
      return displayProfile(userProvider);
    }
  }

  FutureBuilder displayProfileById(UserProvider userProvider, String id) {
    
    return FutureBuilder<UserAuth>(
      future: userProvider.getUserData(id),
      builder: (context, userData) {

        if (!userData.hasData && widget.id != null) 
          return Center(child: CircularProgressIndicator());

        return scaffold(context, userProvider, userData);
      },
    );
  }

  StreamBuilder displayProfile(UserProvider userProvider) {
    
    return StreamBuilder<UserAuth>(
      stream: userProvider.getUserAuth,
      builder: (context, userData) {
        
        return scaffold(context, userProvider, userData);
      },
    );
  }

  Scaffold scaffold(BuildContext context, UserProvider userProvider, AsyncSnapshot<UserAuth> userData) {

    userProvider.setUser(userData.data, widget.id);

    return Scaffold(
      // appBar: AppBar(
      //     leading: IconButton(
      //       icon: Icon(Icons.arrow_back),
      //       iconSize: 30.0,
      //       color: Colors.white,
      //       onPressed: () => Navigator.pop(context),
      //     ),
      //   title: Text("Profile", style: TextStyles.navTitle)
      // ),

      body: _pageBody(context, userProvider, userData.data),
    );
  }

  Widget _pageBody(BuildContext context, UserProvider userProvider, UserAuth userAuth) {

    return ListView(
      children: <Widget>[
        SizedBox(height: 20.0,),

        StreamBuilder<String>(
          stream: userProvider.getImageUrl,
          builder: (context, snapshot) {
            
            return Container(
              height: MediaQuery.of(context).size.height * .25,
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: (snapshot.data != null) ? NetworkImage(snapshot.data) : AssetImage('assets/images/user.jpg'),
                child: FileUpload(icon: Icons.camera_alt, onPressed: userProvider.pickImage),
              ),
            );
          }
        ),
        
        StreamBuilder<String>(
          stream: userProvider.getFirstName,
          builder: (context, snapshot) {
              
            return AppTextField(labelText: 'Name',
              initialText: (userAuth != null) ? userAuth.firstName : null,
              onChanged: userProvider.setFirstName,
              errorText: snapshot.error,
            );
          }
        ),

        StreamBuilder<String>(
          stream: userProvider.getLastName,
          builder: (context, snapshot) {
            
            return AppTextField(labelText: 'Surname',
              initialText: (userAuth != null) ? userAuth.lastName.toString() : null,
              onChanged: userProvider.setLastName,
              errorText: snapshot.error,
            );
          }
        ),

        StreamBuilder<String>(
          stream: userProvider.getContactNo,
          builder: (context, snapshot) {

            return AppTextField(labelText: 'Mobile',
              initialText: userAuth != null ? userAuth.contactNo : null,
              onChanged: userProvider.setContactNo,
            );
          }
        ),

        StreamBuilder<String>(
          stream: userProvider.getEmail,
          builder: (context, snapshot) {

            return AppTextField(labelText: 'Email',
              initialText: (userAuth != null) ? userAuth.email.toString() : null,
              onChanged: userProvider.setEmail,
            );
          }
        ),

        (user.email != null) ? AppButton(labelText: 'Save', onPressed: () {
          userProvider.save().then((value) {
            if (value == null) {
              Navigator.pushNamed(context, '/home');
            }
          });
        }) : Container()
      ],
    );
  }
}