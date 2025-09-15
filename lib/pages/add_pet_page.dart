import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawfect_care/models/gender.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/providers/pet_provider.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/services/supabase_storage_service.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _species;
  String? _breed;
  int? _age;
  String? _description;
  File? _photo;
  Gender _gender = Gender.male;
  bool _isVaccinated = false;
  bool _isSpayed = false;
  bool _isNeutered = false;
  bool _isSpecialNeeds = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: _photo != null ? FileImage(_photo!) : null,
                      child: _photo == null
                          ? const Icon(
                              Icons.pets,
                              size: 80,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Species'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a species';
                  }
                  return null;
                },
                onSaved: (value) {
                  _species = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Breed'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a breed';
                  }
                  return null;
                },
                onSaved: (value) {
                  _breed = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.tryParse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              DropdownButtonFormField<Gender>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: Gender.values.map((Gender gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(gender.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (Gender? newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Vaccinated'),
                value: _isVaccinated,
                onChanged: (bool? value) {
                  setState(() {
                    _isVaccinated = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Spayed'),
                value: _isSpayed,
                onChanged: (bool? value) {
                  setState(() {
                    _isSpayed = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Neutered'),
                value: _isNeutered,
                onChanged: (bool? value) {
                  setState(() {
                    _isNeutered = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Special Needs'),
                value: _isSpecialNeeds,
                onChanged: (bool? value) {
                  setState(() {
                    _isSpecialNeeds = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Pet',style: PawfectCareTheme.bodyMedium.copyWith(
                  color: Colors.white,
                ),),
                onPressed: ()async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final petProvider = Provider.of<PetProvider>(context, listen: false);
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);

                    if (authProvider.user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User not logged in.')),
                      );
                      return;
                    }

                    String photoUrl = '';
                    if (_photo != null) {
                      try {
                        final uuid = const Uuid().v4();
                        final fileName = 'pet_photo_$uuid.jpg';
                        final imageBytes = await _photo!.readAsBytes();
                        photoUrl = await SupabaseStorageService().uploadImage(
                          imageBytes: imageBytes,
                          fileName: fileName,
                          folder: 'pet_photos',
                          bucketName: 'pet_images', // Assuming you have a bucket named 'pet_images'
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to upload image: $e')),
                        );
                        return;
                      }
                    }

                    final newPet = Pet(
                      petId: const Uuid().v4(), // Generate a unique ID for the pet
                      userId: authProvider.user!.uid,
                      name: _name!,
                      species: _species!,
                      breed: _breed!,
                      age: _age!,
                      description: _description!,
                      photoUrl: photoUrl,
                      gender: _gender,
                      isVaccinated: _isVaccinated,
                      isSpayed: _isSpayed,
                      isNeutered: _isNeutered,
                      isSpecialNeeds: _isSpecialNeeds,
                      shelterId: null, // This pet is added by a user, not a shelter
                    );

                    try {
                      await petProvider.addPet(newPet);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pet added successfully!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add pet: $e')),
                      );
                    }
                  }
                },
              ),
              ]
        ),
      ),
      )
    );
  }
}