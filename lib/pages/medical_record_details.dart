import "package:flutter/material.dart";
import "package:pawfect_care/pages/add_medical_record_form.dart";

import "../models/medical_records.dart";



class MedicalRecordDetailPage extends StatelessWidget {
  final MedicalRecord record;

  const MedicalRecordDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(record.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Date: ${record.date.toLocal().toString().split(' ')[0]}',
              style: TextStyle(color: Colors.blueGrey),
            ),
            SizedBox(height: 10),
            Text(record.description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddMedicalRecordForm(),));
          },
         child: Icon(Icons.add),
      ),
      
    );
  }
}
