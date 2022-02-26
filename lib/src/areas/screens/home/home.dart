import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/screens/devotion/devotion-list.dart';
import 'package:cokg/src/areas/screens/home/drawer/activity-feed.dart';
import 'package:cokg/src/areas/screens/home/drawer/createAccount.dart';
import 'package:cokg/src/areas/screens/home/drawer/profile.dart';
import 'package:cokg/src/areas/screens/timeline.dart';
import 'package:cokg/src/areas/screens/video/video.dart';
import 'package:cokg/src/areas/services/providers/authentication.dart';
import 'package:cokg/src/resources/utils/floatingActionButton.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../config.dart';


final storageRef = FirebaseStorage.instance.ref();
final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final userRef = FirebaseFirestore.instance.collection('users');
final eventRef = FirebaseFirestore.instance.collection('event');
final commetsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final devotionRef = FirebaseFirestore.instance.collection('devotions');
final DateTime timestamp = DateTime.now();
AuthUser currentUser;
User authUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isAuth = false;
  PageController pageController;
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;
  String password;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    // Detecte when user sign in
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
    }, onError: (err) {
      // print('Error signing in: $err');
    });
    
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false)
      .then((account) {
        handleSignIn(account);
      }).catchError((err) {
        // print('Error signing in: $err');
      });
  }

  handleSignIn(GoogleSignInAccount account) async{
    if (account != null) {
      await createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    
    // 1) check if the user exists in users collection in database (according tp their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;

    if(user != null) {
      DocumentSnapshot doc = await userRef.doc(user.id).get();
      // 2) If the user doesn't exists, then we want to take them to the create account page
      if (!doc.exists) {
        final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
        
        // 3) get username from create account, use it to make new user document in users collection
        userRef.doc(user.id).set({
          "id": user.id ?? authUser.uid,
          "username": username,
          "displayName": user.displayName ?? authUser.displayName,
          "photoUrl": user.photoUrl ?? authUser.photoURL,
          "email": user.email ?? authUser.email,
          "isActive": true,
          "bio": null, 
          "contactNo": authUser.phoneNumber ?? null,
          "createdBy": null,
          "createdOn": timestamp,
        });

        // Make new user their own follower (to include their post in their timeline)
        await followersRef.doc(user.id).collection('userFollowers').doc(user.id).set({});
        
        doc = await userRef.doc(user.id).get();
      }
      
      currentUser = AuthUser.fromDocument(doc);
    }
  }

  signInWithGoogle() async {
   
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        
        authUser = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          scaffoldMessenger(context, 'The account already exists with a different credential.');
        }
        else if (e.code == 'invalid-credential') {
          scaffoldMessenger(context, 'Error occurrer while accessing credential. Try again');
        }
      } catch (e) {
        scaffoldMessenger(context, 'Error occurred using Google Sign In. Try again.');
      }
    }
  }

  scaffoldMessenger(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content))
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }

  Scaffold buildAuthScreen() {
    
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(currentUser),
          ActivityFeed(),
          DevotionList(),
          Video(),
          // Config.admin != currentUser.email ?
          // EditProfile(currentUserId: currentUser?.id) :
          Profile(id: currentUser?.id)
        ],
        controller: pageController, 
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),

      floatingActionButton: (currentUser != null && currentUser.email == Config.admin) ? AppFloatingActionButton(tapNo: pageIndex) : null,
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Scaffold buildUnAuthScreen() {

    return Scaffold(

      body: ListView(
        children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only(left:14.0),
                    child: Text("Sign In", style: TextStyles.blackTitle),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('New User?', style: TextStyles.suggestion),
                        TextButton(
                          child: Text('Create an account', style: TextStyle(fontSize: 16.0)),
                          style: TextButton.styleFrom(primary: Colors.brown),
                          onPressed: () async {
                            final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
                            // print(username);
                          },
                        )
                      ]
                    ),
                  )
                ]
              ),
            ),

            Padding(
              padding: EdgeInsets.all(14.0),
              child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
                        ),
                        validator: (email) => handleUsernameValidation(email),
                        onSaved: (email) => username = email,
                        controller: usernameController,
                      ),
                      SizedBox(height: 10.0,),

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
                        ),
                        validator: (val) => handlePasswordValidation(val),
                        onSaved: (password) => password = password,
                        controller: passwordController,
                        obscureText: true,
                      ),
                    ],
                )
              ),
            ),

            AppButton(
              icon: FaIcon(FontAwesomeIcons.signInAlt, color: Colors.white),
              labelText: "Submit",
              isAnimatedButton: false, 
              onPressed: submit,
            ),

            SizedBox(height: 10.0,),

          AppButton(
            icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
            labelText: 'Sign In with Google',
            isAnimatedButton: false, 
            onPressed: signInWithGoogle,
          ),
        ],
      ),
    );
  }

  handleUsernameValidation(val) {
    if (val.trim().length < 3 || val.isEmpty) {
      return 'Username too short';
    } else if(val.trim().length > 29) {
      return "Username too long";
    } else {
      return null;
    }
  }

  handlePasswordValidation(val) {
    if (val.trim().length < 3 || val.isEmpty) {
      return 'Password too short';
    } else if(val.trim().length > 20) {
      return "Password too long";
    } else {
      return null;
    }
  }

  submit() async {
    final form = _formKey.currentState;

    try {
      
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text
      );

      authUser = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        scaffoldMessenger(context,'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        scaffoldMessenger(context,'Wrong password provided for that user.');
      }
    }
    
    if (form.validate()) {

      await createUserInFirestore();
      form.save();
      // SnackBar snackBar = SnackBar(content: Text("Welcome $username"));
      // // ignore: deprecated_member_use
      // _scaffoldKey.currentState.showSnackBar(snackBar);

      // Timer(Duration(seconds: 2), () {
      //   Navigator.pop(context, username);    
      // });
    }
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }
    
  Widget bottomNavigationBar() {
    
    return BottomNavigationBar(
      selectedFontSize: 12.0,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[

        BottomNavigationBarItem(
          icon: Icon(Icons.event_note_rounded),
          label: 'Timeline'
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none_outlined),
          label: 'Notification'
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.record_voice_over),
          label: 'Devotion'
        ),
        
        BottomNavigationBarItem(
          icon: Icon(Icons.live_tv),
          label: 'Live'
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile'
        ),
      ],

      currentIndex: pageIndex,
      selectedItemColor: Colors.yellow[700],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int pageIndex) {
    pageController.jumpToPage(pageIndex);
  }

  PopupMenuButton popupMenuButton(BuildContext context) {

    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return Config.homeBarList.map((e) => PopupMenuItem<String>(value: e, child: Text(e),)).toList();
      },
      onSelected: _itemSelected,
    );
  }

  void _itemSelected(String item) {
    var auth = Provider.of<Authentication>(context, listen: false);

    if (item == Config.signOut) {
      auth.signOut().then((value) => Navigator.pushReplacementNamed(context, '/home'));
    } 
  }

  @override
  void dispose() {
    pageController.dispose();
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}