import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/models/pet_store_item.dart';
import 'package:pawfect_care/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    await _firestore.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<void> addPet(User user, Pet pet) async {
    await _firestore
        .collection('users')
        .doc(user.userId)
        .collection('pets')
        .doc(pet.petId)
        .set(pet.toMap());
  }

  Future<void> updatePet(User user, Pet pet) async {
    await _firestore
        .collection('users')
        .doc(user.userId)
        .collection('pets')
        .doc(pet.petId)
        .update(pet.toMap());
  }

  Future<User?> fetchUser(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return User.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.userId).update(user.toMap());
  }

  Future<void> deletePet(User user, Pet pet) async {
    await _firestore
        .collection('users')
        .doc(user.userId)
        .collection('pets')
        .doc(pet.petId)
        .delete();
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  Future<List<Pet>> fetchPets(String uid) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('pets')
        .get();
    return querySnapshot.docs.map((doc) => Pet.fromMap(doc.data())).toList();
  }

  Future<void> addToWishList(PetStoreItem item, User u) async {
    await _firestore
        .collection('users')
        .doc(u.userId)
        .collection('wishlist')
        .doc(item.id)
        .set(item.toMap());
  }

  Future<void> removeFromWishList(PetStoreItem item, User u) async {
    await _firestore
        .collection('users')
        .doc(u.userId)
        .collection('wishlist')
        .doc(item.id)
        .delete();  
  }
}
