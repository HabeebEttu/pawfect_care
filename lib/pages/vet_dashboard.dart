
import "package:flutter/material.dart";
import "package:pawfect_care/pages/add_medical_record_form.dart";
import "package:pawfect_care/pages/medical_record_details.dart";
import "package:pawfect_care/pages/assigned_pet_details_page.dart";
import "package:pawfect_care/providers/theme_provider.dart";
import "package:pawfect_care/providers/vet_service_provider.dart";
import "package:pawfect_care/theme/theme.dart";
import "package:provider/provider.dart";
import 'package:pawfect_care/pages/appointment_details_page.dart';
import 'package:intl/intl.dart';
import "package:table_calendar/table_calendar.dart";


import "../models/appointment.dart";
import "../models/medical_records.dart";
import "../models/status.dart";


class VeterinarianDashboard extends StatefulWidget {
  const VeterinarianDashboard({super.key});

  @override
  State<VeterinarianDashboard> createState() => _VeterinarianDashboardState();
}

class _VeterinarianDashboardState extends State<VeterinarianDashboard> {

  int _selectedIndex = 0;

  String? selectedVet;
  String? selectedPet;
  DateTime? selectedDate;

  String searchQuery = '';


  @override
  Widget build(BuildContext context) {

    final vetProvider = Provider.of<VetProvider>(context);
    final appointments = vetProvider.appointments;

    // final List<Appointment> appointments = [
    //   Appointment(
    //     id: 'a1',
    //     petId: 'p1',
    //     vetId: 'v1',
    //     ownerId: 'Habeeb',
    //     appointmentTime: DateTime(2025, 9, 13, 10, 0),
    //     appointmentStatus: Status.CONFIRMED,
    //     notes: 'Bring vaccination card.',
    //     service: 'Annual Checkup',
    //   ),
    //   Appointment(
    //     id: 'a2',
    //     petId: 'p2',
    //     vetId: 'v1',
    //     ownerId: 'Mark',
    //     appointmentTime: DateTime(2025, 9, 13, 12, 30),
    //     appointmentStatus: Status.PENDING,
    //     notes: 'Fasting required before visit.',
    //     service: 'Blood Test',
    //   ),
    //   Appointment(
    //     id: 'a3',
    //     petId: 'p3',
    //     vetId: 'v2',
    //     ownerId: 'Paul',
    //     appointmentTime: DateTime(2025, 9, 13, 15, 45),
    //     appointmentStatus: Status.CANCELLED,
    //     notes: 'Reschedule for next week.',
    //     service: 'Dental Cleaning',
    //   ),
    // ];

    List<Map<String, dynamic>> myAssignedPets = [
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
        petId: 'p1',
        title: 'Annual Checkup',
        description: 'Routine examination and vaccinations.',
        date: DateTime(2025, 9, 10),
        diagnosis: 'Healthy',
        treatmentNotes: 'Vaccinated against rabies and parvo.',
        prescriptions: 'Vitamin supplements for 1 month',
        uploadedFiles: [],
      ),
      MedicalRecord(
        id: '2',
        petId: 'p2',
        title: 'Dental Cleaning',
        description: 'Teeth cleaning and oral health check.',
        date: DateTime(2025, 8, 20),
        diagnosis: 'Mild tartar buildup',
        treatmentNotes: 'Teeth cleaned and gums examined',
        prescriptions: 'Daily dental chews',
        uploadedFiles: [],
      ),
      MedicalRecord(
        id: '3',
        petId: 'p3',
        title: 'Surgery Follow-up',
        description: 'Post-surgery checkup and stitches removal.',
        date: DateTime(2025, 7, 30),
        diagnosis: 'Recovering well',
        treatmentNotes: 'Stitches removed, wound clean',
        prescriptions: 'Painkillers for 3 days',
        uploadedFiles: [],
      ),
    ];

    final List<DateTime> availableSlots = [
      DateTime.now().add(Duration(hours: 2)),
      DateTime.now().add(Duration(days: 1, hours: 3)),
      DateTime.now().add(Duration(days: 2, hours: 5)),
    ];


    final filteredAppointments = appointments.where((a) {
      // Normalize query
      final lowerQuery = searchQuery.trim().toLowerCase();

      // Format appointment time for search
      final apptTime = a.appointmentTime != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(a.appointmentTime!)
          : '';


      final matchesVet = selectedVet == null || a.vetId == selectedVet;


      final matchesDate = selectedDate == null ||
          (a.appointmentTime != null &&
              DateFormat('yyyy-MM-dd').format(a.appointmentTime!) ==
                  DateFormat('yyyy-MM-dd').format(selectedDate!));


      final matchesSearch = lowerQuery.isEmpty ||
          (a.petId.toLowerCase().contains(lowerQuery)) ||
          (a.ownerId.toLowerCase().contains(lowerQuery)) ||
          apptTime.toLowerCase().contains(lowerQuery);

      return matchesVet && matchesDate && matchesSearch;
    }).toList();





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
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                                ),
                                labelText: 'Search by Pet ID or Owner Name',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onChanged: (query) {
                                setState(() {
                                  searchQuery = query ?? '';
                                });
                              },
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedDate == null
                                        ? 'Filter by Date: All'
                                        : 'Selected: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                    );
                                    if (picked != null) {
                                      setState(() => selectedDate = picked);
                                    }
                                  },
                                ),
                                if (selectedDate != null)
                                  IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () => setState(() => selectedDate = null),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      ..._buildTodayAppointment(themeProvider, filteredAppointments),

                      ..._buildAssignedPets(context, myAssignedPets),
                      ..._buildMedicalRecords(context, medicalRecords),


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

                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 800,
                          ),
                          child: _buildAppointmentCalendar(context, appointments, availableSlots,
                          ),
                        ),
                      ],
                    ),
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
                icon: Icon(Icons.person),
                label: "Medical Records",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: "Appointments Calender",
              ),




            ],

          ),
        );


      },
    );
  }



  List<Widget> _buildTodayAppointment(
      ThemeProvider themeProvider, List<Appointment> appointments) {
    final String today = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return [
      Padding(
        padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 5),
        child: Text("Appointments",
            style: TextStyle(
                color: Colors.green,
                fontSize: 30,
                fontWeight: FontWeight.normal)),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(today,
            style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
      ),
      SizedBox(height: 10),
      if (appointments.isEmpty)
        Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("No appointments available"),
            ))
      else
        ...appointments.map((appointment) =>
            _buildTodayAppointmentCard(themeProvider, context, appointment)),
    ];
  }


  Card _buildTodayAppointmentCard(
      ThemeProvider themeProvider, BuildContext context, Appointment appointment) {
    final statusColor = appointment.appointmentStatus == Status.CONFIRMED
        ? Colors.green
        : appointment.appointmentStatus == Status.PENDING
        ? Colors.orange
        : Colors.red;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(appointment.service,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'Pet ID: ${appointment.petId}\n'
              'Vet ID: ${appointment.vetId}\n'
              'Time: ${DateFormat('MMM d, yyyy – hh:mm a').format(appointment.appointmentTime!)}\n'
              'Notes: ${appointment.notes ?? "None"}',
        ),
        trailing: Text(
          appointment.appointmentStatus.name,
          style: TextStyle(color: statusColor),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentDetailsPage(appointment: appointment),
            ),
          );
        },
      ),
    );
  }



  List<Widget> _buildAssignedPets(BuildContext context, List myPatients) {
    return [
      Padding(
        padding: EdgeInsets.only(left: 20.0, top: 30, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Assigned Pets",
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

                  onPressed: () { },
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
              .map<Widget>((pet) => _buildAssignedPetCard(pet, context))
              .toList(),
        ),
      ),
    ];
  }

  Card _buildAssignedPetCard(Map<String, dynamic> pet, BuildContext context) {
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AssignedPetDetailsPage(assignedPet: pet),));
        },
      ),
    );
  }

  List<Widget> _buildMedicalRecords(
      BuildContext context, List<MedicalRecord> medicalRecords) {
    return [
      Padding(
        padding: EdgeInsets.only(left: 20.0, top: 30, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            Text(
              "Medical Records ",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.blueAccent, size: 32),
              tooltip: "Add New Medical Record",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddMedicalRecordForm()),
                );
              },
            ),
          ],
        ),
      ),

      SizedBox(height: 12),


      if (medicalRecords.isEmpty)
        Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text("No medical records available.")),
        )
      else
        ...medicalRecords.map((record) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.folder_open, color: Colors.blueAccent),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.petId, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(record.title, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date: ${record.date.toLocal().toString().split(' ')[0]}"),
                  Text(record.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black87)),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedicalRecordDetailPage(
                      petId: record.petId,
                      allRecords: medicalRecords,
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),

      SizedBox(height: 20),
    ];
  }


  Widget _buildAppointmentCalendar(
      BuildContext context,
      List<Appointment> appointments,
      List<DateTime> availableSlots,
      ) {
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;


    final Map<DateTime, List<Appointment>> groupedAppointments = {};
    for (var a in appointments) {
      if (a.appointmentTime != null) {
        final date = DateTime(
          a.appointmentTime!.year,
          a.appointmentTime!.month,
          a.appointmentTime!.day,
        );
        groupedAppointments.putIfAbsent(date, () => []).add(a);
      }
    }

    List<Appointment> _getAppointmentsForDay(DateTime day) {
      final key = DateTime(day.year, day.month, day.day);
      return groupedAppointments[key] ?? [];
    }

    return StatefulBuilder(
      builder: (context, setState) {
        final selectedAppointments =
        _selectedDay != null ? _getAppointmentsForDay(_selectedDay!) : [];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: _getAppointmentsForDay,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
              ),
              SizedBox(height: 10),
              if (_selectedDay != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Appointments on ${DateFormat('MMM d, yyyy').format(_selectedDay!)}:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),


                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selectedAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = selectedAppointments[index];
                    final formattedTime =
                    DateFormat('hh:mm a').format(appointment.appointmentTime!);

                    return Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading:
                        Icon(Icons.pets, color: Colors.blueAccent),
                        title: Text(
                            '${appointment.service} (${appointment.petId})'),
                        subtitle: Text(
                            'Time: $formattedTime\nStatus: ${appointment.appointmentStatus.toString().split('.').last}'),
                      ),
                    );
                  },
                ),
                if (selectedAppointments.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(child: Text('No appointments for this day')),
                  ),

                SizedBox(height: 100),
              ],
            ],
          ),
        );
      },
    );
  }








}
