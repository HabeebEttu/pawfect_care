import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/animal_shelter.dart';

class ShelterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new shelter
  Future<void> addShelter(AnimalShelter shelter) async {
    await _firestore
        .collection('shelters')
        .doc(shelter.id)
        .set(shelter.toMap());
  }

  Future<AnimalShelter?> getShelter(String shelterId) async {
    final doc = await _firestore.collection('shelters').doc(shelterId).get();
    if (doc.exists) {
      return AnimalShelter.fromMap(doc.data()!);
    }
    return null;
  }
}