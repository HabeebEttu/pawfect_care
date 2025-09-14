import 'package:flutter/material.dart';

class MyPatientsDetailsPage extends StatelessWidget {

  final Map<String, dynamic> patient;
  const MyPatientsDetailsPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${patient['name']} Details"),),
      body: Padding(
        padding: EdgeInsets.all(16), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(patient['photoUrl']),
                radius: 50,
              ),
            ),
            SizedBox(height: 20),
            Text(
              patient['name'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Species: ${patient['species']}',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            SizedBox(height: 10),
            Text(
              'Owner: ${patient['owner']}',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            SizedBox(height: 20),
            Text(
              'Pet ID: ${patient['petId']}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            Spacer(),

            // Example action button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('View medical history coming soon')),
                  );
                },
                icon: Icon(Icons.medical_services),
                label: Text('View Medical History'),
              ),
            ),

          ],
        ),),
    );
  }
}
