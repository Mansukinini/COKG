import 'package:cokg/src/areas/screens/Sign-up.dart';
import 'package:cokg/src/areas/screens/event-detail.dart';
import 'package:cokg/src/areas/screens/event-list.dart';
import 'package:cokg/src/areas/screens/home.dart';
import 'package:cokg/src/areas/screens/login.dart';
import 'package:cokg/src/areas/screens/profile.dart';
import 'package:flutter/material.dart';


abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings route) {
    switch (route.name) {
      case "/home":
        return MaterialPageRoute(builder: (context) => Home());
      case "/eventList":
        return MaterialPageRoute(builder: (context) => EventList());
      case "/signup":
      return MaterialPageRoute(builder: (context) => Signup());
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/eventDetail":
        return MaterialPageRoute(builder: (context) => EventDetail());
      default:
        var routeArray = route.name.split("/");
        if (route.name.contains("/profile/")) {
          return MaterialPageRoute(
            builder: (context) => Profile(userId: routeArray[2]));
        }
    }
    
    return MaterialPageRoute(builder: (context) => Login());
  }
}