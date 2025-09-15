import 'package:flutter/material.dart';
import 'package:pawfect_care/pages/pet_owner_dashboard.dart';
import 'package:pawfect_care/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pawfect_care/models/appointment.dart';
import 'package:pawfect_care/providers/appointment_provider.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/pages/book_appointment_page.dart';
import 'package:pawfect_care/pages/edit_appointment_page.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        Provider.of<AppointmentProvider>(context, listen: false).fetchAppointmentsForUser();
      }
    });
  }

  List<Appointment> _getAppointmentsForDay(DateTime day, List<Appointment> appointments) {
    return appointments.where((appointment) =>
        appointment.appointmentTime != null &&
        appointment.appointmentTime!.year == day.year &&
        appointment.appointmentTime!.month == day.month &&
        appointment.appointmentTime!.day == day.day).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    if (authProvider.user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Appointments"),
        ),
        body: const Center(
          child: Text('Please log in to view appointments.'),
        ),
      );
    }

    final upcomingAppointments = appointmentProvider.appointments.where((app) =>
        app.appointmentTime != null && app.appointmentTime!.isAfter(DateTime.now())).toList();
    final pastAppointments = appointmentProvider.appointments.where((app) =>
        app.appointmentTime != null && app.appointmentTime!.isBefore(DateTime.now())).toList();

<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Appointments",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calendar View',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
=======
                  const SizedBox(height: 20),

                  Text(
                    "Calendar View",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2020),
                    lastDay: DateTime.utc(2030),
                    focusedDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  ),

                  SizedBox(height: 20),

                  const Text(
                    "Upcoming Appointments",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),

                  // Action Buttons
                  Center(
                    child: Column(
                      children: [
                        FloatingActionButton.extended(
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PetOwnerDashboard(),
                              ),
                            );
                          },
                          label: Text(
                            "Book Appointments Now",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        FloatingActionButton.extended(
                          backgroundColor: Colors.white,
                          onPressed: () {},
                          label: Text(
                            "Reschedule Existing Appointments",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
>>>>>>> caca00d280662a329447727835c186c1bb188143
              ),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: (day) => _getAppointmentsForDay(day, appointmentProvider.appointments),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Upcoming Appointments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              appointmentProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : upcomingAppointments.isEmpty
                      ? const Center(child: Text('No upcoming appointments.'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: upcomingAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = upcomingAppointments[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(appointment.service),
                                subtitle: Text(
                                    '${appointment.appointmentTime!.toLocal().toShortDateString()} at ${appointment.appointmentTime!.toLocal().toShortTimeString()}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await appointmentProvider.deleteAppointment(appointment.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Appointment cancelled.')),
                                    );
                                  },
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditAppointmentPage(appointment: appointment),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
              const SizedBox(height: 20),
              const Text(
                "Past Appointments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              appointmentProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : pastAppointments.isEmpty
                      ? const Center(child: Text('No past appointments.'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pastAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = pastAppointments[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(appointment.service),
                                subtitle: Text(
                                    '${appointment.appointmentTime!.toLocal().toShortDateString()} at ${appointment.appointmentTime!.toLocal().toShortTimeString()}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await appointmentProvider.deleteAppointment(appointment.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Appointment cancelled.')),
                                    );
                                  },
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditAppointmentPage(appointment: appointment),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookAppointmentPage(),
                          ),
                        );
                      },
                      label: const Text(
                        "Book Appointments Now",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        // For simplicity, navigating to BookAppointmentPage for now.
                        // In a real app, this would lead to a selection of existing appointments
                        // or a dedicated reschedule flow.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookAppointmentPage(),
                          ),
                        );
                      },
                      label: const Text(
                        "Reschedule Existing Appointments",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on DateTime {
  String toShortDateString() {
    return '${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  String toShortTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}