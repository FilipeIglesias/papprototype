import 'package:flutter/material.dart';
import 'package:papprototype/services/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
        body: Center(
          child: TextButton(
      onPressed: null,
      child: Text(
          "Add User",
      ),
    ),
        ));
  }

  /*void addUser() {
    
final user = <String, dynamic>{
  "first": "Ada",
  "last": "Lovelace",
  "born": 1815
};

// Add a new document with a generated ID

FirebaseFirestore.instance.collection("aaa").add(user).then((DocumentReference doc) =>
    print('DocumentSnapshot added with ID: ${doc.id}'));
  }*/
}


