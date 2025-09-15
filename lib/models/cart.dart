import 'package:pawfect_care/models/cart_item.dart';
import 'package:pawfect_care/models/pet_store_item.dart';

class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get totalAmount =>
      items.fold(0, (total, item) => total + item.totalPrice);

  int get totalItems => items.fold(0, (total, item) => total + item.quantity);

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  Cart copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Cart addItem(PetStoreItem storeItem) {
    final existingIndex = items.indexWhere(
      (item) => item.item.id == storeItem.id,
    );

    if (existingIndex >= 0) {
      // Item already exists, increment quantity
      final updatedItems = [...items];
      updatedItems[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + 1,
      );

      return copyWith(items: updatedItems, updatedAt: DateTime.now());
    } else {
      // Add new item
      return copyWith(
        items: [
          ...items,
          CartItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            item: storeItem,
            quantity: 1,
          ),
        ],
        updatedAt: DateTime.now(),
      );
    }
  }

  Cart removeItem(String itemId) {
    return copyWith(
      items: items.where((item) => item.id != itemId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  Cart updateItemQuantity(String itemId, int quantity) {
    return copyWith(
      items: items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(quantity: quantity);
        }
        return item;
      }).toList(),
      updatedAt: DateTime.now(),
    );
  }

  Cart clear() {
    return copyWith(items: [], updatedAt: DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] as String,
      userId: map['userId'] as String,
      items: (map['items'] as List<dynamic>)
          .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  factory Cart.empty(String userId) {
    final now = DateTime.now();
    return Cart(
      id: now.millisecondsSinceEpoch.toString(),
      userId: userId,
      items: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cart &&
        other.id == id &&
        other.userId == userId &&
        other.items == items &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        items.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
