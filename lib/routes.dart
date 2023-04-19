import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papprototype/Pages/Calendar.dart';

import 'notification_page.dart';

class Routes {
  final FirebaseAuth auth;
  Routes({required this.auth}); 
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/home': (BuildContext context) => CalendarPage(auth: FirebaseAuth.instance),
    '/notification': (BuildContext context) => const NotificationPage(),
  };

  static String initial = '/home';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
}
