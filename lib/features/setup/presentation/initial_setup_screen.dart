import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/providers/app_settings_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../onboarding/presentation/onboarding_screen.dart';

class InitialSetupScreen extends StatelessWidget {
  const InitialSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.darkBackground, const Color(0xFF0D2137)]
                : [AppColors.white, const Color(0xFFE0F7FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                FadeInDown(
                  child: Text(
                    l10n.welcomeToInforabia,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.accent : AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),

                // Language Selection
                FadeInLeft(
                  delay: const Duration(milliseconds: 200),
                  child: _buildSectionTitle(l10n.chooseLanguage, isDark),
                ),
                const SizedBox(height: 16),
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: Row(
                    children: [
                      _buildOptionCard(
                        context,
                        title: 'English',
                        subtitle: 'US English',
                        icon: Icons.language,
                        isSelected: !settings.isArabic,
                        isDark: isDark,
                        onTap: () => settings.setLocale(const Locale('en')),
                      ),
                      const SizedBox(width: 16),
                      _buildOptionCard(
                        context,
                        title: 'العربية',
                        subtitle: 'اللغة العربية',
                        icon: Icons.g_translate_rounded,
                        isSelected: settings.isArabic,
                        isDark: isDark,
                        onTap: () => settings.setLocale(const Locale('ar')),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Theme Selection
                FadeInRight(
                  delay: const Duration(milliseconds: 400),
                  child: _buildSectionTitle(l10n.chooseTheme, isDark),
                ),
                const SizedBox(height: 16),
                FadeInRight(
                  delay: const Duration(milliseconds: 500),
                  child: Row(
                    children: [
                      _buildOptionCard(
                        context,
                        title: l10n.light,
                        subtitle: 'Clean & Bright',
                        icon: Icons.light_mode_rounded,
                        isSelected: !isDark,
                        isDark: isDark,
                        onTap: () {
                          if (isDark) settings.toggleTheme();
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildOptionCard(
                        context,
                        title: l10n.dark,
                        subtitle: 'Elegant & Modern',
                        icon: Icons.dark_mode_rounded,
                        isSelected: isDark,
                        isDark: isDark,
                        onTap: () {
                          if (!isDark) settings.toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        settings.completeSetup();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const OnboardingScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                      ),
                      child: Text(
                        l10n.startYourJourney,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white12 : Colors.black.withOpacity(0.05)),
              width: 2,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : AppColors.secondary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white : AppColors.primary),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white70 : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
