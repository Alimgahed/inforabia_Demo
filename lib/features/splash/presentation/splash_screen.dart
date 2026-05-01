import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../setup/presentation/initial_setup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _navigateToNext();
    // Precache ALL app images during splash to eliminate flicker everywhere
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final images = [
        // Core branding
        'assets/images/panda.png',
        'assets/images/qrcode.jpeg',
        // Main user avatar
        'assets/images/pngtree-a-saudi-man-traditional-attire-middle-aged-wearing-white-thobe-and-png-image_16610073.webp',
        // Team avatars
        'assets/images/team/sara.png',
        'assets/images/team/omar.png',
        'assets/images/team/noura.png',
        'assets/images/team/faisal.png',
        'assets/images/team/reem.png',
        'assets/images/team/yasser.png',
        // Best employees
        'assets/images/people/download (1).jpeg',
        'assets/images/people/25b9c99d1a7f5bcc86d09ee85d82ee02.jpg',
        'assets/images/people/images (1).jpeg',
        'assets/images/people/download.jpeg',
        // News section
        'assets/images/news_workshop.png',
        'assets/images/news_ramadan.png',
        'assets/images/news_security.png',
        'assets/images/news_bonus.png',
        // Onboarding
        'assets/images/edited-photo.png',
        'assets/images/edited-photo (2).png',
        'assets/images/edited-photo (3).png',
        'assets/images/edited-photo (6).png',
        'assets/images/edited-photo (4).png',
        'assets/images/edited-photo (5).png',
      ];
      for (final path in images) {
        precacheImage(AssetImage(path), context);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const InitialSetupScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.darkBackground, const Color(0xFF0D2116)]
                : [AppColors.white, const Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background Circles
            Positioned(
              top: -80,
              right: -80,
              child: FadeIn(
                duration: const Duration(seconds: 2),
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(isDark ? 0.08 : 0.05),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: FadeIn(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(seconds: 2),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withOpacity(
                      isDark ? 0.08 : 0.05,
                    ),
                  ),
                ),
              ),
            ),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with pulse
                  FadeInDown(
                    duration: const Duration(milliseconds: 1200),
                    child: ScaleTransition(
                      scale: _pulseAnimation,
                      child: Image.asset(
                        'assets/images/panda.png',
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),

                  const SizedBox(height: 0),

                  // Title
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    delay: const Duration(milliseconds: 800),
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.tealGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                      child: Text(
                        'Panda',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 10,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: AppColors.primary.withOpacity(
                                isDark ? 0.4 : 0.2,
                              ),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  FadeInUp(
                    delay: const Duration(milliseconds: 1400),
                    duration: const Duration(milliseconds: 1000),
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.goldenGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                      child: Text(
                        'Panda Hypermarket',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: AppColors.secondary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Employee Switch badge
                  // FadeIn(
                  //   delay: const Duration(milliseconds: 1400),
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 20,
                  //       vertical: 8,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       gradient: AppColors.primaryGradient,
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: const Text(
                  //       'Employee Switch',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w600,
                  //         letterSpacing: 1,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 60),

                  // Loading
                  FadeIn(
                    delay: const Duration(seconds: 2),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? AppColors.accent : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
