import 'package:flutter/material.dart';
import 'package:pawfect_care/models/gender.dart';
import 'package:pawfect_care/models/pet.dart';
import 'package:pawfect_care/providers/theme_provider.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Pet> dummyPets = [
      Pet(
        name: 'Whiskers',
        petId: 'whis_1234',
        userId: 'dummy',
        age: 2,
        gender: Gender.male,
        photoUrl: 'assets/images/pet_1.png',
        species: 'Cat',
        isVaccinated: false,
      ),
      Pet(
        name: 'Bubbles',
        petId: 'bubb_1234',
        userId: 'dummy',
        age: 4,
        gender: Gender.female,
        photoUrl: 'assets/images/pet_3.png',
        species: 'Dog',
        isVaccinated: false,
      ),
      Pet(
        name: 'Scooby',
        petId: 'scob_3434',
        userId: 'dummy',
        age: 5,
        gender: Gender.male,
        photoUrl: 'assets/images/pet_3.png',
        species: 'Dog',
        isVaccinated: false,
      ),
    ];
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Pawfect Care",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(color: Colors.black54),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: PawfectCareTheme.backgroundWhite,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildPetsArea(context, dummyPets),
                  SizedBox(height: 10),
                 ..._buildAppoinmentSection(themeProvider),
                 SizedBox(height: 20,),
                 ..._buildPastAppointments(themeProvider)
                  
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildPastAppointments(ThemeProvider themeProvider) {
    return [ Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Past Appointments',
                  style: PawfectCareTheme.headingSmall,
                ),
              ),
              SizedBox(
                child: ListView.builder(
                  itemBuilder: (context, index) => _buildAppointmentCard(themeProvider, context),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                ),
              ),];
  }

  List<Widget> _buildAppoinmentSection(ThemeProvider themeProvider) {
    return [ Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Upcoming Appointments',
                    style: PawfectCareTheme.headingSmall,
                  ),
                ),
                SizedBox(
                  child: ListView.builder(
                    itemBuilder: (context, index) => _buildAppointmentCard(themeProvider, context),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 2,
                  ),
                ),];
  }

  Card _buildAppointmentCard(ThemeProvider themeProvider, BuildContext context) {
    return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dec 23,2023 ',
                              style: PawfectCareTheme.priceText,
                            ),
                            Text(
                              '• 10:00AM',
                              style: themeProvider
                                  .getThemeData(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                        Text('Vet: Dr Emily White'),
                        Text('Service: Annual check up'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status:'),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 10
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300,
                              ),
                              child: Text(
                                'Upcoming',
                                style: PawfectCareTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: PawfectCareTheme.outlinedButtonTheme.style!
                              .copyWith(
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: Colors.blueAccent,
                                    width: 1.3,
                                  ),
                                ),
                              ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 22,
                            ),
                            child: Text(
                              'View Details',
                              style: PawfectCareTheme.priceText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
  }

  List<Widget> _buildPetsArea(BuildContext context, List<Pet> dummyPets) {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          "My Pets",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: ListView.builder(
            itemBuilder: (context, index) {
              Pet pet = dummyPets[index];
              return _buildPetsCard(pet, context);
            },
            itemCount: dummyPets.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ),
    ];
  }

  Card _buildPetsCard(Pet pet, BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 20,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundImage: AssetImage(pet.photoUrl),
              radius: 40,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                pet.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8),
              Text(
                '${pet.age} years • ${pet.species}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200,
                ),
                margin: EdgeInsets.only(right: 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 3),
                  child: Text(
                    pet.isVaccinated ? 'vaccinated' : 'Not Vaccinated',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
