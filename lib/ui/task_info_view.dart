import 'package:flutter/cupertino.dart';
import 'package:papprototype/ui/view_models/app_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class TaskInfoView extends StatelessWidget {
  const TaskInfoView({super.key});

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
                          stream: viewModel.numTask(),
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
                          stream: viewModel.numTasksRemaining(),
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
