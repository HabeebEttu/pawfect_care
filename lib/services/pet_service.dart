
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/pet.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPet(String userId, Pet pet) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(pet.petId)
        .set(pet.toMap());
  }

  Future<void> updatePet(String userId, Pet pet) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(pet.petId)
        .update(pet.toMap());
  }

  Future<void> deletePet(String userId, String petId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .doc(petId)
        .delete();
  }

  Future<List<Pet>> fetchPets(String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('pets')
        .get();
    return querySnapshot.docs.map((doc) => Pet.fromMap(doc.data())).toList();
  }

  Future<Pet?> getPetById(String petId) async {
    // This assumes petId is unique across all users' pets.
    // A more robust solution might involve knowing the userId as well.
    // For now, we'll search all users' pet subcollections.
    final QuerySnapshot userDocs = await _firestore.collection('users').get();
    for (final userDoc in userDocs.docs) {
      final DocumentSnapshot petDoc = await _firestore
          .collection('users')
          .doc(userDoc.id)
          .collection('pets')
          .doc(petId)
          .get();
      if (petDoc.exists) {
        return Pet.fromMap(petDoc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }
}
