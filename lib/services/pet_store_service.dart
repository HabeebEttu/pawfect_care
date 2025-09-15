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

  Future<List<CartItem>> fetchCart(String userId) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      final products = await fetchProducts(); // Fetch all products to ensure we have latest data
      
      return snapshot.docs.map((doc) {
        final cartItem = CartItem.fromMap(doc.data());
        // Find the corresponding product to ensure we have the latest product data
        final updatedProduct = products.firstWhere(
          (p) => p.id == cartItem.item.id,
          orElse: () => cartItem.item,
        );
        // Return updated cart item with latest product data
        return CartItem(
          id: cartItem.id,
          item: updatedProduct,
          quantity: cartItem.quantity,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch cart: $e');
    }
  }

  // Keep the old method name as a deprecated alias for backward compatibility
  @deprecated
  Future<List<CartItem>> getCart(String userId) => fetchCart(userId);

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
