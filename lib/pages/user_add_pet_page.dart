import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawfect_care/models/gender.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/providers/pet_provider.dart';
import 'package:pawfect_care/services/supabase_storage_service.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UserAddPetPage extends StatefulWidget {
  const UserAddPetPage({super.key});

  @override
  State<UserAddPetPage> createState() => _UserAddPetPageState();
}

class _UserAddPetPageState extends State<UserAddPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();

  Gender _selectedGender = Gender.male;
  bool _isVaccinated = false;
  bool _isSpayed = false;
  bool _isNeutered = false;
  bool _isSpecialNeeds = false;
  File? _imageFile;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Photo Source',
              style: PawfectCareTheme.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: PawfectCareTheme.chipBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: IconButton(
                          icon: Icon(
                            Icons.photo_library,
                            size: 32,
                            color: PawfectCareTheme.primaryBlue,
                          ),
                          onPressed: () =>
                              Navigator.pop(context, ImageSource.gallery),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Gallery', style: PawfectCareTheme.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: PawfectCareTheme.chipBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 32,
                            color: PawfectCareTheme.primaryBlue,
                          ),
                          onPressed: () =>
                              Navigator.pop(context, ImageSource.camera),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Camera', style: PawfectCareTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: ${e.toString()}')),
        );
      }
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    final Uint8List imageBytes = await imageFile.readAsBytes();
    final String fileName = '${const Uuid().v4()}.jpg';

    return await SupabaseStorageService().uploadImage(
      imageBytes: imageBytes,
      fileName: fileName,
      folder: 'pet_photos',
      bucketName: 'pet_images',
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a pet photo')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final photoUrl = await _uploadImage(_imageFile!);

        final newPet = Pet(
          petId: const Uuid().v4(),
          name: _nameController.text,
          species: _speciesController.text,
          breed: _breedController.text,
          age: int.parse(_ageController.text),
          description: _descriptionController.text,
          photoUrl: photoUrl,
          gender: _selectedGender,
          isVaccinated: _isVaccinated,
          isSpayed: _isSpayed,
          isNeutered: _isNeutered,
          isSpecialNeeds: _isSpecialNeeds,
        );

        await Provider.of<PetProvider>(context, listen: false).addPet(newPet);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pet added successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding pet: ${e.toString()}')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Pet',
          style: PawfectCareTheme.headingSmall.copyWith(
            color: PawfectCareTheme.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: PawfectCareTheme.textPrimary,
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Adding your pet...',
                    style: PawfectCareTheme.bodyMedium.copyWith(
                      color: PawfectCareTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: PawfectCareTheme.chipBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: PawfectCareTheme.chipBorder,
                          ),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: PawfectCareTheme.chipBackground
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                      color: PawfectCareTheme.primaryBlue,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap to add photo',
                                      style: PawfectCareTheme.bodyMedium
                                          .copyWith(
                                            color: PawfectCareTheme.primaryBlue,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Choose from gallery or take a photo',
                                      style: PawfectCareTheme.caption,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Pet Name',
                        prefixIcon: Icon(Icons.pets),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter pet name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _speciesController,
                      decoration: const InputDecoration(
                        labelText: 'Species',
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter species';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _breedController,
                      decoration: const InputDecoration(
                        labelText: 'Breed',
                        prefixIcon: Icon(Icons.pets),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter breed';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gender',
                          style: PawfectCareTheme.bodyMedium.copyWith(
                            color: PawfectCareTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ChoiceChip(
                              label: Text(
                                'Male',
                                style: TextStyle(
                                  color: _selectedGender == Gender.male
                                      ? Colors.white
                                      : PawfectCareTheme.primaryBlue,
                                ),
                              ),
                              selected: _selectedGender == Gender.male,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedGender = Gender.male;
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 12),
                            ChoiceChip(
                              label: Text(
                                'Female',
                                style: TextStyle(
                                  color: _selectedGender == Gender.female
                                      ? Colors.white
                                      : PawfectCareTheme.primaryBlue,
                                ),
                              ),
                              selected: _selectedGender == Gender.female,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedGender = Gender.female;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text(
                              'Vaccinated',
                              style: PawfectCareTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              'Has your pet received their vaccinations?',
                              style: PawfectCareTheme.caption,
                            ),
                            value: _isVaccinated,
                            activeColor: PawfectCareTheme.primaryBlue,
                            onChanged: (bool value) {
                              setState(() {
                                _isVaccinated = value;
                              });
                            },
                          ),
                          if (_selectedGender == Gender.female)
                            SwitchListTile(
                              title: Text(
                                'Spayed',
                                style: PawfectCareTheme.bodyMedium,
                              ),
                              subtitle: Text(
                                'Has your pet been spayed?',
                                style: PawfectCareTheme.caption,
                              ),
                              value: _isSpayed,
                              activeColor: PawfectCareTheme.primaryBlue,
                              onChanged: (bool value) {
                                setState(() {
                                  _isSpayed = value;
                                });
                              },
                            ),
                          if (_selectedGender == Gender.male)
                            SwitchListTile(
                              title: Text(
                                'Neutered',
                                style: PawfectCareTheme.bodyMedium,
                              ),
                              subtitle: Text(
                                'Has your pet been neutered?',
                                style: PawfectCareTheme.caption,
                              ),
                              value: _isNeutered,
                              activeColor: PawfectCareTheme.primaryBlue,
                              onChanged: (bool value) {
                                setState(() {
                                  _isNeutered = value;
                                });
                              },
                            ),
                          SwitchListTile(
                            title: Text(
                              'Special Needs',
                              style: PawfectCareTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              'Does your pet require special care or attention?',
                              style: PawfectCareTheme.caption,
                            ),
                            value: _isSpecialNeeds,
                            activeColor: PawfectCareTheme.primaryBlue,
                            onChanged: (bool value) {
                              setState(() {
                                _isSpecialNeeds = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Add Pet'),
                    ),
                  ],
                ),
              ),
            ),
    );
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
}
