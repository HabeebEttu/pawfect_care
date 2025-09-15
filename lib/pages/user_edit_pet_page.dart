import 'package:flutter/material.dart';

class UserEditPetPage extends StatelessWidget {
  const UserEditPetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pet Information'),
      ),
      body: const Center(
        child: Text('User Edit Pet Page Content'),
      ),
    );
  }
}
