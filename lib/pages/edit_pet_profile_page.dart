import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawfect_care/models/gender.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/providers/pet_provider.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/services/supabase_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditPetProfilePage extends StatefulWidget {
  final Pet pet;
  const EditPetProfilePage({super.key, required this.pet});

  @override
  State<EditPetProfilePage> createState() => _EditPetProfilePageState();
}

class _EditPetProfilePageState extends State<EditPetProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _descriptionController;
  File? _photo;
  late Gender _gender;
  late bool _isVaccinated;
  late bool _isSpayed;
  late bool _isNeutered;
  late bool _isSpecialNeeds;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _speciesController = TextEditingController(text: widget.pet.species);
    _breedController = TextEditingController(text: widget.pet.breed);
    _ageController = TextEditingController(text: widget.pet.age.toString());
    _descriptionController = TextEditingController(text: widget.pet.description);
    _gender = widget.pet.gender;
    _isVaccinated = widget.pet.isVaccinated;
    _isSpayed = widget.pet.isSpayed ?? false;
    _isNeutered = widget.pet.isNeutered ?? false;
    _isSpecialNeeds = widget.pet.isSpecialNeeds ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
    final petProvider = Provider.of<PetProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pet Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Implement delete functionality
              if (authProvider.user != null) {
                try {
                  await petProvider.deletePet(widget.pet.petId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pet deleted successfully!')),
                  );
                  Navigator.pop(context); // Pop back to previous screen
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete pet: $e')),
                  );
                }
              }
            },
          ),
        ],
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
                      backgroundImage: _photo != null
                          ? FileImage(_photo!)
                          : (widget.pet.photoUrl.isNotEmpty
                              ? NetworkImage(widget.pet.photoUrl)
                              : null) as ImageProvider?,
                      child: _photo == null && widget.pet.photoUrl.isEmpty
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
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _speciesController,
                decoration: const InputDecoration(labelText: 'Species'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a species';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Breed'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a breed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
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
              ),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    String photoUrl = widget.pet.photoUrl;
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

                    final updatedPet = widget.pet.copyWith(
                      name: _nameController.text,
                      species: _speciesController.text,
                      breed: _breedController.text,
                      age: int.parse(_ageController.text),
                      description: _descriptionController.text,
                      photoUrl: photoUrl,
                      gender: _gender,
                      isVaccinated: _isVaccinated,
                      isSpayed: _isSpayed,
                      isNeutered: _isNeutered,
                      isSpecialNeeds: _isSpecialNeeds,
                    );

                    try {
                      await petProvider.updatePet(updatedPet);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pet updated successfully!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update pet: $e')),
                      );
                    }
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
