import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papprototype/ui/view_models/app_view_model.dart';
import 'package:provider/provider.dart';

class DeleteBottomSheetView extends StatelessWidget {
  const DeleteBottomSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          height: 125,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  viewModel.deleteAllTasks();
                  Navigator.of(context).pop();
                },
                child: Text("Delete All"),
                style: ElevatedButton.styleFrom(
                    foregroundColor: viewModel.clrvl1,
                    backgroundColor: viewModel.clrvl3,
                    textStyle: TextStyle(fontWeight: FontWeight.w700),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(width: 15,),
              ElevatedButton(
                onPressed: () {
                  viewModel.deleteCompletedTasks();
                  Navigator.of(context).pop();
                },
                child: Text("Delete Selected"),
                style: ElevatedButton.styleFrom(
                    foregroundColor: viewModel.clrvl1,
                    backgroundColor: viewModel.clrvl3,
                    textStyle: TextStyle(fontWeight: FontWeight.w700),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ],
          ),
        );
      },
    );
  }
}
