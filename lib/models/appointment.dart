import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/status.dart';

class Appointment {
  final String id;
  final String petId;
  final String vetId;
  final String ownerId;
  final DateTime? appointmentTime;
  final Status appointmentStatus;
  final String? notes;
  final String service;

  Appointment({
    required this.id,
    required this.petId,
    required this.vetId,
    required this.ownerId,
    this.appointmentTime,
    required this.appointmentStatus,
    this.notes,
    required this.service,
  });

  /// Creates a new copy with updated fields
  Appointment copyWith({
    String? id,
    String? petId,
    String? vetId,
    String? ownerId,
    DateTime? appointmentTime,
    Status? appointmentStatus,
    String? notes,
    String? service,
  }) {
    return Appointment(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      vetId: vetId ?? this.vetId,
      ownerId: ownerId ?? this.ownerId,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      notes: notes ?? this.notes,
      service: service ?? this.service,
    );
  }

  /// Validate required fields
  void validate() {
    if (petId.isEmpty || vetId.isEmpty || ownerId.isEmpty || service.isEmpty) {
      throw Exception('Missing required appointment details.');
    }
  }

  /// Convert object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'vetId': vetId,
      'ownerId': ownerId,
      'appointmentTime':
      appointmentTime != null ? Timestamp.fromDate(appointmentTime!) : null,
      'appointmentStatus': appointmentStatus.name,
      'notes': notes,
      'service': service,
    };
  }

  /// Create object from Firestore map
  factory Appointment.fromMap(Map<String, dynamic> map, String id) {
    return Appointment(
      id: id,
      petId: map['petId'] as String,
      vetId: map['vetId'] as String,
      ownerId: map['ownerId'] as String,
      appointmentTime: map['appointmentTime'] != null
          ? (map['appointmentTime'] as Timestamp).toDate()
          : null,
      appointmentStatus: Status.values.firstWhere(
            (e) => e.name == map['appointmentStatus'],
        orElse: () => Status.PENDING, // default fallback
      ),
      notes: map['notes'] as String?,
      service: map['service'] as String,
    );
  }

  /// JSON encode/decode helpers
  String toJson() => json.encode(toMap());

  factory Appointment.fromJson(String source, String id) =>
      Appointment.fromMap(json.decode(source) as Map<String, dynamic>, id);

  @override
  String toString() {
    return 'Appointment(id: $id, petId: $petId, vetId: $vetId, ownerId: $ownerId, '
        'appointmentTime: $appointmentTime, appointmentStatus: $appointmentStatus, '
        'notes: $notes, service: $service)';
  }

  @override
  bool operator ==(covariant Appointment other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.petId == petId &&
        other.vetId == vetId &&
        other.ownerId == ownerId &&
        other.appointmentTime == appointmentTime &&
        other.appointmentStatus == appointmentStatus &&
        other.notes == notes &&
        other.service == service;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    petId.hashCode ^
    vetId.hashCode ^
    ownerId.hashCode ^
    appointmentTime.hashCode ^
    appointmentStatus.hashCode ^
    notes.hashCode ^
    service.hashCode;
  }
}
