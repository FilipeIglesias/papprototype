import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papprototype/ui/add_task_view.dart';
import 'package:papprototype/ui/header_view.dart';
import 'package:papprototype/ui/task_info_view.dart';

import '../ui/task_list_view.dart';

class ReminderPage extends StatelessWidget {
  final FirebaseAuth auth;
  const ReminderPage({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [

            //Header
            Expanded(
                child: HeaderView(),
                flex: 1),

            //Task Info
            Expanded(
                child: TaskInfoView(auth: auth),
                flex: 1),

            //Task List View
            Expanded(
                child: TaskListView(auth: auth),
                flex: 7),
          ],
        ),
      ),
      floatingActionButton: AddTaskView(auth: auth,),
    );
  }
}
