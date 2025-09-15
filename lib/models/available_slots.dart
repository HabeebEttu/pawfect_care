import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableSlot {
  final String slotId;
  final DateTime dateTime;

  AvailableSlot({required this.slotId, required this.dateTime});

  Map<String, dynamic> toMap() => {
    'slotId': slotId,
    'dateTime': dateTime,
  };

  factory AvailableSlot.fromMap(Map<String, dynamic> map) {
    return AvailableSlot(
      slotId: map['slotId'],
      dateTime: (map['dateTime'] as Timestamp).toDate(),
    );
  }
}
