import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../Pages/Calendar.dart';
import '../ui/theme.dart';
import '../ui/widgets/input_field.dart';
import '../ui/models/event_model.dart';

class EditEvent extends StatefulWidget {
  final String? id;

  const EditEvent({Key? key, required this.id}) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  String title = "";
  String note = "";
  DateTime _selectedDate = DateTime.now();
  String start_hour = "";
  String start_minute = "";
  String start_period = "";
  String end_hour = "";
  String end_minute = "";
  String end_period = "";
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  int? reminder = null;
  String repeat = "";
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  bool _allRequired = false;
  Future<Event> getDocumentId() async {
    String? id = widget.id;
    CollectionReference events = FirebaseFirestore.instance.collection('event');

    QuerySnapshot querySnapshot =
        await events.where('id', isEqualTo: '$id').get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      Event event = Event.fromDocument(documentSnapshot);
      String id = documentSnapshot.get('id');
      print(id);
      return event;
    } else {
      throw Exception('Document with the specified id not found');
    }
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: Colors.white,
      body: FutureBuilder<Event>(
        future: getDocumentId(),
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Event event = snapshot.data!;
              String id = event.id;
              title = event.title;
              note = event.note;
              DateTime _selectedDate = event.date;
              if (start_hour == "") {
                start_hour = event.start_hour;
                start_minute = event.start_minute;
                start_period = event.start_period;
                end_hour = event.end_hour;
                end_minute = event.end_minute;
                end_period = event.end_period;
              }
              if (reminder == null) {
                reminder = event.reminder;
              }
              if (repeat == "") {
                repeat = event.repeat;
              }
              return Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Tasks',
                        style: headingStyle,
                      ),
                      MyInputField(
                        title: "Title",
                        hint: event.title,
                        controller: _titleController,
                      ),
                      MyInputField(
                        title: "Note",
                        hint: event.note,
                        controller: _noteController,
                      ),
                      MyInputField(
                        title: "Date",
                        hint: DateFormat.yMMMMd().format(_selectedDate),
                        controller: _dateController,
                        widget: IconButton(
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () async {
                            print(_selectedDate);
                            await _getDateFromUser(_selectedDate);
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyInputField(
                              title: "Start Time",
                              controller: _startDateController,
                              hint: start_hour +
                                  ":" +
                                  start_minute +
                                  " " +
                                  start_period.toUpperCase(),
                              widget: IconButton(
                                icon: Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.grey,
                                ),
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context, initialTime: startTime);
                                  if (newTime == null) return;

                                  setState(() {
                                    startTime = newTime;
                                    start_hour =
                                        newTime.hourOfPeriod.toString();
                                    start_minute = newTime.minute.toString();
                                    start_period =
                                        newTime.period.toString().toUpperCase();

                                    if (startTime.period
                                            .toString()
                                            .toUpperCase() ==
                                        "DAYPERIOD.AM") {
                                      start_period = "AM";
                                    } else {
                                      start_period = "PM";
                                    }
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
                              title: "End Time",
                              controller: _endDateController,
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
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context, initialTime: endTime);
                                  if (newTime == null) return;

                                  setState(() {
                                    endTime = newTime;
                                    end_hour = endTime.hourOfPeriod.toString();
                                    end_minute = endTime.minute.toString();
                                    end_period =
                                        endTime.period.toString().toUpperCase();

                                    end_hour = endTime.hourOfPeriod.toString();
                                    end_minute = endTime.minute.toString();
                                    if (endTime.period
                                            .toString()
                                            .toUpperCase() ==
                                        "DAYPERIOD.AM") {
                                      end_period = "AM";
                                    } else {
                                      end_period = "PM";
                                    }
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
                        controller: _reminderController,
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
                          items: remindList.map<DropdownMenuItem<String>>(
                            (int value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value.toString()),
                              );
                            },
                          ).toList(),
                          onChanged: (String? newValue) {
                            if (newValue == null) return;
                            setState(() {
                              print(newValue);
                              reminder = int.parse(newValue);
                              print(reminder);
                            });
                          },
                        ),
                      ),
                      MyInputField(
                        title: "Repeat",
                        hint: "$repeat",
                        controller: _repeatController,
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
                          items: repeatList.map<DropdownMenuItem<String>>(
                            (String? value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value!,
                                    style: TextStyle(color: Colors.grey)),
                              );
                            },
                          ).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              repeat = newValue!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryClr,
                              fixedSize: Size(120, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          onPressed: () {
                            _validateDate();
                            if (_allRequired == true) {
                              _updateEvent(id);
                            }
                          },
                          child: Text('Edit Task')),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  void _updateEvent(id) async {
    try {
      if (!_titleController.text.isEmpty && !_noteController.text.isEmpty) {
        title = _titleController.text;
        note = _noteController.text;
      }
      await FirebaseFirestore.instance.collection('event').doc(id).update({
        'title': title,
        'note': note,
        'date': Timestamp.fromDate(_selectedDate),
        'start_hour': startTime.hourOfPeriod.toString(),
        'start_minute': startTime.minute >= 10
            ? startTime.minute.toString()
            : "0" + startTime.minute.toString(),
        'start_period': startTime.period.name.toString().toUpperCase(),
        'end_hour': endTime.hourOfPeriod.toString(),
        'end_minute': endTime.minute >= 10
            ? endTime.minute.toString()
            : "0" + endTime.minute.toString(),
        'end_period': endTime.period.name.toString().toUpperCase(),
        'reminder': reminder,
        'repeat': repeat,
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
    if (_selectedDate == null ||
        startTime == null ||
        endTime == null ||
        reminder == null ||
        repeat == "") {
      setState(() {
        _allRequired = false;
      });
    } else {
      setState(() {
        _allRequired = true;
      });
    }
  }

  Future<void> _getDateFromUser(_selectedDate) async {
    DateTime _initialDate = _selectedDate;
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        _dateController.text = DateFormat.yMMMMd().format(_pickerDate);
        _initialDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print("It's null or something is wrong");
    }
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
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
