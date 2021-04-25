import 'package:cokg/src/areas/screens/Sign-up.dart';
import 'package:cokg/src/areas/screens/devotion/devotion-detail.dart';
import 'package:cokg/src/areas/screens/devotion/devotion-sub-page.dart';
import 'package:cokg/src/areas/screens/event/event-detail.dart';
import 'package:cokg/src/areas/screens/event/event-list.dart';
import 'package:cokg/src/areas/screens/group/group-detail.dart';
import 'package:cokg/src/areas/screens/home.dart';
import 'package:cokg/src/areas/screens/login.dart';
import 'package:cokg/src/areas/screens/profile.dart';
import 'package:flutter/material.dart';


abstract class Routes {

  static MaterialPageRoute materialRoutes(RouteSettings route) {

    switch (route.name) {
      case "/home":
        return MaterialPageRoute(builder: (context) => Home());
      case "/signup":
        return MaterialPageRoute(builder: (context) => Signup());
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/eventList":
        return MaterialPageRoute(builder: (context) => EventList());
      case "/eventDetail":
        return MaterialPageRoute(builder: (context) => EventDetail());
      case "/groupDetail":
        return MaterialPageRoute(builder: (context) => GroupDetail());
      case "/devotionDetail":
        return MaterialPageRoute(builder: (context) => DevotionDetail());
      // case "/devotionSubPage":
      //   return MaterialPageRoute(builder: (context) => DevotionSubPage());
      default:
        var routeArray = route.name.split("/");

        if (route.name.contains("/profile/")) {
          return MaterialPageRoute(
            builder: (context) => Profile(userId: routeArray[2]));
        }

        if (route.name.contains("/eventDetail/")) {
          return MaterialPageRoute(builder: (context) => EventDetail(id: routeArray[2]));
        }

        if (route.name.contains("/devotionSubPage/")) {
          return MaterialPageRoute(builder: (context) =>  DevotionSubPage(id: routeArray[2]));
        }

        if (route.name.contains("/groupDetail/")) {
          return MaterialPageRoute(builder: (context) => GroupDetail(id: routeArray[2]));
        }
        
      return MaterialPageRoute(builder: (context) => Login());
    }
  }
}