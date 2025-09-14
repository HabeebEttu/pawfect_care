import 'package:pawfect_care/models/adoption_record.dart';
import 'package:pawfect_care/models/adoption_status.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/services/adoption_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:pawfect_care/theme/theme.dart';

class PetProfilePage extends StatefulWidget {
  const PetProfilePage({super.key});

  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildPetInfoCard(),
                  const SizedBox(height: 24),
                  _buildTabSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: PawfectCareTheme.primaryBlue,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              _showEditPetDialog();
            },
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              // Handle notifications
            },
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                PawfectCareTheme.primaryBlue,
                PawfectCareTheme.accentBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Hero(
                tag: 'pet-avatar',
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://placehold.co/200x200/E5E5E5/718096?text=Dog',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade100,
                        child: const Icon(
                          Icons.pets,
                          size: 60,
                          color: PawfectCareTheme.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Buddy',
                style: PawfectCareTheme.headingLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Golden Retriever • 3 years old',
                style: PawfectCareTheme.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetInfoCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Weight',
                    '28 kg',
                    Icons.monitor_weight_outlined,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                Expanded(
                  child: _buildInfoItem('Height', '65 cm', Icons.height),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                Expanded(child: _buildInfoItem('Gender', 'Male', Icons.pets)),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Health Status',
                          style: PawfectCareTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Excellent - Active and playful',
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
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Excellent',
                      style: PawfectCareTheme.bodySmall.copyWith(
                        color: Colors.white,
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

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: PawfectCareTheme.primaryBlue, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: PawfectCareTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: PawfectCareTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: PawfectCareTheme.bodySmall.copyWith(
            color: PawfectCareTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTabSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Vaccines'),
                Tab(text: 'Medical'),
                Tab(text: 'Allergies'),
                Tab(text: 'Notes'),
              ],
              labelColor: PawfectCareTheme.primaryBlue,
              unselectedLabelColor: PawfectCareTheme.textSecondary,
              indicatorColor: PawfectCareTheme.primaryBlue,
              indicatorWeight: 3,
              labelStyle: PawfectCareTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: PawfectCareTheme.bodyMedium,
            ),
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVaccinationsTab(),
                _buildMedicalTab(),
                _buildAllergiesTab(),
                _buildNotesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationsTab() {
    final vaccinations = [
      {
        'name': 'Rabies',
        'date': '2023-10-20',
        'nextDue': '2024-10-20',
        'status': 'Current',
      },
      {
        'name': 'Distemper',
        'date': '2023-11-15',
        'nextDue': '2024-11-15',
        'status': 'Current',
      },
      {
        'name': 'Bordetella',
        'date': '2024-01-05',
        'nextDue': '2025-01-05',
        'status': 'Current',
      },
      {
        'name': 'Parvovirus',
        'date': '2023-09-10',
        'nextDue': '2024-09-10',
        'status': 'Due Soon',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vaccinations.length,
      itemBuilder: (context, index) {
        final vaccine = vaccinations[index];
        final isDueSoon = vaccine['status'] == 'Due Soon';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDueSoon
                ? Colors.orange.withOpacity(0.05)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDueSoon
                  ? Colors.orange.withOpacity(0.3)
                  : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDueSoon
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.vaccines,
                  color: isDueSoon
                      ? Colors.orange.shade700
                      : Colors.green.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vaccine['name']!,
                      style: PawfectCareTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last: ${vaccine['date']}',
                      style: PawfectCareTheme.bodySmall.copyWith(
                        color: PawfectCareTheme.textSecondary,
                      ),
                    ),
                    Text(
                      'Next due: ${vaccine['nextDue']}',
                      style: PawfectCareTheme.bodySmall.copyWith(
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
                  color: isDueSoon
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  vaccine['status']!,
                  style: PawfectCareTheme.bodySmall.copyWith(
                    color: isDueSoon
                        ? Colors.orange.shade700
                        : Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMedicalTab() {
    final medicalRecords = [
      {
        'date': '2024-08-15',
        'type': 'Annual Check-up',
        'vet': 'Dr. Emily White',
        'notes': 'Excellent health, maintain current diet',
        'icon': Icons.medical_services,
      },
      {
        'date': '2024-06-20',
        'type': 'Dental Cleaning',
        'vet': 'Dr. Michael Brown',
        'notes': 'Teeth cleaned, no issues found',
        'icon': Icons.healing,
      },
      {
        'date': '2024-03-10',
        'type': 'Skin Treatment',
        'vet': 'Dr. Sarah Johnson',
        'notes': 'Treated minor skin irritation',
        'icon': Icons.medical_information,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: medicalRecords.length,
      itemBuilder: (context, index) {
        final record = medicalRecords[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      record['icon'] as IconData,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record['type'] as String,
                          style: PawfectCareTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          record['date'] as String,
                          style: PawfectCareTheme.bodySmall.copyWith(
                            color: PawfectCareTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Vet: ${record['vet']}',
                style: PawfectCareTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                record['notes'] as String,
                style: PawfectCareTheme.bodyMedium.copyWith(
                  color: PawfectCareTheme.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAllergiesTab() {
    final allergies = [
      {
        'name': 'Pollen',
        'severity': 'Mild',
        'reaction': 'Seasonal sneezing and itching',
        'treatment': 'Antihistamine as needed',
      },
      {
        'name': 'Chicken',
        'severity': 'Moderate',
        'reaction': 'Digestive upset, skin irritation',
        'treatment': 'Avoid chicken-based foods',
      },
    ];

    if (allergies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No Known Allergies',
              style: PawfectCareTheme.headingSmall.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Buddy has no recorded allergies',
              style: PawfectCareTheme.bodyMedium.copyWith(
                color: PawfectCareTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allergies.length,
      itemBuilder: (context, index) {
        final allergy = allergies[index];
        final isModerate = allergy['severity'] == 'Moderate';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isModerate
                ? Colors.red.withOpacity(0.05)
                : Colors.orange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isModerate
                  ? Colors.red.withOpacity(0.3)
                  : Colors.orange.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isModerate
                          ? Colors.red.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.warning_outlined,
                      color: isModerate
                          ? Colors.red.shade700
                          : Colors.orange.shade700,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      allergy['name']!,
                      style: PawfectCareTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isModerate
                          ? Colors.red.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      allergy['severity']!,
                      style: PawfectCareTheme.bodySmall.copyWith(
                        color: isModerate
                            ? Colors.red.shade700
                            : Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Reaction: ${allergy['reaction']}',
                style: PawfectCareTheme.bodyMedium.copyWith(
                  color: PawfectCareTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Treatment: ${allergy['treatment']}',
                style: PawfectCareTheme.bodyMedium.copyWith(
                  color: PawfectCareTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.note_outlined,
                      color: PawfectCareTheme.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Behavioral Notes',
                      style: PawfectCareTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: PawfectCareTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Buddy is very social and loves playing with other dogs. He responds well to positive reinforcement and enjoys learning new tricks. Gets excited during thunderstorms - may need calming support.',
                  style: PawfectCareTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.restaurant_outlined,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dietary Preferences',
                      style: PawfectCareTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Prefers salmon-based food. Enjoys carrots and apples as treats. Avoid giving too many treats as he tends to gain weight easily.',
                  style: PawfectCareTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, color: Colors.purple, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Daily Routine',
                      style: PawfectCareTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Morning walk at 7 AM, feeding at 8 AM and 6 PM. Enjoys afternoon play time in the yard. Bedtime routine around 9 PM.',
                  style: PawfectCareTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // _showAdoptPetDialog();
      },
      backgroundColor: PawfectCareTheme.primaryBlue,
      foregroundColor: Colors.white,
      child: const Icon(Icons.pets),
    );
  }

  void _showEditPetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit Pet Profile',
          style: PawfectCareTheme.headingSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Would you like to update Buddy\'s information?',
          style: PawfectCareTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: PawfectCareTheme.bodyMedium.copyWith(
                color: PawfectCareTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to edit screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PawfectCareTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showAdoptPetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Adopt Buddy',
          style: PawfectCareTheme.headingSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to adopt Buddy?',
          style: PawfectCareTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: PawfectCareTheme.bodyMedium.copyWith(
                color: PawfectCareTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              final user = authProvider.user;
              if (user == null) {
                // Handle user not logged in
                return;
              }

              final adoptionService = AdoptionService();
              final record = AdoptionRecord(
                adoptionId: ' ',
                petId: 'buddy', // Replace with actual pet ID
                userId: user.uid,
                adoptionDate: DateTime.now(),
                status: AdoptionStatus.pending,
              );

              await adoptionService.createAdoptionRecord(record, 'shelterId');
              // await adoptionService.updatePetStatus('buddy', true); // Replace with actual pet ID

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Adoption request sent!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PawfectCareTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Adopt'),
          ),
        ],
      ),
    );
  }

  void _showQuickActionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Quick Actions',
                style: PawfectCareTheme.headingSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildQuickActionItem(
                'Book Appointment',
                Icons.calendar_today,
                () {},
              ),
              _buildQuickActionItem(
                'Add Medical Record',
                Icons.medical_services,
                () {},
              ),
              _buildQuickActionItem(
                'Update Vaccination',
                Icons.vaccines,
                () {},
              ),
              _buildQuickActionItem('Add Note', Icons.note_add, () {}),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionItem(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: PawfectCareTheme.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: PawfectCareTheme.primaryBlue, size: 20),
      ),
      title: Text(
        title,
        style: PawfectCareTheme.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

}
