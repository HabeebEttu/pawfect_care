
import 'package:flutter/material.dart';
import 'package:pawfect_care/models/adoption_record.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/services/adoption_service.dart';
import 'package:provider/provider.dart';

class AdoptionHistoryPage extends StatelessWidget {
  const AdoptionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Adoption History'),
        ),
        body: const Center(
          child: Text('Please log in to see your adoption history.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoption History'),
      ),
      body: FutureBuilder<List<AdoptionRecord>>(
        future: AdoptionService().getAdoptionRecordsForUser(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred while fetching your adoption history.'),
            );
          }

          final records = snapshot.data!;

          if (records.isEmpty) {
            return const Center(
              child: Text('You have no adoption records yet.'),
            );
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Pet ID: ${record.petId}'),
                  subtitle: Text('Adoption Date: ${record.adoptionDate}'),
                  trailing: Text(record.status.toString().split('.').last),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
