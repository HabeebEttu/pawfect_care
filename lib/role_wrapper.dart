import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/role.dart';
import 'package:pawfect_care/pages/animal_shelter_dashboard.dart';
import 'package:pawfect_care/pages/pet_owner_dashboard.dart';
import 'package:pawfect_care/pages/vet_dashboard.dart';
import 'package:pawfect_care/pages/login_page.dart';

class RoleWrapper extends StatelessWidget {
  const RoleWrapper({super.key});

  Future<Role?> _fetchRole(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final roleString = doc.data()?['role'] as String?;
    if (roleString == null) return null;
    return Role.values.firstWhere(
          (r) => r.name == roleString,
      orElse: () => Role.user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fb.User?>(
      stream: fb.FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final fbUser = authSnap.data;
        if (fbUser == null) return const LoginPage();

        return FutureBuilder<Role?>(
          future: _fetchRole(fbUser.uid),
          builder: (context, roleSnap) {
            if (roleSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            final role = roleSnap.data ?? Role.user;

            switch (role) {
              case Role.shelter:
                return const AnimalShelterDashboard();
              case Role.vet:
                return const VeterinarianDashboard();
              case Role.user:
              default:
                return const PetOwnerDashboard();
            }
          },
        );
      },
    );
  }
}
