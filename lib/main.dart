import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pawfect_care/pages/animal_shelter_dashboard.dart';
import 'package:pawfect_care/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:pawfect_care/firebase_options.dart';
import 'package:pawfect_care/pages/pet_owner_dashboard.dart';
import 'package:pawfect_care/pages/login_page.dart';
import 'package:pawfect_care/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider()..initialize(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Show loading screen while theme is initializing
          if (!themeProvider.isInitialized) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getThemeData(context),
            
            title: "Pawfect Care",
            home: const AnimalShelterDashboard(),
            routes: {"/login": (context) => const LoginPage()},
          );
        },
      ),
    );
  }
}
