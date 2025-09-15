import 'package:flutter/material.dart';
import 'package:pawfect_care/models/appointment.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/models/status.dart';
import 'package:pawfect_care/providers/appointment_provider.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/providers/pet_provider.dart';
import 'package:provider/provider.dart';

class EditAppointmentPage extends StatefulWidget {
  final Appointment appointment;
  const EditAppointmentPage({super.key, required this.appointment});

  @override
  State<EditAppointmentPage> createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  Pet? _selectedPet;
  late TextEditingController _vetNameController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TextEditingController _serviceController;
  late TextEditingController _notesController;
  late Status _appointmentStatus;

  @override
  void initState() {
    super.initState();
    _selectedPet = null; // Will be set from petProvider.pets
    _vetNameController = TextEditingController(text: widget.appointment.vetId);
    _selectedDate = widget.appointment.appointmentTime ?? DateTime.now();
    _selectedTime = TimeOfDay.fromDateTime(widget.appointment.appointmentTime ?? DateTime.now());
    _serviceController = TextEditingController(text: widget.appointment.service);
    _notesController = TextEditingController(text: widget.appointment.notes);
    _appointmentStatus = widget.appointment.appointmentStatus;
  }

  @override
  void dispose() {
    _vetNameController.dispose();
    _serviceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final petProvider = Provider.of<PetProvider>(context);
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    // Set selected pet based on the appointment's petId
    if (_selectedPet == null && petProvider.pets.isNotEmpty) {
      _selectedPet = petProvider.pets.firstWhere(
        (pet) => pet.petId == widget.appointment.petId,
        orElse: () => petProvider.pets.first, // Fallback if pet not found
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Pet>(
                decoration: const InputDecoration(labelText: 'Select Pet'),
                value: _selectedPet,
                items: petProvider.pets.map((pet) {
                  return DropdownMenuItem<Pet>(
                    value: pet,
                    child: Text(pet.name),
                  );
                }).toList(),
                onChanged: (Pet? newValue) {
                  setState(() {
                    _selectedPet = newValue;
                  }
                  );
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a pet';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vetNameController,
                decoration: const InputDecoration(labelText: 'Vet Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vet name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Date: ${_selectedDate.toLocal().toShortDateString()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Time: ${_selectedTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _serviceController,
                decoration: const InputDecoration(labelText: 'Service'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes (Optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Status>(
                decoration: const InputDecoration(labelText: 'Appointment Status'),
                value: _appointmentStatus,
                items: Status.values.map((status) {
                  return DropdownMenuItem<Status>(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (Status? newValue) {
                  setState(() {
                    _appointmentStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final appointmentDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );

                    final updatedAppointment = widget.appointment.copyWith(
                      petId: _selectedPet!.petId,
                      vetId: _vetNameController.text,
                      appointmentTime: appointmentDateTime,
                      appointmentStatus: _appointmentStatus,
                      service: _serviceController.text,
                      notes: _notesController.text.isEmpty ? null : _notesController.text,
                    );

                    try {
                      await appointmentProvider.updateAppointment(updatedAppointment);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Appointment updated successfully!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update appointment: $e')),
                      );
                    }
                  }
                },
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await appointmentProvider.deleteAppointment(widget.appointment.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Appointment deleted successfully!')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete appointment: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on DateTime {
  String toShortDateString() {
    return '${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}
