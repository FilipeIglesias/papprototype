import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:papprototype/ui/theme.dart';
import 'package:papprototype/ui/widgets/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Pages/Calendar.dart';

class AddTaskPage extends StatefulWidget {
  final FirebaseAuth auth;

  AddTaskPage({required this.auth, Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  TimeOfDay startTime1 = TimeOfDay(hour: 10, minute: 10);
  TimeOfDay endTime1 = TimeOfDay(hour: 10, minute: 10);
  DateTime _selectedDate = DateTime.now();
  String _endTime = DateFormat("hh:mm a")
      .format(DateTime.now().add(Duration(hours: 1)))
      .toString();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
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

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Tasks',
                style: headingStyle,
              ),
              MyInputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMMMMd().format(_selectedDate),
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
                      title: "Start Time",
                      hint: startTime1.hourOfPeriod.toString() +
                          ":" +
                          startTime1.minute.toString() +
                          " " +
                          startTime1.period.name.toString().toUpperCase(),
                      widget: IconButton(
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () async {
                          TimeOfDay? newTime = await showTimePicker(
                              context: context, initialTime: startTime1);
                          if (newTime == null) return;

                          setState(() {
                            startTime1 = newTime;
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
                      hint: endTime1.hourOfPeriod.toString() +
                          ":" +
                          endTime1.minute.toString() +
                          " " +
                          endTime1.period.name.toString().toUpperCase(),
                      widget: IconButton(
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () async {
                          TimeOfDay? newTime = await showTimePicker(
                              context: context, initialTime: endTime1);
                          if (newTime == null) return;

                          setState(() {
                            endTime1 = newTime;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Reminder",
                hint: "$_selectedRemind minutes early",
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
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: "$_selectedRepeat",
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
                        child:
                            Text(value!, style: TextStyle(color: Colors.grey)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _typeEvent(),
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
                          _sendEvent();
                        }
                      },
                      child: Text('Create Task')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendEvent() {
    final event = <String, dynamic>{
      "id": null,
      "uid": null,
      "title": _titleController.text,
      "note": _noteController.text,
      "date": _selectedDate,
      "year": _selectedDate.year,
      "month": _selectedDate.month,
      "day": _selectedDate.day,
      "start_time": startTime1.toString(),
      "end_time": endTime1.toString(),
      "start_hour": startTime1.hourOfPeriod.toString(),
      "start_minute": startTime1.minute.toString(),
      "start_period": startTime1.period.name.toString().toUpperCase(),
      "end_hour": endTime1.hourOfPeriod.toString(),
      "end_minute": endTime1.minute.toString(),
      "end_period": endTime1.period.name.toString().toUpperCase(),
      "reminder": _selectedRemind,
      "repeat": _selectedRepeat,
    };

    // Add a new document with a generated ID

    FirebaseFirestore.instance.collection("event").add(event).then(
      (DocumentReference doc) {
        doc.update({"id": doc.id});

        final uid = widget.auth.currentUser!.uid;
        doc.update({"uid": uid});
        print('DocumentSnapshot added with ID: ${doc.id}');
      },
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      Get.back();
      _allRequired = true;
    } else if (_titleController.text.isNotEmpty ||
        _noteController.text.isNotEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.pink,
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  _typeEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type",
          style: titleStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? PersonalClr
                      : index == 1
                          ? WorkClr
                          : OtherClr,
                  child: _selectedColor == index
                      ? Icon(Icons.done, color: Colors.white, size: 16)
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _appBar(BuildContext context) {
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

  //Day
  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
}
