import 'package:flutter/material.dart';

class UserPetDirectoryPage extends StatelessWidget {
  const UserPetDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
      ),
      body: const Center(
        child: Text('User Pet Directory Page Content'),
      ),
    );
  }
}
