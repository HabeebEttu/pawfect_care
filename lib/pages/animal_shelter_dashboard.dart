import 'package:flutter/material.dart';
import 'package:pawfect_care/pages/add_pet_page.dart';
import 'package:pawfect_care/providers/shelter_provider.dart';
import 'package:pawfect_care/providers/theme_provider.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:pawfect_care/routes/app_routes.dart';
import 'package:pawfect_care/models/adoption_status.dart';
import 'package:pawfect_care/models/adoption_status.dart';

class AnimalShelterDashboard extends StatefulWidget {
  const AnimalShelterDashboard({super.key});

  @override
  State<AnimalShelterDashboard> createState() => _AnimalShelterDashboardState();
}

class _AnimalShelterDashboardState extends State<AnimalShelterDashboard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return 
    Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              'Animal Shelter',
              style: PawfectCareTheme.headingSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    PawfectCareTheme.primaryBlue,
                    PawfectCareTheme.lightBlue,
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.editUserProfile);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: PawfectCareTheme.backgroundWhite,
          body: CustomScrollView(
            slivers: [
              // Hero section with background image
              SliverToBoxAdapter(
                child: Container(
                  height: 307,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        PawfectCareTheme.primaryBlue,
                        PawfectCareTheme.lightBlue,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background pattern/illustration
                      Positioned(
                        right: -50,
                        top: 50,
                        child: Opacity(
                          opacity: 0.1,
                          child: Icon(
                            Icons.pets,
                            size: 200,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30,
                        bottom: -20,
                        child: Opacity(
                          opacity: 0.1,
                          child: Icon(
                            Icons.favorite,
                            size: 150,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back! 👋',
                              style: PawfectCareTheme.headingLarge.copyWith(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Managing your shelter with love and care',
                              style: PawfectCareTheme.bodyLarge.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Quick stats row
                            Consumer<ShelterProvider>(
                              builder: (context, shelterProvider, child) {
                                if (shelterProvider.isLoading || shelterProvider.shelter == null) {
                                  return const CircularProgressIndicator(); // Or a loading skeleton
                                }

                                final totalPets = shelterProvider.shelter!.animals.length;
                                final adoptedPets = shelterProvider.shelter!.adoptionRecords
                                    .where((record) => record.status == AdoptionStatus.approved)
                                    .length;
                                final availablePets = totalPets - adoptedPets;

                                return Row(
                                  children: [
                                    _buildHeroStat(totalPets.toString(), 'Total Pets', Icons.pets),
                                    const SizedBox(width: 20),
                                    _buildHeroStat(availablePets.toString(), 'Available', Icons.home),
                                    const SizedBox(width: 20),
                                    _buildHeroStat(adoptedPets.toString(), 'Adopted', Icons.favorite),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main content
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Quick Actions Section
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: PawfectCareTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Quick Actions',
                          style: PawfectCareTheme.headingSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount;
                        double childAspectRatio;

                        if (constraints.maxWidth > 800) {
                          crossAxisCount = 3;
                          childAspectRatio = 1.1;
                        } else if (constraints.maxWidth > 600) {
                          crossAxisCount = 2;
                          childAspectRatio = 1.0;
                        } else {
                          crossAxisCount = 2;
                          childAspectRatio = 0.9;
                        }

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: childAspectRatio,
                          children: [
                            _buildActionCard(
                              context,
                              icon: Icons.add_circle_outline,
                              label: 'Add Pet',
                              description: 'Register new animals',
                              gradient: [
                                PawfectCareTheme.successGreen,
                                PawfectCareTheme.successGreen.withOpacity(0.7),
                              ],
                              illustration: '🐕',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddPetPage(),
                                  ),
                                );
                              },
                            ),
                            _buildActionCard(
                              context,
                              icon: Icons.edit_note,
                              label: 'Update Profile',
                              description: 'Edit pet information',
                              gradient: [
                                PawfectCareTheme.primaryBlue,
                                PawfectCareTheme.lightBlue,
                              ],
                              illustration: '✏️',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.editPetProfile,
                                );
                              },
                            ),
                            _buildActionCard(
                              context,
                              icon: Icons.volunteer_activism,
                              label: 'Adoption Center',
                              description: 'Process adoptions',
                              gradient: [
                                PawfectCareTheme.warningYellow,
                                PawfectCareTheme.warningYellow.withOpacity(0.7),
                              ],
                              illustration: '❤️',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.adoptionManagement,
                                );
                              },
                            ),
                            _buildActionCard(
                              context,
                              icon: Icons.medical_services_outlined,
                              label: 'Health Records',
                              description: 'Manage medical data',
                              gradient: [
                                PawfectCareTheme.statusUpcoming,
                                PawfectCareTheme.statusUpcoming.withOpacity(
                                  0.7,
                                ),
                              ],
                              illustration: '🏥',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.medicalRecordsHistory,
                                );
                              },
                            ),
                            _buildActionCard(
                              context,
                              icon: Icons.pets,
                              label: 'View All Pets',
                              description: 'Browse pet directory',
                              gradient: [
                                PawfectCareTheme.accentBlue,
                                PawfectCareTheme.lightBlue,
                              ],
                              illustration: '🐱',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.petDirectory,
                                );
                              },
                            ),
                            _buildActionCard(
                              context,
                              icon: Icons.delete_outline,
                              label: 'Archive Pet',
                              description: 'Remove pet records',
                              gradient: [
                                PawfectCareTheme.errorRed,
                                PawfectCareTheme.errorRed.withOpacity(0.7),
                              ],
                              illustration: '📋',
                              onTap: () => _showRemoveDialog(context),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Recent Activity Section
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: PawfectCareTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Recent Activity',
                          style: PawfectCareTheme.headingSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildActivityCard(
                      'New Adoption',
                      'Buddy the Golden Retriever found a loving home! 🎉',
                      '2 hours ago',
                      PawfectCareTheme.successGreen,
                      Icons.favorite,
                    ),
                    const SizedBox(height: 12),
                    _buildActivityCard(
                      'Health Checkup',
                      'Whiskers completed vaccination schedule',
                      '5 hours ago',
                      PawfectCareTheme.statusUpcoming,
                      Icons.medical_services,
                    ),
                    const SizedBox(height: 12),
                    _buildActivityCard(
                      'New Arrival',
                      'Luna the rescued kitten needs immediate care',
                      '1 day ago',
                      PawfectCareTheme.warningYellow,
                      Icons.add_circle,
                    ),
                  ]),
                ),
              ),
            ],
          ),
          // Floating Action Button
          floatingActionButton: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  PawfectCareTheme.primaryBlue,
                  PawfectCareTheme.lightBlue,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: PawfectCareTheme.primaryBlue.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPetPage(),
                  ),
                );
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Quick Add',
                style: PawfectCareTheme.buttonText.copyWith(fontSize: 14),
              ),
            ),
          ),
        );
      },
    );
  }
   
  }

  Widget _buildHeroStat(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: PawfectCareTheme.headingSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: PawfectCareTheme.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required List<Color> gradient,
    required String illustration,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    Text(illustration, style: const TextStyle(fontSize: 24)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: PawfectCareTheme.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: PawfectCareTheme.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String description,
    String time,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: PawfectCareTheme.cardDecoration.copyWith(
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: PawfectCareTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(description, style: PawfectCareTheme.bodySmall),
              ],
            ),
          ),
          Text(
            time,
            style: PawfectCareTheme.caption.copyWith(
              color: PawfectCareTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showActionDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title, style: PawfectCareTheme.headingSmall),
          content: Text(message, style: PawfectCareTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: PawfectCareTheme.primaryBlue,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Archive Pet',
            style: PawfectCareTheme.headingSmall.copyWith(
              color: PawfectCareTheme.errorRed,
            ),
          ),
          content: Text(
            'Are you sure you want to archive this pet record? This action can be undone later.',
            style: PawfectCareTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: PawfectCareTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Pet archived successfully'),
                    backgroundColor: PawfectCareTheme.successGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PawfectCareTheme.errorRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Archive'),
            ),
          ],
        );
      },
    );
  }

