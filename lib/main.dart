import 'package:dev_partner/View/screens/browse_profile.dart';
import 'package:dev_partner/View/screens/create_profile.dart';
import 'package:dev_partner/View/screens/home_screen.dart';
import 'package:dev_partner/View/screens/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'View/screens/login.dart';
import 'View/screens/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'dEVPartner',
      home: OnboardingScreen(),
    );
  }
}
