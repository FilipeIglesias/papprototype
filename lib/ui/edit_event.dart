import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:papprototype/ui/theme.dart';
import 'package:papprototype/ui/widgets/input_field.dart';

class editEvent extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snap;
  const editEvent(this.snap, {super.key});

  @override
  State<editEvent> createState() => _editEventState();
}

class _editEventState extends State<editEvent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String oldStart = "";
  String oldEnd = "";
  String _endTime = "9.30 PM";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('event').snapshots(),
                builder: (context, snap1) {
                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        String id = widget.snap.data?.docs[index]['id'];
                        String oldTitle =
                            widget.snap.data?.docs[index]['title'];
                        String oldNote = widget.snap.data?.docs[index]['note'];
                        Timestamp oldDate =
                            widget.snap.data?.docs[index]['date'];
                        DateTime oldDay = oldDate.toDate();
                        String oldStart =
                            widget.snap.data?.docs[index]['start'];
                        String oldEnd = widget.snap.data?.docs[index]['end'];
                        int oldRemind =
                            widget.snap.data?.docs[index]['reminder'];
                        int currentRemind = oldRemind;
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
                                            hint:
                                                DateFormat.yMMMMd().format(oldDay),
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
                                                  hint: _startTime,
                                                  widget: IconButton(
                                                    icon: Icon(
                                                      Icons.access_time_rounded,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: (() {
                                                      _getTimeFromUser(
                                                          isStartTime: true);
                                                    }),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Expanded(
                                                child: MyInputField(
                                                  title: "End Date",
                                                  hint: _endTime,
                                                  widget: IconButton(
                                                    icon: Icon(
                                                      Icons.access_time_rounded,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed: (() {
                                                      _getTimeFromUser(
                                                          isStartTime: false);
                                                    }),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          MyInputField(
                                            title: "Reminder",
                                            hint: "$currentRemind minutes early",
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
                                              items: remindList
                                                  .map<DropdownMenuItem<String>>(
                                                (int value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value.toString(),
                                                    child: Text(value.toString()),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedRemind =
                                                      int.parse(newValue!);
                                                  currentRemind = _selectedRemind;
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
                                              items: repeatList
                                                  .map<DropdownMenuItem<String>>(
                                                (String? value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value.toString(),
                                                    child: Text(value!,
                                                        style: TextStyle(
                                                            color: Colors.grey)),
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
                                                        BorderRadius.circular(20),
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

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time Canceled");
    } else if (isStartTime == true) {
      setState(() {
        oldStart = _formatedTime;
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        oldEnd = _formatedTime;
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
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
        'start': _startTime,
        'end': _endTime,
        'reminder': _selectedRemind,
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
