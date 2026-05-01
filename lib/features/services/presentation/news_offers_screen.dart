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
        'title': 'Panda Signs MoU with Arsan',
        'desc': 'Collaborating on parking management across the Kingdom markets to enhance customer journey.',
        'date': '04 Feb 2026',
        'icon': Icons.local_parking_rounded,
        'color': AppColors.info,
        'tag': 'Operations',
      },
      {
        'title': 'RLC Global Forum 2026',
        'desc': 'CEO Dr. Bander Hamooh on rebuilding resilient growth in a pressured market.',
        'date': '03 Feb 2026',
        'icon': Icons.campaign_rounded,
        'color': AppColors.warning,
        'tag': 'Leadership',
      },
      {
        'title': 'Energy Efficiency with Tarshid',
        'desc': 'Implementing energy-saving initiatives and reducing emissions across all Panda facilities.',
        'date': '01 Feb 2026',
        'icon': Icons.eco_rounded,
        'color': AppColors.primary,
        'tag': 'Sustainability',
      },
      {
        'title': 'AlFursan Miles Exchange',
        'desc': 'Redeem your AlFursan miles for shopping rewards at any Panda store across the Kingdom.',
        'date': '28 Jan 2026',
        'icon': Icons.airplanemode_active_rounded,
        'color': AppColors.success,
        'tag': 'Rewards',
      },
    ];
    return ListView.builder(
      cacheExtent: 1000,
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
        'title': '15% Colleague Discount',
        'vendor': 'Panda Retail Company',
        'valid': 'Ongoing',
        'desc': 'Exclusive 15% discount for all Panda colleagues on your monthly grocery shopping.',
        'icon': Icons.shopping_bag_rounded,
        'color': AppColors.success,
      },
      {
        'title': '2X AlFursan Miles',
        'vendor': 'AlFursan x Panda',
        'valid': 'Until 31 Mar 2026',
        'desc': 'Earn double AlFursan miles on all weekend purchases at any Panda Hypermarket.',
        'icon': Icons.star_rounded,
        'color': AppColors.secondary,
      },
      {
        'title': 'Special Salary Package',
        'vendor': 'SAIB Bank',
        'valid': 'Ongoing',
        'desc': 'Transfer your salary to SAIB and enjoy zero-fee banking and a welcome cash bonus.',
        'icon': Icons.account_balance_rounded,
        'color': AppColors.info,
      },
    ];
    return ListView.builder(
      cacheExtent: 1000,
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
