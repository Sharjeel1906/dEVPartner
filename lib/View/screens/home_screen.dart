import 'package:dev_partner/View/screens/browse_profile.dart';
import 'package:dev_partner/View/screens/browse_teams.dart';
import 'package:dev_partner/View/widgets/theme.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:dev_partner/View/screens/create_profile.dart';
import 'package:dev_partner/View/screens/login.dart';
import 'package:dev_partner/View/screens/register.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of screens
  final List<Widget> screens = [
    BrowseProfileScreen(),
    BrowseTeamsScreen(),
    LoginScreen(),
    RegisterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      // Render the currently selected screen
      body: screens[_currentIndex],

      // Bottom Navigation Bar
        bottomNavigationBar: bottomNavigationBarUI(
          context: context,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        )
    );
  }
}