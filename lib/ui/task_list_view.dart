import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papprototype/ui/view_models/app_view_model.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Container(
            decoration: BoxDecoration(
                color: viewModel.clrvl2,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: ListView.separated(
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      viewModel.deleteTask(index);
                    },
                    background: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.red.shade300, borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Icon(Icons.delete, color: Colors.red.shade700,),),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: viewModel.clrvl1,
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        leading: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide(width: 2, color: viewModel.clrvl3),
                          checkColor: viewModel.clrvl1,
                          activeColor: viewModel.clrvl3,
                          value: viewModel.getTaskValue(index),
                          onChanged: (value) {
                            viewModel.setTaskValue(index, value!);
                          },
                        ),
                        title: Text(
                          viewModel.getTaskTitle(index),
                          style: TextStyle(
                              color: viewModel.clrvl4,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: viewModel.numTasks,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 15,
                  );
                }));
      },
    );
  }
}
