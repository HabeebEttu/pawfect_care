import 'package:flutter/material.dart';
import 'package:pawfect_care/models/medical_records.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/providers/medical_record_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEditMedicalRecordPage extends StatefulWidget {
  final Pet pet;
  final MedicalRecord? medicalRecord;

  const AddEditMedicalRecordPage({super.key, required this.pet, this.medicalRecord});

  @override
  State<AddEditMedicalRecordPage> createState() => _AddEditMedicalRecordPageState();
}

class _AddEditMedicalRecordPageState extends State<AddEditMedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _diagnosisController;
  late TextEditingController _treatmentNotesController;
  late TextEditingController _prescriptionsController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.medicalRecord?.title);
    _descriptionController = TextEditingController(text: widget.medicalRecord?.description);
    _diagnosisController = TextEditingController(text: widget.medicalRecord?.diagnosis);
    _treatmentNotesController = TextEditingController(text: widget.medicalRecord?.treatmentNotes);
    _prescriptionsController = TextEditingController(text: widget.medicalRecord?.prescriptions);
    _selectedDate = widget.medicalRecord?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _diagnosisController.dispose();
    _treatmentNotesController.dispose();
    _prescriptionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final medicalRecordProvider = Provider.of<MedicalRecordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicalRecord == null ? 'Add Medical Record' : 'Edit Medical Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diagnosisController,
                decoration: const InputDecoration(labelText: 'Diagnosis'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _treatmentNotesController,
                decoration: const InputDecoration(labelText: 'Treatment Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prescriptionsController,
                decoration: const InputDecoration(labelText: 'Prescriptions'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Date: ${_selectedDate.toLocal().toShortDateString()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newRecord = MedicalRecord(
                      id: widget.medicalRecord?.id ?? const Uuid().v4(),
                      petId: widget.pet.petId,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      date: _selectedDate,
                      diagnosis: _diagnosisController.text.isEmpty ? null : _diagnosisController.text,
                      treatmentNotes: _treatmentNotesController.text.isEmpty ? null : _treatmentNotesController.text,
                      prescriptions: _prescriptionsController.text.isEmpty ? null : _prescriptionsController.text,
                    );

                    try {
                      if (widget.medicalRecord == null) {
                        await medicalRecordProvider.addMedicalRecord(
                          widget.pet.petId,
                          newRecord,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Medical record added successfully!')),
                        );
                      } else {
                        await medicalRecordProvider.updateMedicalRecord(
                          widget.pet.petId,
                          newRecord,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Medical record updated successfully!')),
                        );
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save medical record: $e')),
                      );
                    }
                  }
                },
                child: Text(widget.medicalRecord == null ? 'Add Record' : 'Save Changes'),
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
