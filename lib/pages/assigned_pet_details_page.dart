import 'package:flutter/material.dart';

class AssignedPetDetailsPage extends StatelessWidget {

  final Map<String, dynamic> assignedPet;
  const AssignedPetDetailsPage({super.key, required this.assignedPet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${assignedPet['name']} Details"),),
      body: Padding(
        padding: EdgeInsets.all(16), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(assignedPet['photoUrl']),
                radius: 50,
              ),
            ),
            SizedBox(height: 20),
            Text(
              assignedPet['name'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Species: ${assignedPet['species']}',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            SizedBox(height: 10),
            Text(
              'Owner: ${assignedPet['owner']}',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            SizedBox(height: 20),
            Text(
              'Pet ID: ${assignedPet['petId']}',
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
