import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/cart_item.dart';
import 'package:pawfect_care/models/pet_store_item.dart';
import 'package:pawfect_care/models/cart.dart';

class PetStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Product Management
  Future<void> addProduct(PetStoreItem item) async {
    await _db.collection('products').doc(item.id).set(item.toMap());
  }

  Future<void> updateProduct(PetStoreItem item) async {
    await _db.collection('products').doc(item.id).update(item.toMap());
  }

  Future<void> deleteProduct(String itemId) async {
    await _db.collection('products').doc(itemId).delete();
  }

  Future<List<PetStoreItem>> fetchProducts() async {
    final snapshot = await _db.collection('products').get();
    return snapshot.docs
        .map((doc) => PetStoreItem.fromMap(doc.data()))
        .toList();
  }

  Future<List<String>> fetchCategories() async {
    final items = await fetchProducts();
    return items.map((item) => item.category)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();
  }

  // Cart Management
  Future<void> addToCart(String userId, CartItem item) async {
    await _db.collection('users').doc(userId).collection('cart').doc(item.id).set(item.toMap());
  }

  Future<void> removeFromCart(String userId, String productId) async {
    await _db.collection('users').doc(userId).collection('cart').doc(productId).delete();
  }

  Future<List<CartItem>> getCart(String userId) async {
    final snapshot = await _db.collection('users').doc(userId).collection('cart').get();
    return snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();
  }

  Future<void> clearCart(String userId) async {
    final batch = _db.batch();
    final snapshot = await _db.collection('users').doc(userId).collection('cart').get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // Order Management (Placeholder - more complex in real app)
  Future<void> placeOrder(String userId, List<CartItem> items, double totalAmount) async {
    
    await _db.collection('orders').add({
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'orderDate': Timestamp.now(),
      'status': 'pending',
    });
    await clearCart(userId);
  }

  Future<List<Map<String, dynamic>>> fetchOrders(String userId) async {
    final snapshot = await _db.collection('orders').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
