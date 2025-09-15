import 'dart:convert';

import 'package:pawfect_care/models/adoption_status.dart';

class AdoptionRecord {
  final String adoptionId;
  final String petId;
  final String userId;
  final DateTime adoptionDate;
  final AdoptionStatus status;

  AdoptionRecord({
    required this.adoptionId,
    required this.petId,
    required this.userId,
    required this.adoptionDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'adoptionId': adoptionId,
      'petId': petId,
      'userId': userId,
      'adoptionDate': adoptionDate.toIso8601String(),
      'status': status.toString(),
    };
  }

  factory AdoptionRecord.fromMap(Map<String, dynamic> map) {
    return AdoptionRecord(
      adoptionId: map['adoptionId'],
      petId: map['petId'],
      userId: map['userId'],
      adoptionDate: DateTime.parse(map['adoptionDate']),
      status: _statusFromString(map['status']),
    );
  }

  static AdoptionStatus _statusFromString(String status) {
    return AdoptionStatus.values.firstWhere(
      (e) => e.toString().split('.').last == status,
      orElse: () => AdoptionStatus.pending,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdoptionRecord.fromJson(String source) =>
      AdoptionRecord.fromMap(json.decode(source));

  AdoptionRecord copyWith({
    String? adoptionId,
    String? petId,
    String? userId,
    DateTime? adoptionDate,
    AdoptionStatus? status,
  }) {
    return AdoptionRecord(
      adoptionId: adoptionId ?? this.adoptionId,
      petId: petId ?? this.petId,
      userId: userId ?? this.userId,
      adoptionDate: adoptionDate ?? this.adoptionDate,
      status: status ?? this.status,
    );
  }
}