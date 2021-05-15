import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/services/providers/userProvider.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/file-upload.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String id;
  Profile({this.id});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
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

  Widget _pageBody(BuildContext context, UserProvider userProvider, UserAuth user) {

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
              initialText: (user != null) ? user.firstName.toString() : null,
              onChanged: userProvider.setFirstName,
              errorText: snapshot.error,
            );
          }
        ),

        StreamBuilder<String>(
          stream: userProvider.getLastName,
          builder: (context, snapshot) {
            
            return AppTextField(labelText: 'Surname',
              initialText: (user != null) ? user.lastName.toString() : null,
              onChanged: userProvider.setLastName,
              errorText: snapshot.error,
            );
          }
        ),

        StreamBuilder<String>(
          stream: userProvider.getContactNo,
          builder: (context, snapshot) {

            return AppTextField(labelText: 'Mobile',
              initialText: user != null ? user.contactNo : null,
              onChanged: userProvider.setContactNo,
            );
          }
        ),

        StreamBuilder<String>(
          stream: userProvider.getEmail,
          builder: (context, snapshot) {

            return AppTextField(labelText: 'Email',
              initialText: (user != null) ? user.email.toString() : null,
              onChanged: userProvider.setEmail,
            );
          }
        ),

        AppButton(labelText: 'Save', onPressed: () {
          userProvider.save().then((value) {
            if (value == null) {
              Navigator.pushNamed(context, '/home');
            }
          });
        })
      ],
    );
  }

  void loadData(UserProvider userProvider, UserAuth user) {
    if (user != null) {
      userProvider.setFirstName(user.firstName);
      userProvider.setLastName(user.lastName);
      userProvider.setEmail(user.email);
    }
  }
}