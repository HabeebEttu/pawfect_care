import 'package:flutter/material.dart';
import 'package:pawfect_care/models/cart.dart';
import 'package:pawfect_care/models/cart_item.dart';
import 'package:pawfect_care/models/pet_store_item.dart';
import 'package:pawfect_care/services/pet_store_service.dart';
import 'package:pawfect_care/providers/auth_provider.dart';

class PetStoreProvider extends ChangeNotifier {
  final PetStoreService _petStoreService = PetStoreService();
  final AuthProvider _authProvider;

  List<PetStoreItem> _products = [];
  List<String> _categories = [];
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  PetStoreProvider(this._authProvider) {
    fetchProducts();
    fetchCategories();
    if (_authProvider.user != null) {
      fetchCart(_authProvider.user!.uid);
    }
  }

  List<PetStoreItem> get products => _products;
  List<String> get categories => _categories;
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _products = await _petStoreService.fetchProducts();
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _categories = await _petStoreService.fetchCategories();
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addProduct(PetStoreItem item) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _petStoreService.addProduct(item);
      await fetchProducts(); // Refresh products
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProduct(PetStoreItem item) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _petStoreService.updateProduct(item);
      await fetchProducts(); // Refresh products
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteProduct(String itemId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _petStoreService.deleteProduct(itemId);
      await fetchProducts(); // Refresh products
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCart(String userId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _cartItems = await _petStoreService.getCart(userId);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addToCart(String userId, CartItem item) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _petStoreService.addToCart(userId, item);
      await fetchCart(userId); // Refresh cart
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _petStoreService.removeFromCart(userId, productId);
      await fetchCart(userId); // Refresh cart
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearCart(String userId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _petStoreService.clearCart(userId);
      await fetchCart(userId); // Clear cart locally
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> placeOrder(String userId, List<CartItem> items, double totalAmount) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _petStoreService.placeOrder(userId, items, totalAmount);
      await fetchCart(userId); // Clear cart after order
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}