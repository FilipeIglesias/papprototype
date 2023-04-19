import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:papprototype/ui/view_models/app_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class TaskInfoView extends StatelessWidget {
  final FirebaseAuth auth;
  final currentuid = FirebaseAuth.instance.currentUser!.uid;
  TaskInfoView({super.key, required this.auth});

  Future<int> numTasks() async {
  int numTasks;
  try {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('reminders')
            .where('uid', isEqualTo: currentuid)
            .get();

    numTasks = snapshot.size;
    return numTasks;
  } catch (e) {
    print('Error getting snapshot count: $e');
    return 0;
  }
}

Stream<int> numTasksStream() {
  return FirebaseFirestore.instance
      .collection('reminders')
      .where('uid', isEqualTo: currentuid)
      .snapshots()
      .map((snapshot) => snapshot.size);
}

Stream<int> numTasksRemainingStream() {
  return FirebaseFirestore.instance
      .collection('reminders')
      .where('uid', isEqualTo: currentuid)
      .snapshots()
      .map((snapshot) {
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        snapshot.docs;
    final int numRemaining =
        documents.where((doc) => doc['completed'] == false).length;
    return numRemaining;
  });
}

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(builder: (context, viewModel, child) {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          children: [
            //Total Tasks
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: viewModel.clrvl2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: StreamBuilder<int?>(
                          stream: numTasksStream(),
                          builder: (BuildContext context,
                              AsyncSnapshot<int?> snapshot) {
                            if (snapshot.hasData) {
                              return FittedBox(
                                child: Text(
                                  "${snapshot.data}",
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: viewModel.clrvl3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: FittedBox(
                              child: Text(
                            "Total Tasks",
                            style: TextStyle(
                                color: viewModel.clrvl4,
                                fontWeight: FontWeight.w600),
                          ))),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            //Remaining
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: viewModel.clrvl2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: StreamBuilder<int?>(
                          stream: numTasksRemainingStream(),
                          builder: (BuildContext context,
                              AsyncSnapshot<int?> snapshot) {
                            if (snapshot.hasData) {
                              return FittedBox(
                                child: Text(
                                  "${snapshot.data}",
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: viewModel.clrvl3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: FittedBox(
                              child: Text(
                            "Remaining",
                            style: TextStyle(
                                color: viewModel.clrvl4,
                                fontWeight: FontWeight.w600),
                          ))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
