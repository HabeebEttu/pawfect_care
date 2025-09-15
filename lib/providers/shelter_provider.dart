import 'package:flutter/widgets.dart';
import 'package:pawfect_care/models/animal_shelter.dart';
import 'package:pawfect_care/models/role.dart';
import 'package:pawfect_care/models/user.dart';
import 'package:pawfect_care/services/shelter_service.dart';

class ShelterProvider with ChangeNotifier {
  final ShelterService _shelterService = ShelterService();

  bool _isLoading = false;
  String? _errorMessage;
  AnimalShelter? _shelter;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AnimalShelter? get shelter => _shelter;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setShelter(AnimalShelter? shelter) {
    _shelter = shelter;
    notifyListeners();
  }

  Future<void> addShelter(AnimalShelter shelter, User user) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      if (user.role != Role.shelter) {
        throw Exception('Only users with the shelter role can add a shelter.');
      }
      await _shelterService.addShelter(shelter);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getShelter(String shelterId) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final shelter = await _shelterService.getShelter(shelterId);
      _setShelter(shelter);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateShelter(AnimalShelter shelter) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _shelterService.updateShelter(shelter);
      _setShelter(shelter);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
