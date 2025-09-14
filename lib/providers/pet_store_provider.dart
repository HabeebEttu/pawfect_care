
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pawfect_care/models/pet_store.dart';
import 'package:pawfect_care/services/pet_store_service.dart';

final petStoreServiceProvider = Provider<PetStoreService>((ref) {
  return PetStoreService();
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected category provider
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Categories provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.read(petStoreServiceProvider);
  final categories = await service.fetchCategories();
  return ['All', ...categories];
});

// filtered pet store provider
final filteredPetStoreProvider = FutureProvider<List<PetStore>>((ref) async {
  final service = ref.read(petStoreServiceProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);

  final products = await service.fetchProducts();

  return products.where((product) {
    final matchesCategory =
        selectedCategory == 'All' || product.category == selectedCategory;
    final matchesSearch = searchQuery.isEmpty ||
        product.name.toLowerCase().contains(searchQuery);
    return matchesCategory && matchesSearch;
  }).toList();
});
