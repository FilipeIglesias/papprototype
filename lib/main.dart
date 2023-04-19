import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:papprototype/Pages/Account.dart';
import 'package:papprototype/Pages/Calendar.dart';
import 'package:papprototype/Pages/Reminders.dart';
import 'package:papprototype/services/firebase_messaging_services.dart';
import 'package:papprototype/services/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:papprototype/ui/view_models/app_view_model.dart';
import 'package:provider/provider.dart';
import 'Pages/login_page.dart';
import 'Pages/sign_up_page.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationService>(
          create: (context) => NotificationService(),
        ),
        Provider<FirebaseMessagingService>(
          create: (context) => FirebaseMessagingService(
            context.read<NotificationService>(),
          ),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => AppViewModel(),
        child: const MyApp(),
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationBar(),
    );*/
  }
}
