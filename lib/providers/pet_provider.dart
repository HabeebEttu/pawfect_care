import 'package:flutter/material.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/services/pet_service.dart';

class PetProvider extends ChangeNotifier {
  final PetService _petService = PetService();
  final AuthProvider _authProvider;

  List<Pet> _pets = [];
  bool _isLoading = false;

  PetProvider(this._authProvider) {
    _loadPets();
  }

  List<Pet> get pets => _pets;
  bool get isLoading => _isLoading;

  Future<void> _loadPets() async {
    if (_authProvider.user != null) {
      _setLoading(true);
      _pets = await _petService.fetchPets(_authProvider.user!.uid);
      _setLoading(false);
    }
  }

  Future<void> loadUserPets() async {
    await _loadPets();
  }

  Future<void> addPet(Pet pet) async {
    if (_authProvider.user != null) {
      _setLoading(true);
      await _petService.addPet(_authProvider.user!.uid, pet);
      await _loadPets();
      _setLoading(false);
    }
  }

  Future<void> updatePet(Pet pet) async {
    if (_authProvider.user != null) {
      _setLoading(true);
      await _petService.updatePet(_authProvider.user!.uid, pet);
      await _loadPets();
      _setLoading(false);
    }
  }

  Future<void> deletePet(String petId) async {
    if (_authProvider.user != null) {
      _setLoading(true);
      await _petService.deletePet(_authProvider.user!.uid, petId);
      await _loadPets();
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}