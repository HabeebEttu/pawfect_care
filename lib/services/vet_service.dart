import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment.dart';
import '../models/status.dart';

class VetService {
  final _firestore = FirebaseFirestore.instance;

  /// Stream of all appointments (real-time updates)
  Stream<List<Appointment>> getAppointmentsStream() {
    return _firestore.collection('appointments').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Appointment.fromMap(doc.data()))
          .toList();
    });
  }

  /// Fetch only today's appointments for a specific vet (one-time fetch)
  Future<List<Appointment>> fetchTodayAppointments(String vetId) async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('appointments')
        .where('veterinarianId', isEqualTo: vetId)
        .where('dateTime', isGreaterThanOrEqualTo: start)
        .where('dateTime', isLessThan: end)
        .get();

    return snapshot.docs
        .map((doc) => Appointment.fromMap(doc.data()))
        .toList();
  }

  /// Update appointment status (Accept or Decline)
  Future<void> updateAppointmentStatus(
      String appointmentId, Status status) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'appointmentStatus': status.name, // ✅ store as string
    });
  }

  /// Reschedule appointment with a new time
  Future<void> rescheduleAppointment(
      String appointmentId, DateTime newTime) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'dateTime': newTime, // ✅ keep field name consistent
      'appointmentStatus': Status.RESCHEDULED, // ✅ use .name
    });
  }

  Future<List<DateTime>> getAvailableSlots(String vetId) async {
    // In a real app, you would fetch this from a database.
    // For now, we'll return a static list.
    return [
      DateTime.now().add(Duration(hours: 2)),
      DateTime.now().add(Duration(days: 1, hours: 3)),
      DateTime.now().add(Duration(days: 2, hours: 5)),
    ];
  }
}
