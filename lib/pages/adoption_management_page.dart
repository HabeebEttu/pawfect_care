import 'package:flutter/material.dart';
import 'package:pawfect_care/models/adoption_record.dart';
import 'package:pawfect_care/models/adoption_status.dart';
import 'package:pawfect_care/providers/adoption_provider.dart';
import 'package:pawfect_care/providers/shelter_provider.dart';
import 'package:provider/provider.dart';

class AdoptionManagementPage extends StatefulWidget {
  const AdoptionManagementPage({super.key});

  @override
  State<AdoptionManagementPage> createState() => _AdoptionManagementPageState();
}

class _AdoptionManagementPageState extends State<AdoptionManagementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shelterProvider = Provider.of<ShelterProvider>(context, listen: false);
      if (shelterProvider.shelter != null) {
        Provider.of<AdoptionProvider>(context, listen: false).fetchAdoptionRecords(shelterProvider.shelter!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoption Management'),
      ),
      body: Consumer<AdoptionProvider>(
        builder: (context, adoptionProvider, child) {
          if (adoptionProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (adoptionProvider.adoptionRecords.isEmpty) {
            return const Center(child: Text('No adoption requests found.'));
          }

          return ListView.builder(
            itemCount: adoptionProvider.adoptionRecords.length,
            itemBuilder: (context, index) {
              final record = adoptionProvider.adoptionRecords[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('User: ${record.userId} - Pet: ${record.petId}'),
                  subtitle: Text('Status: ${record.status.toString().split('.').last}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (record.status == AdoptionStatus.pending) ...[
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () async {
                            final updatedRecord = record.copyWith(status: AdoptionStatus.approved);
                            final shelterId = Provider.of<ShelterProvider>(context, listen: false).shelter!.id;
                            await adoptionProvider.updateAdoptionRecordStatus(updatedRecord, shelterId);
                            await adoptionProvider.updatePetStatus(record.petId, shelterId);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () async {
                            final updatedRecord = record.copyWith(status: AdoptionStatus.rejected);
                            final shelterId = Provider.of<ShelterProvider>(context, listen: false).shelter!.id;
                            await adoptionProvider.updateAdoptionRecordStatus(updatedRecord, shelterId);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
