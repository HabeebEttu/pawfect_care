import 'package:flutter/material.dart';

class EditPetProfilePage extends StatelessWidget {
  const EditPetProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pet Profile'),
      ),
      body: const Center(
        child: Text('Edit Pet Profile Content'),
      ),
    );
  }
}
