class PetStoreItem {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String category;
  final int price;

const PetStoreItem({
  required this.id,
  required this.name,
  required this.imageUrl,
  required this.description,
  required this.category,
  required this.price
});

  factory PetStoreItem.fromMap(Map<String, dynamic> data, String documentId) {
    return PetStoreItem(
      id: documentId,
      name: data['name'],
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: data['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'category': category,
      'price': price,
    };
  }

}