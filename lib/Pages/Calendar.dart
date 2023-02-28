import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:papprototype/ui/add_task_bar.dart';
import 'package:papprototype/ui/theme.dart';
import 'package:papprototype/ui/widgets/input_field.dart';
import '../ui/edit_event.dart';

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
                String? id = snapshot.data?.docs[index].id;
                Timestamp t = snapshot.data?.docs[index]['date'];
                DateTime d = t.toDate();
                return Container(
                  width: 100,
                  height: 50,
                  color: Colors.green,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        child: Text(snapshot.data?.docs[index]['title']),
                      ),
                      Container(
                        width: 80,
                        child: Text(snapshot.data?.docs[index]['note']),
                      ),
                      Container(
                        width: 80,
                        child: Text(d.toString()),
                      ),
                      Container(
                        width: 80,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            /*final docEvent = FirebaseFirestore.instance
                                .collection('event')
                                .doc(id);

                            docEvent.update({
                              'title': 'Iglesias',
                              'note': 'lel',
                            });*/
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => editEvent(snapshot),
                              ),
                            );
                            //const editEvent();
                          },
                        ),
                      ),
                      Container(
                        width: 80,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('event')
                                .doc(snapshot.data?.docs[index].id)
                                .delete();
                          },
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
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
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
              child: Text('+Add Task')),
        ],
      ),
    );
  }
}
