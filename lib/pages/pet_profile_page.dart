import 'package:flutter/material.dart';
import 'package:pawfect_care/theme/theme.dart';
class PetProfilePage extends StatefulWidget {
  const PetProfilePage({super.key});

  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Profile',style: PawfectCareTheme.headingSmall,),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new)),
          actions:[
            IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.notifications_none_outlined)
          )
          ]
        ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Card(
                  
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                    
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: PawfectCareTheme.dividerGray,
                              border: Border.all(
                                color: PawfectCareTheme.dividerGray,
                                width: 2.0,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                'https://placehold.co/200x200/E5E5E5/718096?text=Dog',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.pets, size: 60, color: PawfectCareTheme.textMuted),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                         
                          Text(
                            'Buddy',
                            style: PawfectCareTheme.headingMedium.copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '3 years old',
                            style: PawfectCareTheme.bodySmall.copyWith(color: PawfectCareTheme.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Golden Retriever',
                            style: PawfectCareTheme.bodyMedium.copyWith(color: PawfectCareTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite_border,
                              color: PawfectCareTheme.primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Health Status',
                              style: PawfectCareTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: PawfectCareTheme.getStatusBadgeDecoration('excellent'),
                              child: Text(
                                'Excellent',
                                style: PawfectCareTheme.getStatusTextStyle(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Buddy is in excellent health, active and playful.',
                          style: PawfectCareTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.vaccines,
                                  color: PawfectCareTheme.primaryBlue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Vaccinations',
                                  style: PawfectCareTheme.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rabies',
                                  style: PawfectCareTheme.bodyMedium,
                                ),
                                Text(
                                  'Date: 2023-10-20',
                                  style: PawfectCareTheme.bodySmall,
                                ),
                                const Divider(
                                  height: 16,
                                  thickness: 1,
                                  color: PawfectCareTheme.dividerGray,
                                ),
                                Text(
                                  'Distemper',
                                  style: PawfectCareTheme.bodyMedium,
                                ),
                                Text(
                                  'Date: 2023-11-15',
                                  style: PawfectCareTheme.bodySmall,
                                ),
                                const Divider(
                                  height: 16,
                                  thickness: 1,
                                  color: PawfectCareTheme.dividerGray,
                                ),
                                Text(
                                  'Bordetella',
                                  style: PawfectCareTheme.bodyMedium,
                                ),
                                Text(
                                  'Date: 2024-01-05',
                                  style: PawfectCareTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite_border,
                                  color: PawfectCareTheme.primaryBlue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Allergies',
                                  style: PawfectCareTheme.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pollen',
                                  style: PawfectCareTheme.bodyMedium,
                                ),
                                Text(
                                  'Reaction: Seasonal itching',
                                  style: PawfectCareTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.notifications_none,
                                  color: PawfectCareTheme.primaryBlue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Reminders',
                                  style: PawfectCareTheme.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Annual Check-up',
                              style: PawfectCareTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
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