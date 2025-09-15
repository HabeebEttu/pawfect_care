import 'package:flutter/material.dart';
import 'package:pawfect_care/pages/login_page.dart';
import 'package:pawfect_care/pages/register_page.dart';
import 'package:pawfect_care/pages/medical_records_history_page.dart';
import 'package:pawfect_care/pages/edit_pet_profile_page.dart';
import 'package:pawfect_care/pages/adoption_management_page.dart';
import 'package:pawfect_care/pages/pet_directory_page.dart';
import 'package:pawfect_care/pages/user_add_pet_page.dart';
import 'package:pawfect_care/pages/user_edit_pet_page.dart';
import 'package:pawfect_care/pages/user_pet_directory_page.dart';
import 'package:pawfect_care/pages/edit_user_profile_page.dart';

class AppRoutes {
  // static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String medicalRecordsHistory = '/medicalRecordsHistory';
  static const String editPetProfile = '/editPetProfile';
  static const String adoptionManagement = '/adoptionManagement';
  static const String petDirectory = '/petDirectory';
  static const String userAddPet = '/userAddPet';
  static const String userEditPet = '/userEditPet';
  static const String userPetDirectory = '/userPetDirectory';
  static const String editUserProfile = '/editUserProfile';


  static Map<String, WidgetBuilder> routes = {
    // splash: (context) => const SplashScreen(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    // medicalRecordsHistory: (context) => const MedicalRecordsHistoryPage(),
    // editPetProfile: (context) => const EditPetProfilePage(),
    adoptionManagement: (context) => const AdoptionManagementPage(),
    petDirectory: (context) => const PetDirectoryPage(),
    userAddPet: (context) => const UserAddPetPage(),
    userEditPet: (context) => const UserEditPetPage(),
    userPetDirectory: (context) => const UserPetDirectoryPage(),
    editUserProfile: (context) => const EditUserProfilePage(),

  };
}
