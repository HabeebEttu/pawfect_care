import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/status.dart';
import '../models/appointment.dart';

class AddAppointmentForm extends StatefulWidget {
  const AddAppointmentForm({Key? key}) : super(key: key);

  @override
  State<AddAppointmentForm> createState() => _AddAppointmentFormState();
}

class _AddAppointmentFormState extends State<AddAppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _petIdController = TextEditingController();
  final TextEditingController _vetIdController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _selectedDateTime;
  Status _selectedStatus = Status.PENDING;

  Future<void> _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year, date.month, date.day, time.hour, time.minute,
          );
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      try {
        final docRef = FirebaseFirestore.instance.collection('appointments').doc();
        Appointment appointment = Appointment(
          appointmentId: docRef.id,
          petId: _petIdController.text.trim(),
          vetId: _vetIdController.text.trim(),
          appointmentTime: _selectedDateTime,
          appointmentStatus: _selectedStatus,
          notes: _notesController.text.trim(),
          service: _serviceController.text.trim(),
        );

        await docRef.set({
          'appointmentId': appointment.appointmentId,
          'petId': appointment.petId,
          'vetId': appointment.vetId,
          'appointmentTime': appointment.appointmentTime,
          'appointmentStatus': appointment.appointmentStatus.toString().split('.').last,
          'notes': appointment.notes,
          'service': appointment.service,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Appointment added successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add appointment: $e")),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Appointment")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _petIdController,
                decoration: _inputDecoration("Pet ID"),
                validator: (val) => val == null || val.isEmpty ? "Enter Pet ID" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _vetIdController,
                decoration: _inputDecoration("Vet ID"),
                validator: (val) => val == null || val.isEmpty ? "Enter Vet ID" : null,
              ),
              SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _selectedDateTime == null
                      ? "Select Date & Time"
                      : "Date: ${_selectedDateTime!.toLocal().toString().substring(0, 16)}",
                ),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickDateTime,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _serviceController,
                decoration: _inputDecoration("Service"),
                validator: (val) => val == null || val.isEmpty ? "Enter Service" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: _inputDecoration("Notes"),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Status>(
                decoration: _inputDecoration("Status"),
                value: _selectedStatus,
                items: Status.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedStatus = val!),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text("Save Appointment"),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
