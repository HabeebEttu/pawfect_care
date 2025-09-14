import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pawfect_care/providers/theme_provider.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:provider/provider.dart';

class AnimalShelterProfilePage extends StatelessWidget {
  const AnimalShelterProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Animal Shelter Profile',
              style: PawfectCareTheme.headingSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
          ),
          backgroundColor: value.getThemeData(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth > 600 ? 32 : 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildWelcomeSection(),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Adoptable Pets', () {}),
                        const SizedBox(height: 16),
                        _buildShelterAnimalSection(constraints),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Recent Adoption Requests', () {}),
                        const SizedBox(height: 16),
                        _buildAdoptionRequestsList(),
                        const SizedBox(height: 32),
                        const SuccessStories(),
                        const SizedBox(height: 32),
                        const SupportOurCauseForm(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
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
        border: Border.all(
          color: PawfectCareTheme.primaryBlue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: PawfectCareTheme.headingMedium.copyWith(
                    color: PawfectCareTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Making a difference in animals\' lives, one adoption at a time.',
                  style: PawfectCareTheme.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.pets,
            size: 48,
            color: PawfectCareTheme.primaryBlue.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: PawfectCareTheme.headingSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton.icon(
          onPressed: onViewAll,
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          label: Text(
            'View All',
            style: PawfectCareTheme.bodyMedium.copyWith(
              color: PawfectCareTheme.accentBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShelterAnimalSection(BoxConstraints constraints) {
    int crossAxisCount;
    if (constraints.maxWidth > 1200) {
      crossAxisCount = 4;
    } else if (constraints.maxWidth > 800) {
      crossAxisCount = 3;
    } else if (constraints.maxWidth > 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildAnimalShelterCard(index),
    );
  }

  Widget _buildAnimalShelterCard(int index) {
    final animals = [
      {
        'name': 'Buddy',
        'type': 'Dog',
        'age': '2 years',
        'tags': ['Vaccinated', 'Trained', 'Friendly'],
      },
      {
        'name': 'Whiskers',
        'type': 'Cat',
        'age': '1 year',
        'tags': ['Vaccinated', 'Indoor', 'Playful'],
      },
      {
        'name': 'Max',
        'type': 'Dog',
        'age': '3 years',
        'tags': ['Vaccinated', 'Active', 'Loyal'],
      },
      {
        'name': 'Luna',
        'type': 'Cat',
        'age': '6 months',
        'tags': ['Vaccinated', 'Curious', 'Gentle'],
      },
      {
        'name': 'Rocky',
        'type': 'Dog',
        'age': '4 years',
        'tags': ['Vaccinated', 'Calm', 'Smart'],
      },
      {
        'name': 'Bella',
        'type': 'Cat',
        'age': '2 years',
        'tags': ['Vaccinated', 'Affectionate', 'Quiet'],
      },
    ];

    final animal = animals[index % animals.length];

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.3),
                        Colors.purple.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/pet_${index % 3 + 1}.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        animal['type'] == 'Dog' ? Icons.pets : Icons.cake,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.red[400],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal['name']!.toString(),
                    style: PawfectCareTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${animal['type']} • ${animal['age']}',
                    style: PawfectCareTheme.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: (animal['tags'] as List<String>)
                        .take(2)
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: PawfectCareTheme.primaryBlue.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: PawfectCareTheme.primaryBlue.withOpacity(
                                  0.3,
                                ),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: PawfectCareTheme.bodySmall.copyWith(
                                color: PawfectCareTheme.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PawfectCareTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(
                        'View Profile',
                        style: PawfectCareTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdoptionRequestsList() {
    final requests = [
      {
        'name': 'Alice Johnson',
        'pet': 'Buddy',
        'status': 'Pending',
        'time': '2 hours ago',
      },
      {
        'name': 'John Smith',
        'pet': 'Whiskers',
        'status': 'Approved',
        'time': '5 hours ago',
      },
      {
        'name': 'Emma Davis',
        'pet': 'Max',
        'status': 'Under Review',
        'time': '1 day ago',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: PawfectCareTheme.primaryBlue.withOpacity(0.1),
              child: Text(
                request['name']![0],
                style: TextStyle(
                  color: PawfectCareTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              request['name']!,
              style: PawfectCareTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Interested in: ${request['pet']}'),
                const SizedBox(height: 4),
                Text(
                  request['time']!,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize:MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request['status']!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getStatusColor(
                        request['status']!,
                      ).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    request['status']!,
                    style: TextStyle(
                      color: _getStatusColor(request['status']!),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Under Review':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class SuccessStories extends StatelessWidget {
  const SuccessStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Success Stories",
              style: PawfectCareTheme.headingSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              label: Text(
                "View More",
                style: TextStyle(
                  color: PawfectCareTheme.accentBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) => _buildSuccessStoryCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessStoryCard(int index) {
    final stories = [
      {
        'title': 'Bella Finds Forever Home!',
        'description':
            'After months at the shelter, Bella, a charming calico cat, has finally found her perfect family.',
        'gradient': [Colors.pink, Colors.purple],
      },
      {
        'title': 'Max\'s New Adventure!',
        'description':
            'This energetic golden retriever now has a backyard to play in and children who adore him.',
        'gradient': [Colors.orange, Colors.red],
      },
      {
        'title': 'Luna\'s Happy Ending!',
        'description':
            'A shy kitten transforms into a confident companion with her new loving owner.',
        'gradient': [Colors.blue, Colors.teal],
      },
      {
        'title': 'Rocky\'s Second Chance!',
        'description':
            'This senior dog proves age is just a number with his new retirement family.',
        'gradient': [Colors.green, Colors.lightGreen],
      },
    ];

    final story = stories[index % stories.length];

    return Container(
      width: 300,
      child: Card(
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: (story['gradient'] as List<Color>)
                      .map((color) => color.withOpacity(0.8))
                      .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story['title']!.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    story['description']!.toString(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        "Read More",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
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
}

class SupportOurCauseForm extends StatefulWidget {
  const SupportOurCauseForm({super.key});

  @override
  State<SupportOurCauseForm> createState() => _SupportOurCauseFormState();
}

class _SupportOurCauseFormState extends State<SupportOurCauseForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Support Our Cause",
                  style: PawfectCareTheme.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join our mission to provide loving homes for animals in need.",
                  style: PawfectCareTheme.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildDonationForm()),
                      const SizedBox(width: 32),
                      Expanded(child: const VolunteeringForm()),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildDonationForm(),
                      const SizedBox(height: 32),
                      const VolunteeringForm(),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDonationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Make a Donation",
            style: PawfectCareTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: PawfectCareTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: "Donation Amount",
              hintText: "e.g., \$50",
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: PawfectCareTheme.primaryBlue),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter an amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Full Name",
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: PawfectCareTheme.primaryBlue),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email Address",
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: PawfectCareTheme.primaryBlue),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your email';
              }
              if (!EmailValidator.validate(value!)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: PawfectCareTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Handle donation submission
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thank you for your donation!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.favorite, size: 20),
              label: const Text(
                "Donate Now",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VolunteeringForm extends StatefulWidget {
  const VolunteeringForm({super.key});

  @override
  State<VolunteeringForm> createState() => _VolunteeringFormState();
}

class _VolunteeringFormState extends State<VolunteeringForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Become a Volunteer",
            style: PawfectCareTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Full Name",
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email Address",
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your email';
              }
              if (!EmailValidator.validate(value!)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Phone Number",
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your phone number';
              }
              if (value!.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _interestController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Tell us about your interest and availability",
              hintText: "I\'m interested in...",
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: Icon(Icons.edit_note),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal),
              ),
            ),
          ),
          const SizedBox(height: 16),

          CheckboxListTile(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Wrap(
              children: [
                const Text("I agree to the "),
                GestureDetector(
                  onTap: () {
                    // Handle terms and conditions tap
                  },
                  child: const Text(
                    "terms and conditions",
                    style: TextStyle(
                      color: Colors.teal,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: _isChecked
                  ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle volunteer application submission
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Thank you for your volunteer application!',
                            ),
                            backgroundColor: Colors.teal,
                          ),
                        );
                      }
                    }
                  : null,
              icon: const Icon(Icons.volunteer_activism, size: 20),
              label: const Text(
                "Submit Application",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _interestController.dispose();
    super.dispose();
  }
}
