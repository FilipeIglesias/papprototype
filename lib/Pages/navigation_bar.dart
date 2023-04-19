import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Account.dart';
import 'Calendar.dart';
import 'Reminders.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    CalendarPage(auth: FirebaseAuth.instance),
    ReminderPage(auth: FirebaseAuth.instance),
    Account(auth: FirebaseAuth.instance),
  ];

  void OnTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: OnTappedBar,
        currentIndex: _currentIndex,
        items: [
          /*BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: const Color(0xFF0A2647),
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
            backgroundColor: const Color(0xFF0A2647),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Reminders',
            backgroundColor: const Color(0xFF0A2647),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: const Color(0xFF0A2647),
          ),
        ],
      ),
    );
  }
}