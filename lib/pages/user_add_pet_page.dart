import 'package:flutter/material.dart';

class UserAddPetPage extends StatelessWidget {
  const UserAddPetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Pet'),
      ),
      body: const Center(
        child: Text('User Add Pet Page Content'),
      ),
    );
  }
}
