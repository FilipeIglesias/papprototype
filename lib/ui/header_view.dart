import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papprototype/ui/bottom_sheets/delete_bottom_sheet_view.dart';
import 'package:papprototype/ui/view_models/app_view_model.dart';
import 'package:provider/provider.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Reminders",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  viewModel.bottomSheetBuilder(
                    DeleteBottomSheetView(), context
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        Icons.delete,
                        color: viewModel.clrvl3,
                        size: 40,
                      )),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
