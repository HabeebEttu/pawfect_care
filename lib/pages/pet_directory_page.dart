import 'package:flutter/material.dart';

class PetDirectoryPage extends StatelessWidget {
  const PetDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Directory'),
      ),
      body: const Center(
        child: Text('Pet Directory Content'),
      ),
    );
  }
}
