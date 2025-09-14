import 'package:flutter/material.dart';
import 'package:pawfect_care/models/pet.dart';

class PetProvider extends ChangeNotifier {
  final List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  void addPet(Pet pet) {
    _pets.add(pet);
    notifyListeners();
  }
}
