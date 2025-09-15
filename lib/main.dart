import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:pawfect_care/providers/pet_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:pawfect_care/firebase_options.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/providers/theme_provider.dart';
import 'package:pawfect_care/providers/user_provider.dart';
import 'package:pawfect_care/providers/medical_record_provider.dart';
import 'package:pawfect_care/providers/vet_service_provider.dart';
import 'package:pawfect_care/providers/appointment_provider.dart';
import 'package:pawfect_care/routes/app_routes.dart';
import 'package:pawfect_care/role_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await dotenv.load(fileName: ".env");
   await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(riverpod.ProviderScope(child: const MyApp()));
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
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<AuthProvider, PetProvider>(
          create: (context) => PetProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (context, auth, previous) => PetProvider(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, MedicalRecordProvider>(
          create: (context) => MedicalRecordProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (context, auth, previous) => MedicalRecordProvider(auth),
        ),
        ChangeNotifierProvider<VetProvider>(create: (_) => VetProvider()),
        ChangeNotifierProxyProvider<AuthProvider, AppointmentProvider>(
          create: (context) => AppointmentProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (context, auth, previous) => AppointmentProvider(auth),
        ),
        
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
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
            home: RoleWrapper(),
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
