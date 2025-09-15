import 'package:pawfect_care/pages/adoption_history_page.dart';
import 'package:pawfect_care/pages/appointment_page.dart';
import 'package:pawfect_care/pages/edit_user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:pawfect_care/models/gender.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/providers/theme_provider.dart';
import 'package:pawfect_care/providers/pet_provider.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:pawfect_care/providers/appointment_provider.dart';
import 'package:pawfect_care/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:pawfect_care/models/appointment.dart';
import 'package:pawfect_care/models/status.dart';


class PetOwnerDashboard extends StatefulWidget {
  const PetOwnerDashboard({super.key});

  @override
  State<PetOwnerDashboard> createState() => _PetOwnerDashboardState();
}

class _PetOwnerDashboardState extends State<PetOwnerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();

  

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    AdoptionHistoryPage(),
    Text('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentProvider>(context, listen: false).fetchAppointmentsForUser();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: PawfectCareTheme.backgroundWhite,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                // Simulate refresh
                await Future.delayed(const Duration(seconds: 1));
              },
              color: PawfectCareTheme.primaryBlue,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 600
                        ? 24
                        : 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildWelcomeSection(),
                      const SizedBox(height: 24),
                      _buildQuickActionsRow(),
                      const SizedBox(height: 32),
                      Consumer<PetProvider>(
                        builder: (context, petProvider, child) {
                          if (petProvider.isLoading) {
                            return const CircularProgressIndicator();
                          }
                          return Column(
                            children: _buildPetsSection(context, petProvider.pets),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      _buildAppointmentsSection(themeProvider),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        "Pawfect Care",
        style: PawfectCareTheme.headingSmall.copyWith(
          color: PawfectCareTheme.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                // Handle notifications
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: PawfectCareTheme.primaryBlue,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '3',
                    style: PawfectCareTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EditUserProfilePage(),
              ),
            );
          },
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: PawfectCareTheme.primaryBlue.withOpacity(0.1),
            child: const Icon(
              Icons.person_outline,
              size: 20,
              color: PawfectCareTheme.primaryBlue,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PawfectCareTheme.primaryBlue.withOpacity(0.1),
            PawfectCareTheme.accentBlue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Pet Parent!',
                  style: PawfectCareTheme.headingSmall.copyWith(
                    color: PawfectCareTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your pets are doing great today!',
                  style: PawfectCareTheme.bodyMedium.copyWith(
                    color: PawfectCareTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.userAddPet);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PawfectCareTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add New Pet',
                    style: PawfectCareTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              size: 32,
              color: PawfectCareTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            'Book Appointment',
            Icons.calendar_today,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AppointmentPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            'Pet Health',
            Icons.favorite_border,
            () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            'Find Vet',
            Icons.location_on_outlined,
            () {},
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: PawfectCareTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: PawfectCareTheme.primaryBlue, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: PawfectCareTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: PawfectCareTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPetsSection(BuildContext context, List<Pet> pets) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "My Pets",
            style: PawfectCareTheme.headingSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.userPetDirectory);
            },
            child: Text(
              'View All',
              style: PawfectCareTheme.bodyMedium.copyWith(
                color: PawfectCareTheme.accentBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 200,
        child: Provider.of<PetProvider>(context).pets.isEmpty
            ? _buildEmptyPetsState()
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: Provider.of<PetProvider>(context).pets.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return _buildPetCard(Provider.of<PetProvider>(context).pets[index], context);
                },
              ),
      ),
    ];
  }

  Widget _buildEmptyPetsState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No pets added yet',
              style: PawfectCareTheme.bodyLarge.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first pet to get started',
              style: PawfectCareTheme.bodyMedium.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetCard(Pet pet, BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Hero(
              tag: 'pet-${pet.petId}',
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: PawfectCareTheme.primaryBlue.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    pet.photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.pets,
                          size: 32,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pet.name,
                    style: PawfectCareTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PawfectCareTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pet.age} years • ${pet.species}',
                    style: PawfectCareTheme.bodyMedium.copyWith(
                      color: PawfectCareTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: pet.isVaccinated
                          ? Colors.green.withOpacity(0.15)
                          : Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      pet.isVaccinated ? 'Vaccinated' : 'Needs Vaccination',
                      style: PawfectCareTheme.bodySmall.copyWith(
                        color: pet.isVaccinated
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.userEditPet);
                    },
                    child: Text(
                      'View Profile →',
                      style: PawfectCareTheme.bodySmall.copyWith(
                        color: PawfectCareTheme.accentBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection(ThemeProvider themeProvider) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PawfectCareTheme.primaryBlue.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Past'),
                  ],
                  labelColor: PawfectCareTheme.primaryBlue,
                  unselectedLabelColor: PawfectCareTheme.textSecondary,
                  indicatorColor: PawfectCareTheme.primaryBlue,
                  indicatorWeight: 3,
                  labelStyle: PawfectCareTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 300,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAppointmentsList(true, themeProvider),
                    _buildAppointmentsList(false, themeProvider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsList(bool isUpcoming, ThemeProvider themeProvider) {
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        if (appointmentProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (appointmentProvider.errorMessage != null) {
          return Center(child: Text(appointmentProvider.errorMessage!));
        }

        final now = DateTime.now();
        final appointments = appointmentProvider.appointments.where((a) {
          if (a.appointmentTime == null) return false;
          return isUpcoming ? a.appointmentTime!.isAfter(now) : a.appointmentTime!.isBefore(now);
        }).toList();

        if (appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isUpcoming ? Icons.event_available : Icons.history,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  isUpcoming ? 'No upcoming appointments' : 'No past appointments',
                  style: PawfectCareTheme.bodyLarge.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return _buildAppointmentCard(appointment, isUpcoming);
          },
        );
      },
    );
  }

  Widget _buildAppointmentCard(
    Appointment appointment,
    bool isUpcoming,
  ) {
    final statusColor = appointment.appointmentStatus == Status.CONFIRMED
        ? Colors.green
        : appointment.appointmentStatus == Status.PENDING
        ? Colors.orange
        : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PawfectCareTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: PawfectCareTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateFormat('MMM d, yyyy').format(appointment.appointmentTime!)} • ${DateFormat('hh:mm a').format(appointment.appointmentTime!)}',
                      style: PawfectCareTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: PawfectCareTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pet: ${appointment.petId}',
                      style: PawfectCareTheme.bodyMedium.copyWith(
                        color: PawfectCareTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appointment.appointmentStatus.name,
                  style: PawfectCareTheme.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Vet: ${appointment.vetId}',
            style: PawfectCareTheme.bodyMedium.copyWith(
              color: PawfectCareTheme.textSecondary,
            ),
          ),
          Text(
            'Service: ${appointment.service}',
            style: PawfectCareTheme.bodyMedium.copyWith(
              color: PawfectCareTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // View appointment details
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: PawfectCareTheme.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'View Details',
                style: PawfectCareTheme.bodyMedium.copyWith(
                  color: PawfectCareTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AppointmentPage(),
          ),
        );
      },
      backgroundColor: PawfectCareTheme.primaryBlue,
      foregroundColor: Colors.white,
      label: Text(
        'Book Appointment',
        style: PawfectCareTheme.bodyMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: const Icon(Icons.add),
    );
  }
}
