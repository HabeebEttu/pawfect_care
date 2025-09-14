import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPatientRecordsForm extends StatefulWidget {
  const MyPatientRecordsForm({super.key});

  @override
  State<MyPatientRecordsForm> createState() => _MyPatientRecordsFormState();
}

class _MyPatientRecordsFormState extends State<MyPatientRecordsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;


  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('patients').add({
        'petName': _petNameController.text.trim(),
        'ownerName': _ownerNameController.text.trim(),
        'species': _speciesController.text.trim(),
        'notes': _notesController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient record added successfully')),
        );
        Navigator.pop(context); // Go back after saving
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding patient: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Patient Record")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pet Name"),
                TextFormField(
                  controller: _petNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    border: OutlineInputBorder(),
                    hintText: 'Enter pet name',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Pet name required' : null,
                ),
                SizedBox(height: 16),

                Text("Owner Name"),
                TextFormField(
                  controller: _ownerNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    border: OutlineInputBorder(),
                    hintText: 'Enter owner name',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Owner name required' : null,
                ),
                SizedBox(height: 16),

                Text("Species"),
                TextFormField(
                  controller: _speciesController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Dog, Cat',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Species required' : null,
                ),
                SizedBox(height: 16),

                Text("Notes (Optional)"),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    border: OutlineInputBorder(),
                    hintText: 'Additional notes',
                  ),
                ),
                SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _savePatient,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Save Record"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
