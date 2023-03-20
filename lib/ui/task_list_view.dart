import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:papprototype/ui/view_models/app_view_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({Key? key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  Map<String, bool> _completedTasks = {};

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('reminders').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final documents = snapshot.data!.docs;

            return Container(
              decoration: BoxDecoration(
                color: viewModel.clrvl2,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView.separated(
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  final document = documents[index];
                  final title = document['title'] as String?;
                  final completed = document['completed'] as bool?;
                  final id = document['id'] as String?;

                  // Store the completed state of each task in a map
                  _completedTasks[id!] = completed ?? false;

                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) async {
                      await FirebaseFirestore.instance
                          .collection('reminders') // Use 'reminders' collection
                          .doc(snapshot.data?.docs[index].id)
                          .delete();
                    },
                    background: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.delete,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: viewModel.clrvl1,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        onTap: () {
                          viewModel.getTaskValue(index);
                        },
                        leading: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide(width: 2, color: viewModel.clrvl3),
                          checkColor: viewModel.clrvl1,
                          activeColor: viewModel.clrvl3,
                          value: _completedTasks[id] ??
                              false, // Use the stored completed state
                          onChanged: (newValue) async {
                            setState(() {
                              _completedTasks[id] = newValue ?? false;
                            });
                            try {
                              await FirebaseFirestore.instance
                                  .collection('reminders')
                                  .doc(id)
                                  .update({
                                'completed': _completedTasks[id],
                              });
                            } catch (e) {
                              print('Error updating checkbox state: $e');
                            }
                          },
                        ),
                        title: Text(
                          title!,
                          style: TextStyle(
                            color: viewModel.clrvl4,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: documents.length,
                separatorBuilder: (context, index){
              return SizedBox(
                height: 15,
              );
            },
          ),
        );
      },
    );
  },
);
}
}