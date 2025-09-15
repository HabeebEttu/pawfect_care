import 'package:flutter/material.dart';

class MedicalRecordsHistoryPage extends StatelessWidget {
  const MedicalRecordsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records History'),
      ),
      body: const Center(
        child: Text('Medical Records History Content'),
      ),
    );
  }
}
