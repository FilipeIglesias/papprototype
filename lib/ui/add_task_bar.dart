import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Pages/Calendar.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Container(),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CalendarPage()));
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: Colors.orangeAccent,
          radius: 35,
          backgroundImage: AssetImage('images/pfp.png'),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
