import 'package:flutter/material.dart';
import 'package:pawfect_care/models/appointment.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/models/status.dart';
import 'package:pawfect_care/providers/appointment_provider.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/providers/pet_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  Pet? _selectedPet;
  String? _vetName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _service;
  String? _notes;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final petProvider = Provider.of<PetProvider>(context);
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    if (authProvider.user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Book Appointment'),
        ),
        body: const Center(
          child: Text('Please log in to book an appointment.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
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
                  });
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
                decoration: const InputDecoration(labelText: 'Vet Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vet name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _vetName = value;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${_selectedDate!.toLocal().toShortDateString()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_selectedTime == null
                    ? 'Select Time'
                    : 'Time: ${_selectedTime!.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime ?? TimeOfDay.now(),
                  );
                  if (picked != null && picked != _selectedTime) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Service'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _service = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes (Optional)'),
                maxLines: 3,
                onSaved: (value) {
                  _notes = value;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (_selectedDate == null || _selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select date and time.')),
                      );
                      return;
                    }

                    final appointmentDateTime = DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      _selectedTime!.hour,
                      _selectedTime!.minute,
                    );

                    final newAppointment = Appointment(
                      id: const Uuid().v4(),
                      petId: _selectedPet!.petId,
                      vetId: _vetName!,
                      ownerId: authProvider.user!.uid,
                      appointmentTime: appointmentDateTime,
                      appointmentStatus: Status.PENDING,
                      service: _service!,
                      notes: _notes,
                    );

                    try {
                      await appointmentProvider.addAppointment(newAppointment);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Appointment booked successfully!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to book appointment: $e')),
                      );
                    }
                  }
                },
                child: const Text('Book Appointment'),
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
