
import 'package:flutter/material.dart';
import 'package:pawfect_care/models/user.dart';
import 'package:pawfect_care/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
      _photoUrlController.text = user.profile.photoUrl ?? '';
      _addressController.text = user.profile.address ?? '';
      _cityController.text = user.profile.city ?? '';
      _stateController.text = user.profile.state ?? '';
      _zipCodeController.text = user.profile.zipCode ?? '';
      _countryController.text = user.profile.country ?? '';
      _bioController.text = user.profile.bio ?? '';
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _phoneController.dispose();
    _photoUrlController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _photoUrlController,
                decoration: const InputDecoration(labelText: 'Photo URL'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    final updatedUser = userProvider.user!.copyWith(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      profile: userProvider.user!.profile.copyWith(
                        photoUrl: _photoUrlController.text,
                        address: _addressController.text,
                        city: _cityController.text,
                        state: _stateController.text,
                        zipCode: _zipCodeController.text,
                        country: _countryController.text,
                        bio: _bioController.text,
                      ),
                    );
                    userProvider.updateUser(updatedUser);
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
