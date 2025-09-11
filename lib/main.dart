import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pawfect_care/firebase_options.dart';
import 'package:pawfect_care/pages/home_page.dart';
import 'package:pawfect_care/pages/login_page.dart';
import 'package:pawfect_care/providers/auth_provider.dart'; // Import your AuthProvider

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

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Pawfect Care",
        home: HomePage(),
        routes: {"/login": (context) => const LoginPage()},
      ),
    );
  }
}
