import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/task_model.dart';

class AppViewModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentuid = FirebaseAuth.instance.currentUser!.uid;
  List<Task> tasks = <Task>[];

  Color clrvl1 = Colors.grey.shade50;
  Color clrvl2 = Colors.grey.shade200;
  Color clrvl3 = Colors.grey.shade800;
  Color clrvl4 = Colors.grey.shade900;

  Future<List<bool>> getCompletedValues() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference remindersCollection =
        firestore.collection('reminders');

    final querySnapshot = await remindersCollection.get();
    final List<bool> completedValues = [];

    for (final doc in querySnapshot.docs) {
      final completed = doc['completed'] as bool?;
      if (completed != null) {
        completedValues.add(completed);
      }
    }

    return completedValues;
  }

  Future<bool> getTaskValue(int index) async {
    final completedValues = await getCompletedValues();
    return completedValues[index];
  }

  void updateTaskCompletion(String documentId, bool taskValue) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference taskDocument =
        firestore.collection('reminders').doc(documentId);

    taskDocument
        .update({'completed': taskValue})
        .then((value) => print('Task completion updated successfully'))
        .catchError((error) => print('Error updating task completion: $error'));
  }

  void deleteAllTasks() async {
    final QuerySnapshot remindersSnapshot =
        await FirebaseFirestore.instance.collection('reminders').where('uid', isEqualTo: currentuid).get();

    final List<DocumentSnapshot> remindersDocs = remindersSnapshot.docs;

    for (DocumentSnapshot doc in remindersDocs) {
      await doc.reference.delete();
    }
  }

  void deleteCompletedTasks() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('reminders').where('uid', isEqualTo: currentuid).get();
      final docs = snapshot.docs;
      final completedDocs = docs.where((doc) => doc['completed'] == true);

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in completedDocs) {
        final docRef =
            FirebaseFirestore.instance.collection('reminders').doc(doc.id);
        batch.delete(docRef);
      }

      await batch.commit();
    } catch (e) {
      print('Error deleting completed tasks: $e');
    }
  }

  void sendTask(Task newTask) {
    final taskMap = <String, dynamic>{
      "title": newTask.title,
      "completed": false,
      "uid": null,
    };

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection("reminders")
        .add(taskMap)
        .then((DocumentReference doc) {
      doc.update({"id": doc.id});
      doc.update({"uid": currentuid});
      print('DocumentSnapshot added with ID: ${doc.id}');
    }).catchError((error) {
      print('Error adding task: $error');
    });
  }

  void bottomSheetBuilder(Widget bottomSheetView, BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return bottomSheetView;
      },
    );
  }
}

/*void updateCompleted(bool value) async {
  final updateComplete = <String, dynamic>{
    "completed": value,
  };

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var snapshots = firestore.collection('reminders').snapshots();

  if (snapshot.hasData) {
    return ListView.builder(
        itemCount: snapshot.data?.docs.length,
        itemBuilder: (context, index) {
          String id = snapshots.data?.docs[index]['id'];
        });
  }
}*/
