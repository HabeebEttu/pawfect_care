import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/appointment.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAppointment(Appointment appointment) async {
    await _firestore
        .collection('appointments')
        .doc(appointment.id)
        .set(appointment.toMap());
  }

  Future<List<Appointment>> fetchAppointmentsForUser(String userId) async {
    final snapshot = await _firestore
        .collection('appointments')
        .where('ownerId', isEqualTo: userId)
        .orderBy('appointmentTime', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Appointment.fromMap(doc.data()))
        .toList();
  }

  Future<List<Appointment>> fetchAppointmentsForVet(String vetId) async {
    final snapshot = await _firestore
        .collection('appointments')
        .where('vetId', isEqualTo: vetId)
        .orderBy('appointmentTime', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Appointment.fromMap(doc.data()))
        .toList();
  }

  Future<void> updateAppointment(Appointment appointment) async {
    await _firestore
        .collection('appointments')
        .doc(appointment.id)
        .update(appointment.toMap());
  }

  Future<void> deleteAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).delete();
  }
}
