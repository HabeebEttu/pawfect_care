import 'dart:io';
import 'package:flutter/material.dart';
import '../models/medical_records.dart';

class MedicalRecordDetailPage extends StatelessWidget {
  final String petId;
  final List<MedicalRecord> allRecords;

  const MedicalRecordDetailPage({
    Key? key,
    required this.petId,
    required this.allRecords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter all records for this pet
    final petRecords = allRecords
        .where((record) => record.petId == petId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // most recent first

    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Records: $petId"),
        backgroundColor: Colors.blueAccent,
      ),
      body: petRecords.isEmpty
          ? Center(child: Text("No medical records found for this pet."))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: petRecords.length,
        itemBuilder: (context, index) {
          final record = petRecords[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Text("Date: ${record.date.toLocal().toString().split(' ')[0]}"),
                  if (record.diagnosis != null && record.diagnosis!.isNotEmpty)
                    Text("Diagnosis: ${record.diagnosis}"),
                  if (record.treatmentNotes != null && record.treatmentNotes!.isNotEmpty)
                    Text("Treatment Notes: ${record.treatmentNotes}"),
                  if (record.prescriptions != null && record.prescriptions!.isNotEmpty)
                    Text("Prescriptions: ${record.prescriptions}"),
                  if (record.uploadedFiles != null && record.uploadedFiles!.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: record.uploadedFiles!.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Image.file(
                              record.uploadedFiles![i],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
