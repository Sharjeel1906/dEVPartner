import 'package:dev_partner/View/screens/browse_profile.dart';
import 'package:dev_partner/View/screens/browse_teams.dart';
import 'package:dev_partner/View/widgets/app_drawer.dart';
import 'package:dev_partner/View/widgets/theme.dart';
import 'package:dev_partner/model/auth_services.dart';
import 'package:dev_partner/model_view/chat_provider.dart';
import 'package:dev_partner/model_view/team_provider.dart';
import 'package:dev_partner/model_view/user_provider.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:dev_partner/View/screens/inbox_screen.dart';
import 'package:dev_partner/View/screens/ai_match_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Timer? _inboxRefreshTimer;
  ChatProvider? _chatProvider;

  final List<Widget> screens = const [
    BrowseProfileScreen(),
    BrowseTeamsScreen(),
    AiMatchScreen(),
    InboxScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      final auth = AuthService();
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("is_logged_in") == true &&
          prefs.getString("refresh_token") != null) {
        await auth.refreshToken();
      }
      if (!mounted) return;
      final up = context.read<UserProvider>();
      await up.loadCachedUserFromPrefs();
      await up.loadCurrentUser(silent: true);
      if (!mounted) return;
      if (up.allUsers.isEmpty) {
        await up.loadAllUsers();
      }
      if (!mounted) return;
      final cp = context.read<ChatProvider>();
      _chatProvider = cp;
      await cp.initUser();
      final firstLoad = cp.conversations.isEmpty;
      await cp.getAllConversations(
        force: firstLoad,
        recomputeUnread: firstLoad,
      );
      if (!mounted) return;
      _inboxRefreshTimer = Timer.periodic(
        const Duration(seconds: 4),
        (_) => cp.refreshInbox(),
      );
      if (!mounted) return;
      context.read<TeamProvider>().getMyTeam();
    });
  }

  @override
  void dispose() {
    _inboxRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      drawer: buildAppDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: bottomNavigationBarUI(
        context: context,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 3) {
            context.read<ChatProvider>().refreshInbox(recomputeUnread: true);
          }
        },
      ),
    );
  }
}
