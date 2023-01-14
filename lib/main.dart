import 'package:flutter/material.dart';
import 'package:papprototype/Pages/Account.dart';
import 'package:papprototype/Pages/Calendar.dart';
import 'package:papprototype/Pages/HomePage.dart';
import 'package:papprototype/Pages/Reminders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF0A2647),
        ),
      ),
      home: NavigationBar(),
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    CalendarPage(),
    ReminderPage(),
    Account(),
  ];

  void OnTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeZone'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: OnTappedBar,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: const Color(0xFF0A2647),
          ),
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