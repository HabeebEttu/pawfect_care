import 'package:flutter/material.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/models/medical_records.dart';
import 'package:pawfect_care/providers/medical_record_provider.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:pawfect_care/pages/add_edit_medical_record_page.dart';

class MedicalRecordsHistoryPage extends StatefulWidget {
  final Pet pet;
  const MedicalRecordsHistoryPage({super.key, required this.pet});

  @override
  State<MedicalRecordsHistoryPage> createState() => _MedicalRecordsHistoryPageState();
}

class _MedicalRecordsHistoryPageState extends State<MedicalRecordsHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        Provider.of<MedicalRecordProvider>(context, listen: false).fetchMedicalRecords(widget.pet.petId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final medicalRecordProvider = Provider.of<MedicalRecordProvider>(context);

    if (authProvider.user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Medical Records for ${widget.pet.name}'),
        ),
        body: const Center(
          child: Text('Please log in to view medical records.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Records for ${widget.pet.name}'),
      ),
      body: medicalRecordProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : medicalRecordProvider.medicalRecords.isEmpty
              ? const Center(child: Text('No medical records found.'))
              : ListView.builder(
                  itemCount: medicalRecordProvider.medicalRecords.length,
                  itemBuilder: (context, index) {
                    final record = medicalRecordProvider.medicalRecords[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(record.title),
                        subtitle: Text(record.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await medicalRecordProvider.deleteMedicalRecord(
                              widget.pet.petId,
                              record.id,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Medical record deleted.')),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditMedicalRecordPage(
                                pet: widget.pet,
                                medicalRecord: record,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditMedicalRecordPage(pet: widget.pet),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
