import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inforabia/l10n/app_localizations.dart';
import '../../../core/providers/app_settings_provider.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = Provider.of<AppSettingsProvider>(context);
    final primaryColor = isDark ? AppColors.accent : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionTitle(l10n.settings),
          const SizedBox(height: 12),
          _settingsTile(
            icon: Icons.dark_mode_rounded,
            title: l10n.darkMode,
            trailing: Switch.adaptive(
              value: settings.isDarkMode,
              onChanged: (_) => settings.toggleTheme(),
              activeColor: primaryColor,
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _settingsTile(
            icon: Icons.language_rounded,
            title: l10n.language,
            trailing: GestureDetector(
              onTap: () => settings.toggleLocale(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  settings.isArabic ? 'English' : 'العربية',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 24),
          _sectionTitle(l10n.aboutApp),
          const SizedBox(height: 12),
          _settingsTile(
            icon: Icons.info_outline_rounded,
            title: '${l10n.version} 1.0.0',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _settingsTile(
            icon: Icons.shield_rounded,
            title: 'Privacy Policy',
            isDark: isDark,
          ),
          const SizedBox(height: 30),
          // Logout
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text(
                l10n.logout,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              '© 2026 INFORABIA\n${l10n.allRightsReserved}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grey, size: 22),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
          ?trailing,
        ],
      ),
    );
  }
}
