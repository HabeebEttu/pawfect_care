import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../models/status.dart';
import '../services/vet_service.dart';

class VetProvider with ChangeNotifier {
  final VetService _vetService = VetService();

  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _error;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch today's appointments for a given vet
  Future<void> fetchTodayAppointments(String vetId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // ✅ Pass vetId directly to service
      _appointments = await _vetService.fetchTodayAppointments(vetId);
    } catch (e) {
      _error = 'Failed to load appointments: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update appointment status and refresh local state
  Future<void> updateAppointmentStatus(
      String appointmentId, Status status) async {
    try {
      await _vetService.updateAppointmentStatus(appointmentId, status);

      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] =
            _appointments[index].copyWith(appointmentStatus: status);
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update status: $e';
      notifyListeners();
    }
  }

  /// Reschedule an appointment and refresh local state
  Future<void> rescheduleAppointment(
      String appointmentId, DateTime newTime) async {
    try {
      await _vetService.rescheduleAppointment(appointmentId, newTime);

      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(
          appointmentTime: newTime,
          appointmentStatus: Status.RESCHEDULED,
        );
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to reschedule: $e';
      notifyListeners();
    }
  }

  /// Filter appointments by status
  List<Appointment> filterByStatus(Status status) {
    return _appointments.where((a) => a.appointmentStatus == status).toList();
  }

  /// Filter appointments by date range
  List<Appointment> filterByDateRange(DateTime start, DateTime end) {
    return _appointments.where((a) {
      final time = a.appointmentTime;
      return time != null && time.isAfter(start) && time.isBefore(end);
    }).toList();
  }

  /// Clear local data (e.g., on logout)
  void clearAppointments() {
    _appointments = [];
    notifyListeners();
  }
}
