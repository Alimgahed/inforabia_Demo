import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inforabia/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.accountCreated)),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: Stack(
        children: [
          // Premium Background Gradient Sphere (Same as Login)
          Positioned(
            top: -100,
            left: -100,
            child: FadeIn(
              duration: const Duration(seconds: 2),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Image.asset('assets/images/panda.png', height: 80),
                    ),

                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        l10n.register,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    FadeInDown(
                      delay: const Duration(milliseconds: 400),
                      child: Text(
                        l10n.createAccountDesc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Profile Setup Chart Mockup
                    FadeIn(
                      delay: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      color: AppColors.primary,
                                      value: 30,
                                      radius: 6,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      color: AppColors.grey.withOpacity(0.1),
                                      value: 70,
                                      radius: 6,
                                      showTitle: false,
                                    ),
                                  ],
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.quickRegistration,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    l10n.joinEnterprisePortal,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    FadeInUp(
                      delay: const Duration(milliseconds: 800),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: l10n.name,
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? Colors.white.withOpacity(0.02)
                                    : Colors.grey.withOpacity(0.03),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? l10n.invalidName
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: l10n.email,
                                prefixIcon: const Icon(
                                  Icons.alternate_email,
                                  color: AppColors.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? Colors.white.withOpacity(0.02)
                                    : Colors.grey.withOpacity(0.03),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  value == null || !value.contains('@')
                                  ? l10n.invalidEmail
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: l10n.password,
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.primary,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? Colors.white.withOpacity(0.02)
                                    : Colors.grey.withOpacity(0.03),
                              ),
                              validator: (value) =>
                                  value == null || value.length < 6
                                  ? l10n.passwordTooShort
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: l10n.confirmPassword,
                                prefixIcon: const Icon(
                                  Icons.lock_reset,
                                  color: AppColors.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? Colors.white.withOpacity(0.02)
                                    : Colors.grey.withOpacity(0.03),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    FadeInUp(
                      delay: const Duration(milliseconds: 1000),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _onRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            l10n.register,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    FadeInUp(
                      delay: const Duration(milliseconds: 1200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.alreadyHaveAccount),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              l10n.login,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
