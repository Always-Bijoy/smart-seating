import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/main_shell.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  final bool seenOnboarding = await hasSeenOnboarding();
  runApp(SmartSeatApp(showOnboarding: !seenOnboarding));
}

class SmartSeatApp extends StatelessWidget {
  final bool showOnboarding;
  const SmartSeatApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Seating',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: showOnboarding ? const OnboardingScreen() : const MainShell(),
    );
  }
}
