import 'package:pawfect_care/models/pet_store_item.dart';

class CartItem {
  final String id;
  final PetStoreItem item;
  int quantity;
  int get totalPrice => item.price * quantity;

  CartItem({
    required this.id,
    required this.item,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    PetStoreItem? item,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      item: PetStoreItem.fromMap(map['item'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.id == id &&
        other.item == item &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => id.hashCode ^ item.hashCode ^ quantity.hashCode;
}
