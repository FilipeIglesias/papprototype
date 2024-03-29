import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papprototype/ui/view_models/app_view_model.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';

class AddTaskBottomSheetView extends StatelessWidget {
  final FirebaseAuth auth;
  const AddTaskBottomSheetView({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    final TextEditingController entryController = TextEditingController();

    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: 80,
            child: Center(
              child: SizedBox(
                height: 40,
                width: 250,
                child: TextField(
                  onSubmitted: (value) {
                    if (entryController.text.isNotEmpty) {
                      Task newTask = Task(entryController.text, false);
                      entryController.clear();
                      viewModel.sendTask(newTask);
                    }
                    Navigator.of(context).pop();
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 5),
                      filled: true,
                      fillColor: viewModel.clrvl2,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none))),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  autocorrect: false,
                  autofocus: true,
                  controller: entryController,
                  style: TextStyle(
                      color: viewModel.clrvl4, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
