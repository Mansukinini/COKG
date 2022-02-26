import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokg/src/areas/models/user.dart';
import 'package:cokg/src/areas/screens/event/event-list.dart';
import 'package:cokg/src/areas/screens/event/event-title.dart';
import 'package:cokg/src/areas/screens/home/drawer/about.dart';
import 'package:cokg/src/areas/screens/home/drawer/editProfile.dart';
import 'package:cokg/src/areas/screens/home/drawer/search.dart';
import 'package:cokg/src/areas/screens/home/drawer/vision.dart';
import 'package:cokg/src/areas/screens/home/home.dart';
import 'package:cokg/src/resources/utils/progress.dart';
import 'package:cokg/src/resources/widgets/header.dart';
import 'package:cokg/src/styles/color.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class Profile extends StatefulWidget {
  final String id;
  Profile({this.id});
  
  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String currentUserId = currentUser?.id; 
  String postOrientation = "grid";
  bool isLoading = false;
  bool isFollowing = false; 
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;
  List<EventList> eventLists = [];

  @override
  void initState() {
    super.initState();
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot = await eventRef.doc(widget.id).collection('userEvents').get();
    
    setState(() {
      isLoading = false;
      postCount = snapshot.size;
      eventLists = snapshot.docs.map((doc) => EventList.fromDocument(doc)).toList();
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef.doc(widget.id).collection('userFollowers').get();
    
    setState(() {
      followersCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef.doc(widget.id).collection('userFollowing').get();

    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef.doc(widget.id).collection('userFollowers').doc(currentUserId).get();

    setState(() {
      isFollowing = doc.exists;
    });
  }

  Widget build(BuildContext context) {
    // Viewing your own profile would show edit profile button
    bool isProfileOwner = currentUserId != widget.id;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      endDrawer: drawer(context),
      appBar: header(context, titleText: "Profile", removeNackButton: !isProfileOwner),

      body: ListView(
        children: <Widget>[
          buildProfileHeader(context),
          Divider(),
          buildTogglePostOrientation(),
          Divider(height: 0.0),
          buildProfilePosts()
        ],
      ),
    );
  }

  Widget drawer(BuildContext context) { 
    
    return Drawer(
      child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        
        UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundColor: AppColors.lightgray,
            backgroundImage: (currentUser != null && currentUser.photoUrl != null) ? 
            CachedNetworkImageProvider(currentUser.photoUrl) : AssetImage('assets/images/user.jpg'),
          ),

          accountName: (currentUser != null && currentUser.displayName != null) ? Text(currentUser.displayName) : null,
          accountEmail: (currentUser != null && currentUser.email != null) 
          ? Text(currentUser.email) 
          : Text('Log In or Sign Up', style: TextStyles.body),
          
          onDetailsPressed: (currentUser != null && currentUser.id != null) 
          ? () => Navigator.of(context).pushNamed("/profile/" + currentUser.id) 
          : () => Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(id: currentUser.id))),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.brown[500].withOpacity(0.9),
                Colors.amber[50]
              ],
              begin: const FractionalOffset(0.0, 0.4),
              end: Alignment.topRight,
            )
          ),
        ),
        
        ListTile(
          title: Text('ChristOurKing Global', textAlign: TextAlign.left, style: TextStyles.buttonTextBlack),
          leading: Icon(Icons.public_rounded, size: 30.0, color: Colors.black),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Vision())),
        ),

        Divider(height: 0.0,),
      
        ListTile(
          title: Text('About', textAlign: TextAlign.left, style: TextStyles.buttonTextBlack),
          leading: Icon(Icons.info_outline, size: 30.0, color: Colors.black),
          onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => About())),
        ),
        
        Divider(height: 0.0,),

        ListTile(
          title: Text('Sign Out', textAlign: TextAlign.left, style: TextStyles.buttonTextBlack),
          leading: Icon(Icons.logout_rounded, size: 30.0, color: Colors.black),
          onTap: () {
            logout();
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          },
        ),

        Divider(height: 0.0,),
        // SizedBox(height: MediaQuery.of(context).size.height * .12),

        // Padding(
        //   padding: const EdgeInsets.only(top:12.0, left: 10.0, right: 25.0, bottom: 15.0),
        //   child: Text('Version 0.0.1', textAlign: TextAlign.right, style: TextStyle(fontSize: 13.0)),
        // )
      ]),
    );
  }

  logout() async {
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  buildProfileHeader(BuildContext context) {
  
    return FutureBuilder(
      future: userRef.doc(widget.id).get(),
      builder: (context, userData) {

        if (!userData.hasData) {
          return circularProgress();
        }

        AuthUser user = AuthUser.fromDocument(userData.data);

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[

              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: (user != null && user.photoUrl != null) ? CachedNetworkImageProvider(user.photoUrl) : AssetImage('assets/images/user.jpg'),
                  ),

                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildCountColumn('Posts', postCount),
                            
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Search())),
                              child: buildCountColumn('Members', followersCount),
                            ),
                            buildCountColumn('following', followingCount),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[buildProfileButton()],
                        )
                      ],
                    ) 
                  )
                ],
              ),
              
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12.0),
                child: Text(user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              ), 

              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 4.0),
                child: Text(user.displayName, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          )
        );
      }
    );
  } 

  buildTogglePostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(onPressed: () => setPostOrientation("grid"), icon: Icon(Icons.grid_on), color: postOrientation == "grid" ? Colors.brown[300] : Colors.grey),
        IconButton(onPressed: () => setPostOrientation("list"), icon: Icon(Icons.list), color: postOrientation == "list" ? Colors.brown[300] : Colors.grey),
      ],
    );
  }

  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }

  buildProfileButton() {

    // Viewing your own profile would show edit profile button
    bool isProfileOwner = currentUserId != widget.id;

    if (!isProfileOwner) {
      return buildButton(text: "Edit Profile", function: editProfile );
    } else if (isFollowing) {
      return buildButton(text: "Unfollow", function: handleUnfollowUser);
    } else if (!isFollowing) {
      return buildButton(text: "Follow", function: handleFollowUser);
    }
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });

    // Remove the follower
    followersRef.doc(widget.id).collection('userFollowers').doc(currentUserId).get()
    .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    }); 

    // Remove following
    followingRef.doc(currentUserId).collection('userFollowing').doc(widget.id).get()
    .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    }); 

    // Delete activity feed for them
    activityFeedRef.doc(widget.id).collection('feedItems').doc(currentUserId).get()
    .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });

    // Make auth user follower of THAT user (update THEIR follower collection)
    followersRef.doc(widget.id).collection('userFollowers').doc(currentUserId).set({}); 

    // Put THAT user on Your following collection (update your following collection)
    followingRef.doc(currentUserId).collection('userFollowing').doc(widget.id).set({}); 

    // Add activity feed item for user to notify about new follower (us)
    activityFeedRef.doc(widget.id).collection('feedItems').doc(currentUserId)
    .set({
      "userId": currentUserId,
      "postId": null,
      "username": currentUser.username,
      "userProfileImg": currentUser.photoUrl,
      "type": "follow",
      "mediaUrl": null,
      "createdOn": timestamp,
    });
  }

  Container buildButton({ String text, Function function}) {
    
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: TextButton(onPressed: function, 
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 27.0,
          child: Text(text, style: TextStyle(color: isFollowing ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing ? Colors.white : Colors.brown,
            border: Border.all(color: isFollowing ? Colors.grey : Colors.brown),
            borderRadius: BorderRadius.circular(5.0),
          ),
        )
      )
    );
  }

  editProfile() {
    Navigator.push(context, MaterialPageRoute(builder:(context) => EditProfile(currentUserId: widget.id)));
  }

  Column buildCountColumn(String label, int count) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Text(count.toString(), style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
      
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(label, style: TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.w400)),
        )
      ],
    );
  }

  buildProfilePosts() {

    if (isLoading) {
      return circularProgress();
    } 
    else 
    if (eventLists.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/no_content.svg', height: 260),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("No Posts", style: TextStyle(color: Colors.redAccent, fontSize: 40.0, fontWeight: FontWeight.bold))
            )
          ],
        ),
      );
    } else 
    if (postOrientation == "grid") {

      List<GridTile> gridTitles = [];
      eventLists.forEach((event) {
        gridTitles.add(GridTile(child: EventTitle(event)));
      });

      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTitles,
      );
    } else 
    if (postOrientation == "list") {
      return Column(children: eventLists);
    }
  }
}