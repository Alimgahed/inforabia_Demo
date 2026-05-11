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
        'title': 'Tamer Logistics',
        'desc': 'Leading Third Party Strategic Logistics Service provider in the region.',
        'image': 'https://tamergroup.com/application/files/8016/9373/4831/8faaabec64446350e7de43a6aa0d79af.jpg',
        'date': 'Oct 2023',
        'icon': Icons.local_shipping_rounded,
        'color': AppColors.info,
        'tag': 'Logistics',
      },
      {
        'title': 'LIFERA, SANOFI & ARABIO Sign MOU',
        'desc': 'Collaboration for vaccine manufacturing and supply in Saudi Arabia.',
        'image': 'https://tamergroup.com/application/files/7616/8864/6944/New_Project_14.jpg',
        'date': 'Jul 2023',
        'icon': Icons.handshake_rounded,
        'color': AppColors.warning,
        'tag': 'Leadership',
      },
      {
        'title': 'Healthy Partnerships',
        'desc': 'Healthcare excellence through close partnerships with multinationals.',
        'image': 'https://tamergroup.com/application/files/4916/8839/8048/New_Project_3.png',
        'date': 'Jun 2023',
        'icon': Icons.health_and_safety_rounded,
        'color': AppColors.primary,
        'tag': 'Healthcare',
      },
      {
        'title': 'Business Innovation',
        'desc': 'Driving cultural and strategic change in Saudi Arabia\'s pharmaceutical sector.',
        'image': 'https://tamergroup.com/application/files/8916/8839/3524/tamerG_img_1b.jpg',
        'date': 'May 2023',
        'icon': Icons.lightbulb_rounded,
        'color': AppColors.success,
        'tag': 'Innovation',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        n['image'] as String,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: (n['color'] as Color).withOpacity(0.1),
                          child: Icon(
                            n['icon'] as IconData,
                            color: n['color'] as Color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
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
                          const SizedBox(height: 6),
                          Text(
                            n['desc'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                  ],
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
        'vendor': 'Tamer Group',
        'valid': 'Ongoing',
        'desc': 'Exclusive 15% discount for all Tamer colleagues on your healthcare and wellness purchases.',
        'icon': Icons.shopping_bag_rounded,
        'color': AppColors.success,
      },
      {
        'title': '2X AlFursan Miles',
        'vendor': 'AlFursan x Tamer',
        'valid': 'Until 31 Mar 2026',
        'desc': 'Earn double AlFursan miles on all wellness products at any Tamer pharmacy.',
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
