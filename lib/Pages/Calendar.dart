import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:papprototype/ui/add_task_bar.dart';
import 'package:papprototype/ui/theme.dart';
import 'package:papprototype/ui/widgets/input_field.dart';
import '../ui/edit_event.dart';
import '../ui/EditEvent.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(
          top: 50,
        ),
        child: Column(
          children: [
            _addTaskBar(context),
            _addDateBar(),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('event').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                String? id = snapshot.data?.docs[index]['id'];
                Timestamp t = snapshot.data?.docs[index]['date'];
                DateTime d = t.toDate();
                int start_hour = int.parse(snapshot.data?.docs[index]['start_hour']);
                int start_minute = int.parse(snapshot.data?.docs[index]['start_minute']);
                int end_hour = int.parse(snapshot.data?.docs[index]['end_hour']);
                int end_minute = int.parse(snapshot.data?.docs[index]['end_minute']);
                return Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data?.docs[index]['title'],
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SFProDisplay',
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              (start_hour >= 10
                                      ? start_hour.toString()
                                      : "0" + start_hour.toString()) +
                                  ":" +
                                  (start_minute >= 10
                                      ? start_minute.toString()
                                      : "0" + start_minute.toString()) +
                                  " " +
                                  snapshot.data?.docs[index]['start_period'] +
                                  ' - ' +
                                  (end_hour >= 10
                                      ? end_hour.toString()
                                      : "0" + end_hour.toString()) +
                                  ":" +
                                  (end_minute >= 10
                                      ? end_minute.toString()
                                      : "0" + end_minute.toString()) +
                                  " " +
                                  snapshot.data?.docs[index]['end_period'],
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'SFProDisplay',
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditEvent(
                                      id: id,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete'),
                                      content: Text(
                                        'Are you sure you want to delete this event?',
                                        style: bodyStyle.copyWith(
                                            fontFamily: 'SFProDisplay'),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text(
                                            'Cancel',
                                            style: bodyStyle.copyWith(
                                                fontFamily: 'SFProDisplay'),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                          ),
                                          child: Text(
                                            'Delete',
                                            style: bodyStyle.copyWith(
                                                fontFamily: 'SFProDisplay'),
                                          ),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('event')
                                                .doc(snapshot
                                                    .data?.docs[index].id)
                                                .delete();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  //Datas em scroll
  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        monthTextStyle: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  //Data e adicionar evento
  _addTaskBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle.copyWith(fontFamily: 'SFProDisplay'),
                ),
                Text(
                  "Today",
                  style: headingStyle.copyWith(fontFamily: 'SFProDisplay'),
                ),
              ],
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryClr,
                  fixedSize: Size(120, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddTaskPage()));
              },
              child: Text(
                '+Add Task',
                style: bodyStyle.copyWith(fontFamily: 'SFProDisplay'),
              )),
        ],
      ),
    );
  }
}
