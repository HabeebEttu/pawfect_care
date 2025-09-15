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

class UserEditPetPage extends StatefulWidget {
  final Pet pet;

  const UserEditPetPage({super.key, required this.pet});

  @override
  State<UserEditPetPage> createState() => _UserEditPetPageState();
}

class _UserEditPetPageState extends State<UserEditPetPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _speciesController;
  late final TextEditingController _breedController;
  late final TextEditingController _ageController;
  late final TextEditingController _descriptionController;

  late Gender _selectedGender;
  late bool _isVaccinated;
  late bool _isSpayed;
  late bool _isNeutered;
  late bool _isSpecialNeeds;
  File? _imageFile;
  String? _currentPhotoUrl;
  bool _isLoading = false;
  bool _imageChanged = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current pet data
    _nameController = TextEditingController(text: widget.pet.name);
    _speciesController = TextEditingController(text: widget.pet.species);
    _breedController = TextEditingController(text: widget.pet.breed);
    _ageController = TextEditingController(text: widget.pet.age.toString());
    _descriptionController = TextEditingController(
      text: widget.pet.description,
    );

    _selectedGender = widget.pet.gender;
    _isVaccinated = widget.pet.isVaccinated;
    _isSpayed = widget.pet.isSpayed ?? false;
    _isNeutered = widget.pet.isNeutered ?? false;
    _isSpecialNeeds = widget.pet.isSpecialNeeds ?? false;
    _currentPhotoUrl = widget.pet.photoUrl;
  }

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
              'Update Pet Photo',
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
          _imageChanged = true;
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

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final String fileName = '${const Uuid().v4()}.jpg';

      return await SupabaseStorageService().uploadImage(
        imageBytes: imageBytes,
        fileName: fileName,
        folder: 'pet_photos',
        bucketName: 'pet_images',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: ${e.toString()}')),
        );
      }
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String photoUrl = _currentPhotoUrl!;

        if (_imageChanged && _imageFile != null) {
          final newPhotoUrl = await _uploadImage(_imageFile!);
          if (newPhotoUrl == null) return; // Error already shown
          photoUrl = newPhotoUrl;
        }

        final updatedPet = widget.pet.copyWith(
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

        await Provider.of<PetProvider>(
          context,
          listen: false,
        ).updatePet(updatedPet);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pet information updated successfully!'),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating pet: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit ${widget.pet.name}',
          style: PawfectCareTheme.headingSmall.copyWith(
            color: PawfectCareTheme.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: PawfectCareTheme.textPrimary,
        ),
        actions: [
          TextButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.check),
            label: const Text('Save'),
            style: TextButton.styleFrom(
              foregroundColor: PawfectCareTheme.primaryBlue,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Updating pet information...',
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
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      _currentPhotoUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            size: 40,
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Change Photo',
                                            style: PawfectCareTheme.bodyMedium
                                                .copyWith(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                ),
                                          ),
                                        ],
                                      ),
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
