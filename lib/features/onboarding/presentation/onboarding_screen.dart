import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:inforabia/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<String> _images = [
    'assets/images/onboarding_hr.png',
    'assets/images/onboarding_dashboard.png',
    'assets/images/onboarding_security.png',
    'assets/images/onboarding_worklist.png',
    'assets/images/onboarding_finance.png',
    'assets/images/onboarding_learning.png',
  ];

  static const List<Color> _thematicColors = [
    AppColors.accent,      // HR - Cyan
    AppColors.chartTeal,   // Dashboard - Teal
    AppColors.chartPurple, // Security - Purple
    AppColors.chartBlue,   // Worklist - Blue
    AppColors.secondary,   // Finance - Gold
    AppColors.chartGreen,  // Learning - Green
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentColor = _thematicColors[_currentPage];

    final List<Map<String, String>> onboardingData = [
      {'title': l10n.onboardingTitle1, 'subtitle': l10n.onboardingSubtitle1},
      {'title': l10n.onboardingTitle2, 'subtitle': l10n.onboardingSubtitle2},
      {'title': l10n.onboardingTitle3, 'subtitle': l10n.onboardingSubtitle3},
      {'title': l10n.onboardingTitle4, 'subtitle': l10n.onboardingSubtitle4},
      {'title': l10n.onboardingTitle5, 'subtitle': l10n.onboardingSubtitle5},
      {'title': l10n.onboardingTitle6, 'subtitle': l10n.onboardingSubtitle6},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemCount: onboardingData.length,
            itemBuilder: (context, index) => _buildPage(
              context,
              title: onboardingData[index]['title']!,
              subtitle: onboardingData[index]['subtitle']!,
              imagePath: _images[index],
              color: _thematicColors[index],
            ),
          ),

          // Top Skip Button
          if (_currentPage < onboardingData.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: FadeInRight(
                child: TextButton(
                  onPressed: () => _pageController.animateToPage(
                    onboardingData.length - 1,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  ),
                  child: Text(
                    l10n.skip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [
                        Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 2)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Bottom Controls
          Positioned(
            bottom: 50,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => _buildDot(index, currentColor),
                  ),
                ),
                const SizedBox(height: 32),
                
                FadeInUp(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: _currentPage == onboardingData.length - 1 ? double.infinity : 200,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [currentColor, currentColor.withOpacity(0.7)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: currentColor.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == onboardingData.length - 1) {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              transitionDuration: const Duration(milliseconds: 800),
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == onboardingData.length - 1 ? l10n.getStarted : l10n.next,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          if (_currentPage < onboardingData.length - 1) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imagePath,
    required Color color,
  }) {
    return Stack(
      children: [
        // Fullscreen Background with Zoom Animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 1.0, end: 1.1),
          duration: const Duration(seconds: 15),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        
        // Gradient Overlays for Readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.3, 0.7, 1.0],
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
        ),

        // Text Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    fontSize: 34,
                    shadows: [
                      Shadow(color: Colors.black, blurRadius: 15, offset: Offset(0, 4)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color.withOpacity(0.95), // Thematic color for description
                    height: 1.4,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    shadows: const [
                      Shadow(color: Colors.black87, blurRadius: 12, offset: Offset(0, 2)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 180), // Space for controls at the bottom
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 8,
      width: _currentPage == index ? 32 : 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: _currentPage == index ? color : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          if (_currentPage == index)
            BoxShadow(color: color.withOpacity(0.6), blurRadius: 12, spreadRadius: 2),
        ],
      ),
    );
  }
}
