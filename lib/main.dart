import 'dart:convert';
import 'package:dev_partner/View/screens/home_screen.dart';
import 'package:dev_partner/View/screens/login.dart';
import 'package:dev_partner/View/screens/on_boarding.dart';
import 'package:dev_partner/model_view/auth_provider.dart';
import 'package:dev_partner/model_view/chat_provider.dart';
import 'package:dev_partner/model_view/email_provider.dart';
import 'package:dev_partner/model_view/team_provider.dart';
import 'package:dev_partner/model_view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'View/widgets/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool("onboarding_completed") ?? false;
  final isLoggedIn = prefs.getBool("is_logged_in") ?? false;
  final accessToken = prefs.getString("access_token");
  final userProvider = UserProvider();
  final userJson = prefs.getString("user");
  if (userJson != null) {
    userProvider.applyUserFromMap(jsonDecode(userJson) as Map<String, dynamic>);
  }
  late final Widget initialScreen;
  if (!onboardingCompleted) {
    initialScreen = const OnboardingScreen();
  } else if (isLoggedIn && accessToken != null) {
    initialScreen = const HomeScreen();
  } else {
    initialScreen = const LoginScreen();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider(create: (_) => EmailProvider()),
      ],
      child: MyApp(initialScreen: initialScreen),
    ),
  );
}



class MyApp extends StatelessWidget {

  final Widget initialScreen;



  const MyApp({super.key, required this.initialScreen});



  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'dEVPartner',

      theme: appTheme,

      home: initialScreen,

    );

  }

}


