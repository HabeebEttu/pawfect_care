import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMedicalRecordForm extends StatefulWidget {
  const AddMedicalRecordForm({Key? key}) : super(key: key);

  @override
  State<AddMedicalRecordForm> createState() => _AddMedicalRecordFormState();
}

class _AddMedicalRecordFormState extends State<AddMedicalRecordForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _petIdController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentNotesController = TextEditingController();
  final TextEditingController _prescriptionsController = TextEditingController();

  DateTime? _selectedDate;
  List<File> _uploadedFiles = [];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickFiles() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(); // multiple image support
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _uploadedFiles.addAll(pickedFiles.map((x) => File(x.path)));
      });
    }
  }

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a date.')),
        );
        return;
      }

      final petId = _petIdController.text.trim();
      if (petId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a pet ID.')),
        );
        return;
      }

      // Placeholder for saving the record
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Record "${_titleController.text}" saved for pet $petId (placeholder).'),
        ),
      );

      // Clear form
      _formKey.currentState!.reset();
      setState(() {
        _uploadedFiles.clear();
        _selectedDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Medical Record"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Pet ID input
              TextFormField(
                controller: _petIdController,
                decoration: InputDecoration(
                  labelText: 'Pet ID',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter a Pet ID' : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Record Title',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _diagnosisController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Diagnosis',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _treatmentNotesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Treatment Notes',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _prescriptionsController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Prescriptions',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _pickFiles,
                icon: Icon(Icons.upload_file),
                label: Text('Upload Files/Images'),
              ),
              SizedBox(height: 8),

              if (_uploadedFiles.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _uploadedFiles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Image.file(
                          _uploadedFiles[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _saveRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Save Record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
