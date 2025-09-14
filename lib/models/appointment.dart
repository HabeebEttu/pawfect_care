import 'dart:convert';

import 'package:pawfect_care/models/status.dart';

import 'status.dart';

class Appointment {
  String appointmentId;
  String petId;
  String vetId;
  DateTime? appointmentTime;
  Status? appointmentStatus;
  String? notes;
  String service;
  Appointment({
    required this.appointmentId,
    required this.petId,
    required this.vetId,
    this.appointmentTime,
    required this.appointmentStatus,
    this.notes,
    required this.service,
  });

  Appointment copyWith({
    String? appointmentId,
    String? petId,
    String? vetId,
    DateTime? appointmentTime,
    Status? appointmentStatus,
    String? notes,
    String? service,
  }) {
    return Appointment(
      appointmentId: appointmentId ?? this.appointmentId,
      petId: petId ?? this.petId,
      vetId: vetId ?? this.vetId,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      notes: notes ?? this.notes,
      service: service ?? this.service,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appointmentId': appointmentId,
      'petId': petId,
      'vetId': vetId,
      'appointmentTime': appointmentTime?.millisecondsSinceEpoch,
      'appointmentStatus': appointmentStatus?.name,
      'notes': notes,
      'service': service,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      appointmentId: map['appointmentId'] as String,
      petId: map['petId'] as String,
      vetId: map['vetId'] as String,
      appointmentTime: map['appointmentTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['appointmentTime'] as int)
          : null,
      appointmentStatus: Status.values.byName(
        map['appointmentStatus'] as String,
      ),
      notes: map['notes'] != null ? map['notes'] as String : null,
      service: map['service'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Appointment.fromJson(String source) =>
      Appointment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Appointment(appointmentId: $appointmentId, petId: $petId, vetId: $vetId, appointmentTime: $appointmentTime, appointmentStatus: $appointmentStatus, notes: $notes, service: $service)';
  }

  @override
  bool operator ==(covariant Appointment other) {
    if (identical(this, other)) return true;

    return other.appointmentId == appointmentId &&
        other.petId == petId &&
        other.vetId == vetId &&
        other.appointmentTime == appointmentTime &&
        other.appointmentStatus == appointmentStatus &&
        other.notes == notes &&
        other.service == service;
  }

  @override
  int get hashCode {
    return appointmentId.hashCode ^
        petId.hashCode ^
        vetId.hashCode ^
        appointmentTime.hashCode ^
        appointmentStatus.hashCode ^
        notes.hashCode ^
        service.hashCode;
  }
}
