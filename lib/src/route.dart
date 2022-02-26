// import 'package:cokg/src/areas/screens/devotion/devotion-detail.dart';
// import 'package:cokg/src/areas/screens/devotion/devotion-sub-page.dart';
// import 'package:cokg/src/areas/screens/event/event-detail.dart';
// import 'package:cokg/src/areas/screens/event/event-list.dart';
// import 'package:cokg/src/areas/screens/group/group-detail.dart';
// import 'package:cokg/src/areas/screens/home/drawer/download.dart';
// import 'package:cokg/src/areas/screens/home/drawer/editProfile.dart';
// import 'package:cokg/src/areas/screens/home/drawer/giving.dart';
// import 'package:cokg/src/areas/screens/home/drawer/inbox.dart';
// import 'package:cokg/src/areas/screens/home/drawer/search.dart';
// import 'package:cokg/src/areas/screens/home/home.dart';
// import 'package:cokg/src/areas/screens/home/drawer/login.dart';
// import 'package:cokg/src/areas/screens/home/drawer/profile.dart';
// import 'package:cokg/src/areas/screens/home/drawer/about.dart';
// import 'package:flutter/material.dart';

// import 'areas/screens/devotion/devotion-preview.dart';
// import 'areas/screens/home/drawer/sign-up.dart';
// import 'areas/screens/home/drawer/vision.dart';


// abstract class Routes {

//   static MaterialPageRoute materialRoutes(RouteSettings route) {

//     switch (route.name) {
//       case "/home":
//         return MaterialPageRoute(builder: (context) => Home());
//       case "/signup":
//         return MaterialPageRoute(builder: (context) => Signup());
//       case "/login":
//         return MaterialPageRoute(builder: (context) => Login());
//       case "/eventList":
//         return MaterialPageRoute(builder: (context) => EventList());
//       case "/eventDetail":
//         return MaterialPageRoute(builder: (context) => EventDetail());
//       case "/groupDetail":
//         return MaterialPageRoute(builder: (context) => GroupDetail());
//       case "/devotionDetail":
//         return MaterialPageRoute(builder: (context) => DevotionDetail());
//       case "/devotionPreview":
//         return MaterialPageRoute(builder: (context) => DevotionPreview());
//       case "/download":
//         return MaterialPageRoute(builder: (context) => Download());
//       case "/inbox":
//         return MaterialPageRoute(builder: (context) => Inbox());
//       case "/giving":
//         return MaterialPageRoute(builder: (context) => Giving());
//       case "/about":
//         return MaterialPageRoute(builder: (context) => About());
//       case "/vision":
//         return MaterialPageRoute(builder: (context) => Vision());
//       case "/search":
//         return MaterialPageRoute(builder: (context) => Search());
      
//       default:
//         var routeArray = route.name.split("/");

//         if (route.name.contains("/profile/")) {
//           return MaterialPageRoute(builder: (context) => Profile(id: routeArray[2]));
//         }
        
//         if (route.name.contains("/editProfile/")) {
//           return MaterialPageRoute(builder: (context) => EditProfile(currentUserId: routeArray[2]));
//         }

//         if (route.name.contains("/eventDetail/")) {
//           return MaterialPageRoute(builder: (context) => EventDetail(id: routeArray[2]));
//         }

//         if (route.name.contains("/groupDetail/")) {
//           return MaterialPageRoute(builder: (context) => GroupDetail(id: routeArray[2]));
//         }
        
//         if (route.name.contains("/devotionSubPage/")) {
//           return MaterialPageRoute(builder: (context) =>  DevotionSubPage(id: routeArray[2]));
//         }

//         if (route.name.contains("/devotionDetail/")) {
//           return MaterialPageRoute(builder: (context) =>  DevotionDetail(id: routeArray[2]));
//         }

//       return MaterialPageRoute(builder: (context) => Login());
//     }
//   }
// }