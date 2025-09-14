// import "package:flutter/material.dart";
// import "package:pawfect_care/pages/medical_record_details.dart";
// import "package:pawfect_care/providers/theme_provider.dart";
// import "package:pawfect_care/theme/theme.dart";
// import "package:provider/provider.dart";
//
// import "../models/medical_records.dart";
// import "../models/pet.dart";
// import "../models/status.dart";
//
//
// class VeterinarianDashboard extends StatefulWidget {
//   const VeterinarianDashboard({super.key});
//
//   @override
//   State<VeterinarianDashboard> createState() => _VeterinarianDashboardState();
// }
//
// class _VeterinarianDashboardState extends State<VeterinarianDashboard> {
//
//   int _selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//
//     List<Status> appointmentStatus = [
//       Status.CONFIRMED,
//       Status.PENDING,
//       Status.CANCELLED,
//     ];
//
//     List<Map<String, dynamic>> myPatients = [
//       {
//         "name": 'Whiskers',
//         "petId": 'whis_1234',
//         "owner": 'Eduvie',
//         "photoUrl": 'assets/images/pet_1.png',
//         "species": 'Cat',
//       },
//       {
//         "name": 'Bubbles',
//         "petId": 'bubb_1234',
//         "owner": 'Nsikak',
//         "photoUrl": 'assets/images/pet_2.png',
//         "species": 'German Shepard',
//       },
//       {
//         "name": 'Scooby',
//         "petId": 'scob_3434',
//         "owner": 'Abbas',
//         "photoUrl": 'assets/images/pet_3.png',
//         "species": 'Dog',
//       }
//
//
//
//
//
//
//     ];
//
//     final List<MedicalRecord> medicalRecords = [
//       MedicalRecord(
//         id: '1',
//         title: 'Annual Checkup',
//         description: 'Routine examination and vaccinations.',
//         date: DateTime(2025, 9, 10),
//       ),
//       MedicalRecord(
//         id: '2',
//         title: 'Dental Cleaning',
//         description: 'Teeth cleaning and oral health check.',
//         date: DateTime(2025, 8, 20),
//       ),
//       MedicalRecord(
//         id: '3',
//         title: 'Surgery Follow-up',
//         description: 'Post-surgery checkup and stitches removal.',
//         date: DateTime(2025, 7, 30),
//       ),
//     ];
//
//
//     return Consumer<ThemeProvider>(
//         builder: (context, themeProvider, child) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text("Veterinarian Dashboard",
//                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
//               centerTitle: true,
//               automaticallyImplyLeading: false,
//             ),
//              backgroundColor: PawfectCareTheme.backgroundWhite,
//
//             body: SafeArea(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ..._buildTodayAppointment(themeProvider, appointmentStatus),
//                       ..._buildMyPatients(context, myPatients),
//                       ..._buildMedicalRecords(context, medicalRecords),
//
//
//                     ],
//                   ),)),
//           );
//
//
//         },
//     );
//   }
//
//   List<Widget> _buildTodayAppointment(ThemeProvider themeProvider, List<Status> appointmentStatus){
//     return [
//       SizedBox(height: 20,),
//       Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.0),
//           child: Text("Today's Appointments", style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.normal)),
//       ),
//       SizedBox(height: 10,),
//       Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.0),
//         child: Text("Monday, Sep 2025", style: TextStyle(color: Colors.blueGrey, fontSize: 15),),
//       ),
//       SizedBox(height: 10,),
//       SizedBox(
//         child: ListView.builder(
//             itemBuilder: (context, index) => _buildTodayAppointmentCard(themeProvider, context, appointmentStatus[index]),
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: appointmentStatus.length,
//         ),
//
//       )
//     ];
//   }
//
//   Card _buildTodayAppointmentCard(ThemeProvider themeProvider, BuildContext context, Status status) {
//     String statusText = status.toString().split('.').last;
//
//     Color statusColor;
//     switch (status) {
//       case Status.CONFIRMED:
//         statusColor = Colors.green;
//         break;
//       case Status.PENDING:
//         statusColor = Colors.orange;
//         break;
//       case Status.CANCELLED:
//         statusColor = Colors.red;
//         break;
//     }
//     return  Card(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(statusText, style: PawfectCareTheme.bodyMedium.copyWith(color: statusColor, fontWeight: FontWeight.bold),),
//                 SizedBox(width: 60,),
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_month_outlined, color: Colors.blueGrey, size: 20, ),
//                     Text("10:00AM", style: PawfectCareTheme.bodyMedium.copyWith(color: Colors.grey),)
//                   ],),
//
//               ],
//             ),
//           ),
//           SizedBox(height: 15,),
//
//           Container(
//             alignment: Alignment.bottomLeft,
//             padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Pet: Buddy", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15)),
//                 Text("Owner: Jane", style: TextStyle(color: Colors.blueGrey), ),
//               ],
//             ),
//           ),
//
//           SizedBox(height: 20,),
//           Container(
//             padding: EdgeInsets.only(bottom: 20),
//             child: Wrap(
//               spacing: 10,
//               runSpacing: 5,
//               children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SizedBox(
//                     width: 110, // force smaller width
//                     height: 36, // force smaller height
//                     child: OutlinedButton(
//                       onPressed: () {},
//                       style: OutlinedButton.styleFrom(
//                         padding: EdgeInsets.zero, // remove extra padding
//                         side: const BorderSide(color: Colors.blueAccent, width: 1.3),
//                       ),
//                       child: Text("View Details", style: TextStyle(color: Colors.blue)),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 110, // force smaller width
//                     height: 36, // force smaller height
//                     child: OutlinedButton(
//                       onPressed: () {},
//                       style: OutlinedButton.styleFrom(
//                         padding: EdgeInsets.zero, // remove extra padding
//                         side: const BorderSide(color: Colors.blueAccent, width: 1.3),
//                         backgroundColor: Colors.blueAccent,
//                         foregroundColor: Colors.white
//                       ),
//                       child: Text("Complete", style: TextStyle(color: Colors.white)),
//                     ),
//                   ),
//                 ],
//               ),
//             ],),
//           ),
//         ],
//
//       ),
//
//
//     );
//   }
//
//   List<Widget> _buildMyPatients(BuildContext context, List myPatients) {
//     return [
//       Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.0,),
//         child: Text(
//           "My Patients",
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 20,
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//       ),
//       SizedBox(height: 10),
//       Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.0),
//         child: Column(
//           children: myPatients
//               .map<Widget>((pet) => _buildMyPatientsCard(pet, context))
//               .toList(),
//         ),
//       ),
//     ];
//   }
//
//   Card _buildMyPatientsCard(Map<String, dynamic> pet, BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       elevation: 2,
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         leading: CircleAvatar(
//           backgroundImage: AssetImage(pet["photoUrl"]),
//           radius: 28,
//         ),
//         title: Text(
//           pet['name'],
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(pet['species'], style: const TextStyle(fontSize: 14)),
//             Text("Owner: ${pet['owner']}", style: const TextStyle(fontSize: 14)),
//           ],
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
//       ),
//     );
//   }
//
//   List<Widget> _buildMedicalRecords(BuildContext context, List<MedicalRecord> medicalRecords) {
//     return [
//       Padding(
//           padding: EdgeInsets.only(left: 20.0, top: 30, bottom: 10),
//
//           child: Text("Recent Medical Reports",
//         style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),),
//
//       ),
//
//       ...medicalRecords.map((record) {
//
//       return Card(
//         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         elevation: 2,
//         child: ListTile(
//           title: Text(record.title, style: TextStyle(fontWeight: FontWeight.bold),),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Date: ${record.date.toLocal().toString().split(' ')[0]}"),
//               Text(record.description,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(color: Colors.blue),
//               ),
//             ],
//           ),
//           trailing: Icon(Icons.arrow_forward, size: 16,),
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalRecordDetailPage(record: record),));
//
//           },
//
//         ),
//       );
//     }).toList(),
// ];
//   }
// }

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:pawfect_care/pages/add_appointment_form.dart";
import "package:pawfect_care/pages/add_medical_record_form.dart";
import "package:pawfect_care/pages/add_patients_record_form.dart";
import "package:pawfect_care/pages/medical_record_details.dart";
import "package:pawfect_care/pages/my_patients_details_page.dart";
import "package:pawfect_care/providers/theme_provider.dart";
import "package:pawfect_care/theme/theme.dart";
import "package:provider/provider.dart";
import 'package:pawfect_care/pages/appointment_details_page.dart';
import 'package:intl/intl.dart';

import "../models/appointment.dart";
import "../models/medical_records.dart";
import "../models/pet.dart";
import "../models/status.dart";


class VeterinarianDashboard extends StatefulWidget {
  const VeterinarianDashboard({super.key});

  @override
  State<VeterinarianDashboard> createState() => _VeterinarianDashboardState();
}

class _VeterinarianDashboardState extends State<VeterinarianDashboard> {

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {

    List<Status> appointmentStatus = [
      Status.CONFIRMED,
      Status.PENDING,
      Status.CANCELLED,
    ];

    final List<Appointment> appointments = [
      Appointment(
        appointmentId: 'a1',
        petId: 'p1',
        vetId: 'v1',
        appointmentTime: DateTime(2025, 9, 13, 10, 0),
        appointmentStatus: Status.CONFIRMED,
        notes: 'Bring vaccination card.',
        service: 'Annual Checkup',
      ),
      Appointment(
        appointmentId: 'a2',
        petId: 'p2',
        vetId: 'v1',
        appointmentTime: DateTime(2025, 9, 13, 12, 30),
        appointmentStatus: Status.PENDING,
        notes: 'Fasting required before visit.',
        service: 'Blood Test',
      ),
      Appointment(
        appointmentId: 'a3',
        petId: 'p3',
        vetId: 'v2',
        appointmentTime: DateTime(2025, 9, 13, 15, 45),
        appointmentStatus: Status.CANCELLED,
        notes: 'Reschedule for next week.',
        service: 'Dental Cleaning',
      ),
    ];

    List<Map<String, dynamic>> myPatients = [
      {
        "name": 'Whiskers',
        "petId": 'whis_1234',
        "owner": 'Eduvie',
        "photoUrl": 'assets/images/pet_1.png',
        "species": 'Cat',
      },
      {
        "name": 'Bubbles',
        "petId": 'bubb_1234',
        "owner": 'Nsikak',
        "photoUrl": 'assets/images/pet_2.png',
        "species": 'German Shepard',
      },
      {
        "name": 'Scooby',
        "petId": 'scob_3434',
        "owner": 'Abbas',
        "photoUrl": 'assets/images/pet_3.png',
        "species": 'Dog',
      },
      {
        "name": 'Mooley',
        "petId": 'moo_3434',
        "owner": 'Habeeb',
        "photoUrl": 'assets/images/pet_2.png',
        "species": 'Rotweiler',
      },
      {
        "name": 'Mufasa',
        "petId": 'muf_3434',
        "owner": 'Israel',
        "photoUrl": 'assets/images/pet_1.png',
        "species": 'Acacian',
      }
    ];

    final List<MedicalRecord> medicalRecords = [
      MedicalRecord(
        id: '1',
        title: 'Annual Checkup',
        description: 'Routine examination and vaccinations.',
        date: DateTime(2025, 9, 10),
      ),
      MedicalRecord(
        id: '2',
        title: 'Dental Cleaning',
        description: 'Teeth cleaning and oral health check.',
        date: DateTime(2025, 8, 20),
      ),
      MedicalRecord(
        id: '3',
        title: 'Surgery Follow-up',
        description: 'Post-surgery checkup and stitches removal.',
        date: DateTime(2025, 7, 30),
      ),
    ];

    void _onItemTapped(int index){
      setState(() {
        _selectedIndex = index;
      });
    }


    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: _selectedIndex ==0 ? AppBar(
            title: Text("Veterinarian Dashboard",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ) : null,

          backgroundColor: PawfectCareTheme.backgroundWhite,

          body: SafeArea(
              child: IndexedStack(
                index: _selectedIndex,
                children: [

                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildTodayAppointment(themeProvider, appointments),
                        ..._buildMyPatients(context, myPatients),
                        ..._buildMedicalRecords(context, medicalRecords),


                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildTodayAppointment(themeProvider, appointments),
                      ],
                    ),
                  ),

                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildMyPatients(context, myPatients),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildMedicalRecords(context, medicalRecords),
                      ],
                    ),
                  ),

                ],
              ),
          ),

          bottomNavigationBar: BottomNavigationBar(
             currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: "Appointments",
              ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pets),
                  label: "Patients",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Records",
                ),

              ],

          ),
        );


      },
    );
  }

  List<Widget> _buildTodayAppointment(
      ThemeProvider themeProvider,
      List<Appointment> appointments,
      ) {

    final String today = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
    return [
      SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.only(left: 20.0, top: 30, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Appointments",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton(
                icon: Icon(Icons.add, size: 40, color: Colors.blue,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddAppointmentForm()),
                  );
                },
              ),

            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(today, style: TextStyle(color: Colors.blueGrey, fontSize: 15),
        ),
      ),
      SizedBox(height: 10),
      SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            return _buildTodaysAppointmentCard(
              themeProvider,
              context,
              appointments[index],
            );
          },
        ),
      ),
    ];
  }


  // Card _buildTodayAppointmentCard(ThemeProvider themeProvider, BuildContext context, Status status) {
  //   String statusText = status.toString().split('.').last;
  //
  //   Color statusColor;
  //   switch (status) {
  //     case Status.CONFIRMED:
  //       statusColor = Colors.green;
  //       break;
  //     case Status.PENDING:
  //       statusColor = Colors.orange;
  //       break;
  //     case Status.CANCELLED:
  //       statusColor = Colors.red;
  //       break;
  //   }
  //   return  Card(
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(15.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(statusText, style: PawfectCareTheme.bodyMedium.copyWith(color: statusColor, fontWeight: FontWeight.bold),),
  //               SizedBox(width: 60,),
  //               Row(
  //                 children: [
  //                   Icon(Icons.calendar_month_outlined, color: Colors.blueGrey, size: 20, ),
  //                   Text("10:00AM", style: PawfectCareTheme.bodyMedium.copyWith(color: Colors.grey),)
  //                 ],),
  //
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 15,),
  //
  //         Container(
  //           alignment: Alignment.bottomLeft,
  //           padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text("Pet: Buddy", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15)),
  //               Text("Owner: Jane", style: TextStyle(color: Colors.blueGrey), ),
  //             ],
  //           ),
  //         ),
  //
  //         SizedBox(height: 20,),
  //         Container(
  //           padding: EdgeInsets.only(bottom: 20),
  //           child: Wrap(
  //             spacing: 10,
  //             runSpacing: 5,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   SizedBox(
  //                     width: 110, // force smaller width
  //                     height: 36, // force smaller height
  //                     child: OutlinedButton(
  //                       onPressed: () {},
  //                       style: OutlinedButton.styleFrom(
  //                         padding: EdgeInsets.zero, // remove extra padding
  //                         side: const BorderSide(color: Colors.blueAccent, width: 1.3),
  //                       ),
  //                       child: Text("View Details", style: TextStyle(color: Colors.blue)),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 110, // force smaller width
  //                     height: 36, // force smaller height
  //                     child: OutlinedButton(
  //                       onPressed: () {},
  //                       style: OutlinedButton.styleFrom(
  //                           padding: EdgeInsets.zero, // remove extra padding
  //                           side: const BorderSide(color: Colors.blueAccent, width: 1.3),
  //                           backgroundColor: Colors.blueAccent,
  //                           foregroundColor: Colors.white
  //                       ),
  //                       child: Text("Complete", style: TextStyle(color: Colors.white)),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],),
  //         ),
  //       ],
  //
  //     ),
  //
  //
  //   );
  // }

  Card _buildTodaysAppointmentCard(
      ThemeProvider themeProvider,
      BuildContext context,
      Appointment appointment,
      ) {
    // Extract status color and text
    final statusText = appointment.appointmentStatus.toString().split('.').last;
    Color statusColor;
    switch (appointment.appointmentStatus) {
      case Status.CONFIRMED:
        statusColor = Colors.green;
        break;
      case Status.PENDING:
        statusColor = Colors.orange;
        break;
      case Status.CANCELLED:
        statusColor = Colors.red;
        break;
    }

    // Format appointment date and time
    final date = appointment.appointmentTime != null
        ? DateFormat('EEE, MMM d').format(appointment.appointmentTime!)
        : 'No date';
    final time = appointment.appointmentTime != null
        ? DateFormat('h:mm a').format(appointment.appointmentTime!)
        : 'No time';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              appointment.service,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "$statusText",
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: $date"),
            SizedBox(height: 5,),
            Text("Time: $time"),
            // if (appointment.notes != null && appointment.notes!.isNotEmpty)
            //   Text(
            //     "Notes: ${appointment.notes}",
            //     maxLines: 1,
            //     overflow: TextOverflow.ellipsis,
            //     style: TextStyle(color: Colors.blueGrey),
            //   ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 110,
                  height: 36,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentDetailsPage(
                              appointment: appointment),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero, // remove extra padding
                      side: BorderSide(color: Colors.blueAccent, width: 1.3),
                    ),
                    child: Text("View Details", style: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                SizedBox(
                  width: 110,
                  height: 36,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.zero,
                      side: BorderSide(color: Colors.blueAccent, width: 1.3),
                    ),
                    child: Text(
                     " $statusText",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                ),
              ],
            ),

          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          // Navigate to details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentDetailsPage(appointment: appointment),
            ),
          );
        },
      ),
    );
  }


  List<Widget> _buildMyPatients(BuildContext context, List myPatients) {
    return [
      Padding(
        padding: EdgeInsets.only(left: 20.0, top: 30, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Patients",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 60,
               width: 60,
              child: IconButton(

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyPatientRecordsForm()),
                    );
                  }, 
                  icon: Icon(Icons.add, size: 40, color: Colors.blueAccent,)),
            )
          ],
        ),
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: myPatients
              .map<Widget>((pet) => _buildMyPatientsCard(pet, context))
              .toList(),
        ),
      ),
    ];
  }

  Card _buildMyPatientsCard(Map<String, dynamic> pet, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: CircleAvatar(
          backgroundImage: AssetImage(pet["photoUrl"]),
          radius: 28,
        ),
        title: Text(
          pet['name'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pet['species'], style: const TextStyle(fontSize: 14)),
            Text("Owner: ${pet['owner']}", style: const TextStyle(fontSize: 14)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyPatientsDetailsPage(patient: pet),));
        },
      ),
    );
  }

  List<Widget> _buildMedicalRecords(BuildContext context, List<MedicalRecord> medicalRecords) {


    return [
      Padding(
        padding: EdgeInsets.only(left: 20.0, top: 30, bottom: 10),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recent Medical Reports",
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddMedicalRecordForm(),));
                  }, 
                  icon: Icon(Icons.add, size: 40, color: Colors.blueAccent)),
            )
          ],
        ),

      ),

      ...medicalRecords.map((record) {

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          elevation: 2,
          child: ListTile(
            title: Text(record.title, style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date: ${record.date.toLocal().toString().split(' ')[0]}"),
                Text(record.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_forward, size: 16,),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalRecordDetailPage(record: record),));

            },

          ),
        );
      }).toList(),
    ];
  }



}
