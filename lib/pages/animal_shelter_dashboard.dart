import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pawfect_care/providers/theme_provider.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:provider/provider.dart';

class AnimalShelterDashboard extends StatelessWidget {
  const AnimalShelterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Animal Shelter Dashboard',
              style: PawfectCareTheme.headingSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: value.getThemeData(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Adoptable Pets',
                      style: PawfectCareTheme.headingMedium,
                    ),
                    SizedBox(height: 20),
                    _buildShelterAnimalSection(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Adoption Requests',
                          style: PawfectCareTheme.headingSmall,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All',
                            style: PawfectCareTheme.bodyMedium.copyWith(
                              color: PawfectCareTheme.accentBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,

                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/person.png',
                                ),
                                radius: 30,
                              ),
                              title: Text('Alice Johnson'),
                              subtitle: Text('For: buddy'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withValues(
                                        alpha: 0.3,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Pending',
                                      style: PawfectCareTheme.bodySmall
                                          .copyWith(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Icon(Icons.navigate_next, size: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SuccessStories(),
                    SizedBox(height: 20),
                    SupportOurCauseForm(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox _buildShelterAnimalSection() {
    return SizedBox(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        childAspectRatio: 0.58,
        physics: const BouncingScrollPhysics(),
        children: List.generate(5, (index) {
          return _buildAnimalShelterCard(index);
        }),
      ),
    );
  }

  Card _buildAnimalShelterCard(int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.asset(
                'assets/images/pet_${index % 3 + 1}.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
              ),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Buddy',
                      style: PawfectCareTheme.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Dog',
                        style: PawfectCareTheme.bodyLarge.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        ', 2 years old',
                        style: PawfectCareTheme.bodyLarge.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: PawfectCareTheme.primaryBlue.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      child: Text(
                        'Vaccinated',
                        style: PawfectCareTheme.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: PawfectCareTheme.primaryBlue.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      child: Text(
                        'Vaccinated',
                        style: PawfectCareTheme.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: PawfectCareTheme.primaryBlue.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      child: Text(
                        'Vaccinated',
                        style: PawfectCareTheme.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: PawfectCareTheme.elevatedButtonTheme.style!
                        .copyWith(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 0,
                      ),
                      child: Text(
                        'View Profile',
                        style: PawfectCareTheme.bodyMedium.copyWith(
                          color: Colors.white,
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
}

class SuccessStories extends StatelessWidget {
  const SuccessStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Success Stories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "View More",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 210,
          child: ListView.separated(
            padding: const EdgeInsets.only(right: 12),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _buildSuccessStoryCard(),
          ),
        ),
      ],
    );
  }

  SizedBox _buildSuccessStoryCard() {
    return SizedBox(
      height: 200,
      width: 280,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Positioned.fill(
              // child: Image.network(
              //   "https://placekitten.com/600/400",
              //   fit: BoxFit.cover,
              // ),
              child: Placeholder(),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bella Finds Forever Home!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "After months at the shelter, Bella, a charming calico cat, has finally found",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Read More",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                child: Column(
                  children: [
                    Text(
                      "Support Our Cause",
                      style: PawfectCareTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),

                    Text(
                      "Join our mission to provide loving homes for animals in need.",
                      style: PawfectCareTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      "Make a Donation",
                      style: PawfectCareTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: _amountController,
                      decoration: InputDecoration(
                        hintText: "Amount (e.g., \$50)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Your Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Your Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.send, size: 18),
                        label: const Text(
                          "Donate Now",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              VolunteeringForm(),
            ],
          ),
        ),
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
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _intrestController = TextEditingController();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Become a Volunteer",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          TextFormField(
            decoration: InputDecoration(
              hintText: "Full Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            controller: _nameController,
          ),
          const SizedBox(height: 10),

          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: "Email Address",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Email should not be empty';
              } else if (!EmailValidator.validate(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          TextFormField(
            controller: _numberController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter a  phone number';
              } else if (value.length < 10) {
                return 'Enter a valid phone number';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Phone Number",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),

          TextFormField(
            controller: _intrestController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Tell us about your interest and availability",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = !isChecked;
                    value = isChecked;
                  });
                },
              ),
              Flexible(
                child: Wrap(
                  children: const [
                    Text("I agree to the "),
                    Text(
                      "terms and conditions",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.favorite_border, size: 18),
              label: const Text(
                "Submit Application",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
