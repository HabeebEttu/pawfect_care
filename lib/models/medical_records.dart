import 'dart:convert';
import 'dart:io';

class MedicalRecord {
  final String id;
  final String petId; 
  final String title;
  final String description;
  final DateTime date;

  final String? diagnosis;
  final String? treatmentNotes;
  final String? prescriptions;
  final List<File>? uploadedFiles; 
  MedicalRecord({
    required this.id,
    required this.petId,
    required this.title,
    required this.description,
    required this.date,
    this.diagnosis,
    this.treatmentNotes,
    this.prescriptions,
    this.uploadedFiles,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petId': petId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'diagnosis': diagnosis,
      'treatmentNotes': treatmentNotes,
      'prescriptions': prescriptions,
    };
  }

  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'],
      petId: map['petId'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      diagnosis: map['diagnosis'],
      treatmentNotes: map['treatmentNotes'],
      prescriptions: map['prescriptions'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalRecord.fromJson(String source) => MedicalRecord.fromMap(json.decode(source));
}
