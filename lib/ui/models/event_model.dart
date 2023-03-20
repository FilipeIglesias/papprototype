import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String note;
  final DateTime date;
  final String start_hour;
  final String start_minute;
  final String start_period;
  String end_hour;
  String end_minute;
  String end_period;
  final int reminder;
  final String repeat;

  Event({
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.start_hour,
    required this.start_minute,
    required this.start_period,
    required this.end_hour,
    required this.end_minute,
    required this.end_period,
    required this.reminder,
    required this.repeat,
  });

  factory Event.fromDocument(DocumentSnapshot doc) {
    return Event(
      id: doc.id,
      title: doc['title'],
      note: doc['note'],
      date: (doc['date'] as Timestamp).toDate(),
      start_hour: doc['start_hour'],
      start_minute: doc['start_minute'],
      start_period: doc['start_period'],
      end_hour: doc['end_hour'],
      end_minute: doc['end_minute'],
      end_period: doc['end_period'],
      reminder: doc['reminder'],
      repeat: doc['repeat'],
    );
  }
}
