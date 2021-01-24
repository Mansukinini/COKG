import 'package:cokg/src/areas/screens/Sign-up.dart';
import 'package:cokg/src/areas/screens/event-detail.dart';
import 'package:cokg/src/areas/screens/login.dart';
import 'package:flutter/material.dart';


abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings route) {
    switch (route.name) {
      case "/signup":
      return MaterialPageRoute(builder: (context) => Signup());
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/eventDetail":
        return MaterialPageRoute(builder: (context) => EventDetail());
      default:
        // var routeArray = route.name.split("/");
    
        // if (route.name.contains("/eventDetail/")){
        //   return MaterialPageRoute(
        //     builder: (context) => EventDetail(id: routeArray[2]));
        // }
    }
    
    return MaterialPageRoute(builder: (context) => Login());
  }
}