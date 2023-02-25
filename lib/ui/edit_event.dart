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
    return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('event').snapshots(),
              builder: (context, snap1) {
                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        
                        String oldTitle = widget.snap.data?.docs[index]['title'];
                        String oldNote = widget.snap.data?.docs[index]['note'];
                        Timestamp oldDate = widget.snap.data?.docs[index]['date'];
                        DateTime oldDay = oldDate.toDate();
                        return Expanded(child: Container(
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
                                    hint: oldTitle,
                                    controller: _titleController,
                                  ),
                                  MyInputField(
                                    title: "Note",
                                    hint: oldNote,
                                    controller: _noteController,
                                  ),
                                  /*MyInputField(
                                    title: "Date",
                                    hint:
                                        DateFormat.yMMMMd().format(_selectedDate),
                                    widget: IconButton(
                                      icon: Icon(
                                        Icons.calendar_today_outlined,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        //_getDateFromUser();
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
                                              //_getTimeFromUser(isStartTime: true);
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
                                              //_getTimeFromUser(isStartTime: false);
                                            }),
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
                                  Row(
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
                                );
                              
                            
                          
                        
                      });
              
              }
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

  _editEvent() async{

    await FirebaseFirestore.instance.collection('event').doc(doc.id).,

    /*final event = <String, dynamic>{
      "title": _titleController.text,
      "note": _noteController.text,
      /*"date": _selectedDate,
      "start": _startTime,
      "end": _endTime,
      "reminder": _selectedRemind,
      "repeat": _selectedRepeat,*/
    };

    // Add a new document with a generated ID

    FirebaseFirestore.instance.collection("event").update(doc.id).then(
        (DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}'));*/
  } 

}

  /*_updateEvent(){
    
  }*/
