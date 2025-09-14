import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/pet_store_item.dart';

class PetStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<PetStoreItem>> fetchProducts() async {
    final snapshot = await _db.collection('products').get();
    return snapshot.docs
        .map((doc) => PetStoreItem.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<String>> fetchCategories() async {
    final items = await fetchProducts();
    return items.map((item) => item.category)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();
  }

}