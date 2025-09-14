import 'dart:io';

class MedicalRecord {
  final String id;
  final String petId; // link record to a specific pet
  final String title;
  final String description;
  final DateTime date;

  final String? diagnosis;
  final String? treatmentNotes;
  final String? prescriptions;
  final List<File>? uploadedFiles; // images, X-rays, test reports

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
}
