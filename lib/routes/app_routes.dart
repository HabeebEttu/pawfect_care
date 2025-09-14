import 'package:flutter/material.dart';
import 'package:pawfect_care/pages/login_page.dart';
import 'package:pawfect_care/pages/register_page.dart';

class AppRoutes {
  // static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';


  static Map<String, WidgetBuilder> routes = {
    // splash: (context) => const SplashScreen(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),

  };
}
