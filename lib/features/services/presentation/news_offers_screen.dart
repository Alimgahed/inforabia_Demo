import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class NewsOffersScreen extends StatefulWidget {
  const NewsOffersScreen({super.key});

  @override
  State<NewsOffersScreen> createState() => _NewsOffersScreenState();
}

class _NewsOffersScreenState extends State<NewsOffersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF4F6FC),
      appBar: AppBar(
        title: const Text(
          'News & Offers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: l10n.news),
            Tab(text: l10n.offers),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildNewsTab(isDark), _buildOffersTab(isDark)],
      ),
    );
  }

  Widget _buildNewsTab(bool isDark) {
    final news = [
      {
        'title': 'Ramadan 2024 Working Hours',
        'desc':
            'Work from 9:00 AM to 3:00 PM during Ramadan. Remote work available on Thursdays.',
        'date': '10 Mar 2024',
        'icon': Icons.access_time_filled_rounded,
        'color': AppColors.warning,
        'tag': 'Operations',
      },
      {
        'title': 'Annual Performance Bonus Distribution',
        'desc':
            'Q1 performance bonuses will be processed with April payroll. Contact HR for queries.',
        'date': '05 Apr 2024',
        'icon': Icons.monetization_on_rounded,
        'color': AppColors.success,
        'tag': 'Finance',
      },
      {
        'title': 'IT Infrastructure Upgrade',
        'desc':
            'New fiber optic connections deployed across all floors. WiFi 6E now available.',
        'date': '01 Apr 2024',
        'icon': Icons.wifi_rounded,
        'color': AppColors.info,
        'tag': 'IT',
      },
      {
        'title': 'CEO Town Hall: Vision 2030 Update',
        'desc':
            'Join the CEO virtual town hall on Apr 20 at 2 PM for strategic updates.',
        'date': '12 Apr 2024',
        'icon': Icons.campaign_rounded,
        'color': AppColors.primary,
        'tag': 'Leadership',
      },
      {
        'title': 'New BYOD Security Policy',
        'desc':
            'All personal devices must be enrolled in MDM by May 1. Contact IT for assistance.',
        'date': '08 Apr 2024',
        'icon': Icons.security_rounded,
        'color': AppColors.error,
        'tag': 'Security',
      },
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: news.length,
      itemBuilder: (context, i) {
        final n = news[i];
        return FadeInUp(
          delay: Duration(milliseconds: i * 100),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(color: n['color'] as Color, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (n['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        n['icon'] as IconData,
                        color: n['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        n['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (n['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        n['tag'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: n['color'] as Color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  n['desc'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextPrimary : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  n['date'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOffersTab(bool isDark) {
    final offers = [
      {
        'title': '30% Off Gym Memberships',
        'vendor': 'Fitness First KSA',
        'valid': 'Until 30 Jun 2024',
        'desc': 'Valid for all Inforabia employees and their families.',
        'icon': Icons.fitness_center_rounded,
        'color': AppColors.success,
      },
      {
        'title': 'Free Eye Exam + 25% Off Glasses',
        'vendor': 'Magrabi Optical',
        'valid': 'Until 31 May 2024',
        'desc': 'Present your employee ID badge at any branch.',
        'icon': Icons.visibility_rounded,
        'color': AppColors.info,
      },
      {
        'title': '20% Off Hotel Stays',
        'vendor': 'Hilton Hotels Group',
        'valid': 'Ongoing',
        'desc': 'Corporate rate for business and leisure travel.',
        'icon': Icons.hotel_rounded,
        'color': AppColors.secondary,
      },
      {
        'title': 'Free Online Coursera Access',
        'vendor': 'Coursera for Business',
        'valid': 'Until 31 Dec 2024',
        'desc': 'Unlimited access to professional certificates.',
        'icon': Icons.school_rounded,
        'color': AppColors.chartPurple,
      },
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      itemBuilder: (context, i) {
        final o = offers[i];
        return FadeInRight(
          delay: Duration(milliseconds: i * 100),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (o['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        o['icon'] as IconData,
                        color: o['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            o['vendor'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  o['desc'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextPrimary : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  o['valid'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: o['color'] as Color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
