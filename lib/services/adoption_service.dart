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
    await _firestore.collection('shelters').doc(shelterId).collection('pets').doc(petId).update({'shelterId': null});
  }

  Future<List<AdoptionRecord>> getAdoptionRecords(String shelterId) async {
    final snapshot = await _firestore
        .collection('shelters')
        .doc(shelterId)
        .collection('adoption_record')
        .get();

    return snapshot.docs
        .map((doc) => AdoptionRecord.fromMap(doc.data()))
        .toList();
  }

  Future<List<AdoptionRecord>> getAdoptionRecordsForUser(String userId) async {
    List<AdoptionRecord> userRecords = [];
    final sheltersSnapshot = await _firestore.collection('shelters').get();

    for (var shelterDoc in sheltersSnapshot.docs) {
      final adoptionRecordsSnapshot = await _firestore
          .collection('shelters')
          .doc(shelterDoc.id)
          .collection('adoption_record')
          .where('userId', isEqualTo: userId) // Assuming AdoptionRecord has a userId field
          .get();

      userRecords.addAll(adoptionRecordsSnapshot.docs
          .map((doc) => AdoptionRecord.fromMap(doc.data()))
          .toList());
    }
    return userRecords;
  }
}
