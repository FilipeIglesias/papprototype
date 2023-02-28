import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papprototype/ui/bottom_sheets/add_task_bottom_sheet_view.dart';
import 'package:papprototype/ui/view_models/app_view_model.dart';
import 'package:provider/provider.dart';
import 'package:papprototype/main.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(builder: (context, viewModel, child) {
      return SizedBox(
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: viewModel.clrvl3,
              foregroundColor: viewModel.clrvl1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            viewModel.bottomSheetBuilder(
                const AddTaskBottomSheetView(), context);
          },
        ),
      );
    });
  }
}
