import 'package:flutter/material.dart';
import 'package:pawfect_care/models/medical_records.dart';
import 'package:pawfect_care/services/medical_record_service.dart';

import 'package:pawfect_care/providers/auth_provider.dart';

class MedicalRecordProvider extends ChangeNotifier {
  final MedicalRecordService _medicalRecordService = MedicalRecordService();
  final AuthProvider _authProvider;

  List<MedicalRecord> _medicalRecords = [];
  bool _isLoading = false;
  String? _errorMessage;

  MedicalRecordProvider(this._authProvider);

  List<MedicalRecord> get medicalRecords => _medicalRecords;
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

  Future<void> fetchMedicalRecords(String petId) async {
    if (_authProvider.user == null) return;
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _medicalRecords = await _medicalRecordService.fetchMedicalRecords(_authProvider.user!.uid, petId);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addMedicalRecord(String petId, MedicalRecord record) async {
    if (_authProvider.user == null) return;
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _medicalRecordService.addMedicalRecord(_authProvider.user!.uid, petId, record);
      await fetchMedicalRecords(petId); // Refresh list
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateMedicalRecord(String petId, MedicalRecord record) async {
    if (_authProvider.user == null) return;
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _medicalRecordService.updateMedicalRecord(_authProvider.user!.uid, petId, record);
      await fetchMedicalRecords(petId); // Refresh list
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteMedicalRecord(String petId, String recordId) async {
    if (_authProvider.user == null) return;
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _medicalRecordService.deleteMedicalRecord(_authProvider.user!.uid, petId, recordId);
      await fetchMedicalRecords(petId); // Refresh list
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
