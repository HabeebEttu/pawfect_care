import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/models/cart_item.dart';
import 'package:pawfect_care/models/pet_store_item.dart';
import 'package:pawfect_care/services/pet_store_service.dart';

final petStoreServiceProvider = Provider((ref) => PetStoreService());

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final petStoreService = ref.watch(petStoreServiceProvider);
  return CartNotifier(petStoreService);
});

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  CartState({this.items = const [], this.isLoading = false, this.error});

  double get totalAmount =>
      items.fold(0.0, (sum, item) => sum + (item.item.price * item.quantity));
}

class CartNotifier extends StateNotifier<CartState> {
  final PetStoreService _petStoreService;

  CartNotifier(this._petStoreService) : super(CartState());

  Future<void> fetchCart(String userId) async {
    state = CartState(isLoading: true);
    try {
      final items = await _petStoreService.fetchCart(userId);
      state = CartState(items: items);
    } catch (e) {
      state = CartState(error: e.toString());
    }
  }

  Future<void> addToCart(String userId, CartItem item) async {
    state = CartState(isLoading: true, items: state.items);
    try {
      await _petStoreService.addToCart(userId, item);
      state = CartState(items: [...state.items, item]);
    } catch (e) {
      state = CartState(error: e.toString(), items: state.items);
    }
  }

  Future<void> removeFromCart(String userId, String itemId) async {
    state = CartState(isLoading: true, items: state.items);
    try {
      await _petStoreService.removeFromCart(userId, itemId);
      state = CartState(
        items: state.items.where((item) => item.id != itemId).toList(),
      );
    } catch (e) {
      state = CartState(error: e.toString(), items: state.items);
    }
  }

  Future<void> clearCart(String userId) async {
    state = CartState(isLoading: true, items: state.items);
    try {
      await _petStoreService.clearCart(userId);
      state = CartState();
    } catch (e) {
      state = CartState(error: e.toString(), items: state.items);
    }
  }

  Future<void> placeOrder(String userId, List<CartItem> items, double totalAmount) async {
    state = CartState(isLoading: true, items: state.items);
    try {
      await _petStoreService.placeOrder(userId, items, totalAmount);
      state = CartState();
    } catch (e) {
      state = CartState(error: e.toString(), items: state.items);
    }
  }
}

final productsProvider = FutureProvider<List<PetStoreItem>>((ref) async {
  final petStoreService = ref.watch(petStoreServiceProvider);
  return petStoreService.fetchProducts();
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final petStoreService = ref.watch(petStoreServiceProvider);
  return petStoreService.fetchCategories();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final filteredPetStoreProvider = Provider<AsyncValue<List<PetStoreItem>>>((
  ref,
) {
  final productsAsync = ref.watch(productsProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return productsAsync.when(
    data: (products) {
      List<PetStoreItem> filteredList = products.where((item) {
        final bool matchesCategory =
            selectedCategory == 'All' || item.category == selectedCategory;
        final bool matchesSearch =
            searchQuery.isEmpty ||
            item.name.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
      return AsyncValue.data(filteredList);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
