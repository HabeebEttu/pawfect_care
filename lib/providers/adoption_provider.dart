import 'package:flutter/material.dart';
import 'package:pawfect_care/models/adoption_record.dart';
import 'package:pawfect_care/services/adoption_service.dart';

class AdoptionProvider with ChangeNotifier {
  final AdoptionService _adoptionService = AdoptionService();

  List<AdoptionRecord> _adoptionRecords = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AdoptionRecord> get adoptionRecords => _adoptionRecords;
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

  Future<void> fetchAdoptionRecords(String shelterId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _adoptionRecords = await _adoptionService.getAdoptionRecords(shelterId);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createAdoptionRecord(AdoptionRecord record, String shelterId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _adoptionService.createAdoptionRecord(record, shelterId);
      await fetchAdoptionRecords(shelterId); // Refresh list
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateAdoptionRecordStatus(AdoptionRecord record, String shelterId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      // Assuming AdoptionService has an update method for status
      // For now, we'll just re-create the record with updated status
      // In a real app, you'd have a dedicated update method in the service
      await _adoptionService.createAdoptionRecord(record, shelterId); // Overwrites existing
      await fetchAdoptionRecords(shelterId); // Refresh list
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePetStatus(String petId, String shelterId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _adoptionService.updatePetStatus(petId, shelterId);
      // No need to fetch adoption records here, as pet status is separate
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
