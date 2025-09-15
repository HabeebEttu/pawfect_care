import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/medical_records.dart';

class MedicalRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMedicalRecord(String userId, String petId, MedicalRecord record) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(petId)
        .collection('medical_records')
        .doc(record.id)
        .set(record.toMap());
  }

  Future<List<MedicalRecord>> fetchMedicalRecords(String userId, String petId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(petId)
        .collection('medical_records')
        .get();

    return snapshot.docs
        .map((doc) => MedicalRecord.fromMap(doc.data()))
        .toList();
  }

  Future<void> updateMedicalRecord(String userId, String petId, MedicalRecord record) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(petId)
        .collection('medical_records')
        .doc(record.id)
        .update(record.toMap());
  }

  Future<void> deleteMedicalRecord(String userId, String petId, String recordId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(petId)
        .collection('medical_records')
        .doc(recordId)
        .delete();
  }
}
