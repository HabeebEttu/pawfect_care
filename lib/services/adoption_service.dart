import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/adoption_record.dart';

class AdoptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAdoptionRecord(
    AdoptionRecord record,
    String shelterId,
  ) async {
    await _firestore
        .collection('shelters')
        .doc(shelterId)
        .collection('adoption_record')
        .doc(record.adoptionId)
        .set(record.toMap());
  }

  Future<void> updatePetStatus(String petId, String shelterId) async {
    await _firestore.collection('shelters').doc(shelterId).collection('pets').doc(petId).delete();
  }

  Future<List<AdoptionRecord>> getAdoptionRecords(String userId) async {
    final snapshot = await _firestore
        .collection('adoption_records')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => AdoptionRecord.fromMap(doc.data()))
        .toList();
  }
}
