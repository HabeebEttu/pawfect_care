import 'package:flutter/material.dart';
import 'package:pawfect_care/providers/shelter_provider.dart';
import 'package:provider/provider.dart';

class EditAnimalShelterProfilePage extends StatefulWidget {
  const EditAnimalShelterProfilePage({super.key});

  @override
  _EditAnimalShelterProfilePageState createState() =>
      _EditAnimalShelterProfilePageState();
}

class _EditAnimalShelterProfilePageState
    extends State<EditAnimalShelterProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final shelter = Provider.of<ShelterProvider>(context, listen: false).shelter;
    _nameController = TextEditingController(text: shelter?.name);
    _phoneController = TextEditingController(text: shelter?.contactPhone);
    _emailController = TextEditingController(text: shelter?.contactEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Shelter Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final shelterProvider = Provider.of<ShelterProvider>(context, listen: false);
                    final updatedShelter = shelterProvider.shelter!.copyWith(
                      name: _nameController.text,
                      contactPhone: _phoneController.text,
                      contactEmail: _emailController.text,
                    );
                    shelterProvider.updateShelter(updatedShelter);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
