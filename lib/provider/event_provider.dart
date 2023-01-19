import 'package:papprototype/model/event.dart';
import 'package:papprototype/utils.dart';
import 'package:flutter/cupertino.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  void addEvent(Event event) {
    _events.add(event);

    notifyListeners();
  }
}
