import 'package:flutter/material.dart';
import 'package:pawfect_care/models/appointment.dart';
import 'package:pawfect_care/services/appointment_service.dart';

import 'package:pawfect_care/providers/auth_provider.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentService _appointmentService = AppointmentService();
  final AuthProvider _authProvider;

  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;

  AppointmentProvider(this._authProvider);

  List<Appointment> get appointments => _appointments;
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

  Future<void> fetchAppointmentsForUser() async {
    if (_authProvider.user == null) return;
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _appointments = await _appointmentService.fetchAppointmentsForUser(_authProvider.user!.uid);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAppointmentsForVet(String vetId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _appointments = await _appointmentService.fetchAppointmentsForVet(vetId);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    if (_authProvider.user == null) return;
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _appointmentService.addAppointment(appointment);
      await fetchAppointmentsForUser();
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    if (_authProvider.user == null) return;
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _appointmentService.updateAppointment(appointment);
      await fetchAppointmentsForUser();
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    if (_authProvider.user == null) return;
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _appointmentService.deleteAppointment(appointmentId);
      await fetchAppointmentsForUser();
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
