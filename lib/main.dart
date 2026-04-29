import 'package:Panda/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/app_settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-warm SharedPreferences so settings are instantly available
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettingsProvider(prefs: prefs),
      child: const InforabiaApp(),
    ),
  );
}

class InforabiaApp extends StatelessWidget {
  const InforabiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'INFORABIIA',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          locale: settings.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(),
        );
      },
    );
  }
}
