import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/pet_store_item.dart';
import 'package:pawfect_care/models/user.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<List<PetStoreItem>> fetchWishList(User u) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(u.userId)
        .collection('wishlist')
        .get();

    return snapshot.docs
        .map((doc) => PetStoreItem.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> clearWishList(User u) async {
    WriteBatch batch = _firestore.batch();

    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(u.userId)
        .collection('wishlist')
        .get();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

}
