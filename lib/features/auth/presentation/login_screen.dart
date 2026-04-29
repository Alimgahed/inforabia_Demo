import 'package:Panda/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_settings_provider.dart';
import '../../../core/services/biometric_service.dart';
import '../../home/presentation/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _biometricService = BiometricService();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  void _onBiometricLogin() async {
    final available = await _biometricService.isBiometricAvailable();
    if (available) {
      final success = await _biometricService.authenticate();
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.appGradient),
        child: SafeArea(
          child: Column(
            children: [
              /// 🌍 Language
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    context.read<AppSettingsProvider>().toggleLocale();
                  },
                  child: Text(
                    context.watch<AppSettingsProvider>().isArabic
                        ? l10n.english
                        : l10n.arabic,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              /// 🔥 MAIN CARD
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// Logo
                      Image.asset('assets/images/panda.png', height: 90),

                      const SizedBox(height: 10),

                      /// Title
                      Text(
                        l10n.welcomeBack,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        l10n.hrPlatformDesc,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// Email
                      TextFormField(
                        decoration: _inputDecoration(
                          l10n.email,
                          Icons.email_outlined,
                        ),
                        validator: (v) => v == null || !v.contains('@')
                            ? l10n.invalidEmail
                            : null,
                      ),

                      const SizedBox(height: 15),

                      /// Password
                      TextFormField(
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration(
                          l10n.password,
                          Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (v) => v == null || v.length < 6
                            ? l10n.passwordTooShort
                            : null,
                      ),

                      const SizedBox(height: 10),

                      /// Remember + Forgot
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.primary,
                            onChanged: (v) {
                              setState(() => _rememberMe = v!);
                            },
                          ),
                          Text(
                            l10n.rememberMe,
                            style: const TextStyle(color: AppColors.grey),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              l10n.forgotPassword,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// 🔥 LOGIN BUTTON (Gradient)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          onPressed: _onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            l10n.login,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 🔐 BIOMETRIC
                      OutlinedButton.icon(
                        onPressed: _onBiometricLogin,
                        icon: const Icon(
                          Icons.fingerprint,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          l10n.biometricLogin,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              /// Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.dontHaveAccount,
                    style: const TextStyle(color: AppColors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      l10n.register,
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.lightGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
