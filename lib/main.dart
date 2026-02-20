import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'providers/trip_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  final bool seenOnboarding = await hasSeenOnboarding();
  runApp(SmartSeatApp(
    showOnboarding: !seenOnboarding,
    localeProvider: localeProvider,
  ));
}

class SmartSeatApp extends StatelessWidget {
  final bool showOnboarding;
  final LocaleProvider localeProvider;

  const SmartSeatApp({
    super.key,
    required this.showOnboarding,
    required this.localeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider.value(value: localeProvider),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, lp, _) {
          return MaterialApp(
            title: 'Smart Seating',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            locale: lp.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('bn'),
            ],
            home: showOnboarding
                ? const OnboardingScreen()
                : const HomeScreen(),
          );
        },
      ),
    );
  }
}
