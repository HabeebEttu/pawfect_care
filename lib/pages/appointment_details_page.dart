import 'package:flutter/material.dart';
import '../models/appointment.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsPage({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedTime = appointment.appointmentTime != null
        ? '${appointment.appointmentTime!.day}-${appointment.appointmentTime!.month}-${appointment.appointmentTime!.year} '
        '${appointment.appointmentTime!.hour}:${appointment.appointmentTime!.minute.toString().padLeft(2, '0')}'
        : 'No Date Selected';

    return Scaffold(
      appBar: AppBar(title: Text('Appointment Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: ${appointment.service}',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Status: ${appointment.appointmentStatus.name}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Pet ID: ${appointment.petId}', style: TextStyle(fontSize: 16)),
            Text('Vet ID: ${appointment.vetId}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Date & Time: $formattedTime',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
            SizedBox(height: 12),
            Text('Notes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            SizedBox(height: 4),
            Text(
              appointment.notes ?? 'No notes provided',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
