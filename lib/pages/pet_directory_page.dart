import 'package:flutter/material.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/providers/pet_provider.dart';
import 'package:pawfect_care/pages/edit_pet_profile_page.dart';
import 'package:provider/provider.dart';

class PetDirectoryPage extends StatelessWidget {
  const PetDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Pets'),
      ),
      body: Consumer<PetProvider>(
        builder: (context, petProvider, child) {
          if (petProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (petProvider.pets.isEmpty) {
            return const Center(child: Text('No pets found.'));
          }

          return ListView.builder(
            itemCount: petProvider.pets.length,
            itemBuilder: (context, index) {
              final pet = petProvider.pets[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(pet.photoUrl),
                  ),
                  title: Text(pet.name),
                  subtitle: Text('${pet.species} - ${pet.breed}'),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPetProfilePage(pet: pet),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
