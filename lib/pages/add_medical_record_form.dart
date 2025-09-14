import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMedicalRecordForm extends StatefulWidget {
  const AddMedicalRecordForm({super.key});

  @override
  State<AddMedicalRecordForm> createState() => _AddMedicalRecordFormState();
}

class _AddMedicalRecordFormState extends State<AddMedicalRecordForm> {

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _submitRecord() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      await FirebaseFirestore.instance.collection('medical_records').add({
        'title': _title.text.trim(),
        'description': _description.text.trim(),
        'date': Timestamp.fromDate(_selectedDate!),
        'createdAt': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context); // Close form after saving
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Medical Record"), centerTitle: true,),
      body: Padding(
          padding: EdgeInsets.all(16),
         child: Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 TextFormField(

                   controller: _title,
                   decoration: InputDecoration(
                     labelText: 'Title',
                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide(color: Colors.blue, width: 1.5),
                     ),
                   ),

                   validator: (value) => value!.isEmpty ? 'Please enter title' : null,
                 ),
                 SizedBox(height: 10,),
                 TextFormField(
                   controller: _description,
                   decoration: InputDecoration(
                       labelText: 'Enter Description',
                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide(color: Colors.blue, width: 1.5),
                     ),
                   ),
                   validator: (value) => value!.isEmpty ? 'Please Enter Description' : null,
                 ),
                 SizedBox(height: 10,),
                 Row(
                   children: [
                     Text(_selectedDate == null ? 'No Date Selected' : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                     Spacer(),
                     TextButton(
                         onPressed: _pickDate,
                         child: Text("Select Date"))
                   ],
                 ),
                 Spacer(),
                 ElevatedButton(
                     onPressed: _submitRecord,
                     child: Text("Save Record"))
               ],
             )),
      ),
    );
  }
}
