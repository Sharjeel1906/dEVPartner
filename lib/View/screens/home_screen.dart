import 'package:dev_partner/View/screens/browse_profile.dart';
import 'package:dev_partner/View/screens/browse_teams.dart';
import 'package:dev_partner/View/widgets/theme.dart';
import 'package:dev_partner/model_view/team_provider.dart';
import 'package:dev_partner/model_view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:dev_partner/View/screens/register.dart';
import 'package:dev_partner/View/screens/inbox_screen.dart';

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
    RegisterScreen(),
    InboxScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      final up = context.read<UserProvider>();
      await up.loadCachedUserFromPrefs();
      await up.loadCurrentUser(silent: true);
      if (!mounted) return;
      context.read<TeamProvider>().getMyTeam();
    });
  }

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