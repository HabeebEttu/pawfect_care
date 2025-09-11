import 'package:flutter/material.dart';
import 'package:pawfect_care/pages/home_page.dart';
import 'package:pawfect_care/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        "/login":(context)=>const LoginPage()
      },
      title: "Pawfect Care",
    );
  }
}