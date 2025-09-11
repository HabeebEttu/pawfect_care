// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pawfect_care/models/status.dart';

class Appointment {
  String appointmentId;
  String petId;
  String vetId;
  DateTime appointmentTime;
  Status appointmentStatus;
  String notes;
  Appointment({
    required this.appointmentId,
    required this.petId,
    required this.vetId,
    required this.appointmentTime,
    required this.appointmentStatus,
    required this.notes,
  });

  Appointment copyWith({
    String? appointmentId,
    String? petId,
    String? vetId,
    DateTime? appointmentTime,
    Status? appointmentStatus,
    String? notes,
  }) {
    return Appointment(
      appointmentId: appointmentId ?? this.appointmentId,
      petId: petId ?? this.petId,
      vetId: vetId ?? this.vetId,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appointmentId': appointmentId,
      'petId': petId,
      'vetId': vetId,
      'appointmentTime': appointmentTime.millisecondsSinceEpoch,
      'appointmentStatus': appointmentStatus.toString(),
      'notes': notes,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      appointmentId: map['appointmentId'] as String,
      petId: map['petId'] as String,
      vetId: map['vetId'] as String,
      appointmentTime: DateTime.fromMillisecondsSinceEpoch(map['appointmentTime'] as int),
      appointmentStatus: _statusFromString(map['appointmentStatus'] as String),
      notes: map['notes'] as String,
    );
  }
  static Status _statusFromString(String status) {
    return Status.values.firstWhere(
      (e) => e.toString().split('.').last == status,
      orElse: () => Status.PENDING, 
    );
  }
  String toJson() => json.encode(toMap());

  factory Appointment.fromJson(String source) => Appointment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Appointment(appointmentId: $appointmentId, petId: $petId, vetId: $vetId, appointmentTime: $appointmentTime, appointmentStatus: $appointmentStatus, notes: $notes)';
  }

  @override
  bool operator ==(covariant Appointment other) {
    if (identical(this, other)) return true;
  
    return 
      other.appointmentId == appointmentId &&
      other.petId == petId &&
      other.vetId == vetId &&
      other.appointmentTime == appointmentTime &&
      other.appointmentStatus == appointmentStatus &&
      other.notes == notes;
  }

  @override
  int get hashCode {
    return appointmentId.hashCode ^
      petId.hashCode ^
      vetId.hashCode ^
      appointmentTime.hashCode ^
      appointmentStatus.hashCode ^
      notes.hashCode;
  }
}
