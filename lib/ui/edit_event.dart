import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:papprototype/ui/theme.dart';
import 'package:papprototype/ui/widgets/input_field.dart';

class editEvent extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snap;
  final String? id;
  const editEvent({Key? key, required this.snap, required this.id})
      : super(key: key);

  @override
  State<editEvent> createState() => _editEventState();
}

class _editEventState extends State<editEvent> {
  TimeOfDay endTime1 = TimeOfDay(hour: 10, minute: 10);
  TimeOfDay startTime1 = TimeOfDay(hour: 10, minute: 10);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String start_hour = "";
  String start_minute = "";
  String start_period = "";
  String end_hour = "";
  String end_minute = "";
  String end_period = "";
  int reminder = 0;
  DateTime _selectedDate = DateTime.now();
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  int _selectedColor = 0;
  bool _allRequired = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('event').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        String? id = widget.id;
                        id = widget.snap.data?.docs[index]['id'];
                        String oldTitle =
                            widget.snap.data?.docs[index]['title'];
                        String oldNote = widget.snap.data?.docs[index]['note'];
                        Timestamp oldDate =
                            widget.snap.data?.docs[index]['date'];
                        DateTime oldDay = oldDate.toDate();
                        start_hour =
                            widget.snap.data?.docs[index]['start_hour'];
                        start_minute =
                            widget.snap.data?.docs[index]['start_minute'];
                        start_period =
                            widget.snap.data?.docs[index]['start_period'];
                        end_hour = widget.snap.data?.docs[index]['end_hour'];
                        end_minute =
                            widget.snap.data?.docs[index]['end_minute'];
                        end_period =
                            widget.snap.data?.docs[index]['end_period'];
                        reminder = widget.snap.data?.docs[index]['reminder'];
                        String oldRepeat =
                            widget.snap.data?.docs[index]['repeat'];

                        return Row(
                          children: [
                            Expanded(
                                child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Edit Tasks',
                                            style: headingStyle,
                                          ),
                                          MyInputField(
                                            title: "Title",
                                            hint: oldTitle,
                                            controller: _titleController,
                                          ),
                                          MyInputField(
                                            title: "Note",
                                            hint: oldNote,
                                            controller: _noteController,
                                          ),
                                          MyInputField(
                                            title: "Date",
                                            hint: DateFormat.yMMMMd()
                                                .format(oldDay),
                                            widget: IconButton(
                                              icon: Icon(
                                                Icons.calendar_today_outlined,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                _getDateFromUser();
                                              },
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: MyInputField(
                                                  title: "Start Date",
                                                  hint: start_hour +
                                                      ":" +
                                                      start_minute +
                                                      " " +
                                                      start_period
                                                          .toUpperCase(),
                                                  widget: IconButton(
                                                    icon: Icon(
                                                      Icons.access_time_rounded,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: () async {
                                                      TimeOfDay? newTime =
                                                          await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  startTime1);
                                                      if (newTime == null)
                                                        return;

                                                      setState(() {
                                                        startTime1 = newTime;
                                                        start_hour = startTime1
                                                            .hourOfPeriod
                                                            .toString();
                                                        start_minute =
                                                            startTime1.minute
                                                                .toString();
                                                        start_period =
                                                            startTime1.period
                                                                .toString()
                                                                .toUpperCase();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Expanded(
                                                child: MyInputField(
                                                  title: "End Date",
                                                  hint: end_hour +
                                                      ":" +
                                                      end_minute +
                                                      " " +
                                                      end_period.toUpperCase(),
                                                  widget: IconButton(
                                                    icon: Icon(
                                                      Icons.access_time_rounded,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: () async {
                                                      TimeOfDay? newTime =
                                                          await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  endTime1);
                                                      if (newTime == null)
                                                        return;

                                                      setState(() {
                                                        endTime1 = newTime;
                                                        end_hour = endTime1
                                                            .hourOfPeriod
                                                            .toString();
                                                        end_minute = endTime1
                                                            .minute
                                                            .toString();
                                                        end_period = endTime1
                                                            .period
                                                            .toString()
                                                            .toUpperCase();
                                                        reminder = 0;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          MyInputField(
                                            title: "Reminder",
                                            hint: "$reminder minutes early",
                                            widget: DropdownButton(
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.grey,
                                              ),
                                              iconSize: 32,
                                              elevation: 4,
                                              style: subTitleStyle,
                                              underline: Container(
                                                height: 0,
                                              ),
                                              items: remindList.map<
                                                  DropdownMenuItem<String>>(
                                                (int value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value.toString(),
                                                    child:
                                                        Text(value.toString()),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (String? newValue) {
                                                if (newValue == null) return;
                                                setState(() {
                                                  print(newValue);
                                                  reminder =
                                                      int.parse(newValue);
                                                  print(reminder);
                                                });
                                              },
                                            ),
                                          ),
                                          MyInputField(
                                            title: "Repeat",
                                            hint: "$oldRepeat",
                                            widget: DropdownButton(
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.grey,
                                              ),
                                              iconSize: 32,
                                              elevation: 4,
                                              style: subTitleStyle,
                                              underline: Container(
                                                height: 0,
                                              ),
                                              items: repeatList.map<
                                                  DropdownMenuItem<String>>(
                                                (String? value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value.toString(),
                                                    child: Text(value!,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedRepeat = newValue!;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18,
                                          ),
                                          /*Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          _typeEvent(),*/
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryClr,
                                                  fixedSize: Size(120, 60),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  )),
                                              onPressed: () {
                                                _validateDate();
                                                if (_allRequired == true) {
                                                  _updateEvent();
                                                }
                                              },
                                              child: Text('Edit Task')),
                                        ],
                                      ),
                                      //]
                                    ))
                                //)
                                ),
                          ],
                        );
                      });
                })));
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print("It´s null or something is wrong");
    }
  }

  void _updateEvent() async {
    try {
      await FirebaseFirestore.instance
          .collection('event')
          .doc(widget.snap.data!.docs[0].id)
          .update({
        'title': _titleController.text,
        'note': _noteController.text,
        'date': Timestamp.fromDate(_selectedDate),
        'start_hour': startTime1.hourOfPeriod.toString(),
        'start_minute': startTime1.minute.toString(),
        'start_period': startTime1.period.name.toString().toUpperCase(),
        'end_hour': endTime1.hourOfPeriod.toString(),
        'end_minute': endTime1.minute.toString(),
        'end_period': endTime1.period.name.toString().toUpperCase(),
        'reminder': reminder,
        'repeat': _selectedRepeat,
      });
      Get.back();
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error updating event: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void _validateDate() {
    if (_titleController.text.trim().isEmpty ||
        _noteController.text.trim().isEmpty ||
        _selectedDate == null) {
      setState(() {
        _allRequired = false;
      });
    } else {
      setState(() {
        _allRequired = true;
      });
    }
  }
}
