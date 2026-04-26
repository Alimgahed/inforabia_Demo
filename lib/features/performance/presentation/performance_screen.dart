import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF4F6FC),
      appBar: AppBar(
        title: Text(
          l10n.performance,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white, // 👈 selected tab text
          unselectedLabelColor:
              Colors.white70, // 👈 optional (for better contrast)
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          tabs: [
            Tab(text: l10n.goals),
            Tab(text: l10n.continuousFeedback),
            Tab(text: l10n.performanceReview),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGoalsTab(l10n, isDark),
          _buildFeedbackTab(l10n, isDark),
          _buildReviewTab(l10n, isDark),
        ],
      ),
    );
  }

  Widget _buildGoalsTab(AppLocalizations l10n, bool isDark) {
    final goals = [
      {
        'title': 'Complete Mobile ERP Module',
        'desc': 'Deliver all 11 enterprise modules with full bilingual support',
        'progress': 0.85,
        'due': '30 Apr 2024',
        'weight': '30%',
        'status': 'On Track',
      },
      {
        'title': 'Improve App Performance by 20%',
        'desc': 'Optimize render pipeline and reduce frame drops below 16ms',
        'progress': 0.40,
        'due': '15 May 2024',
        'weight': '20%',
        'status': 'At Risk',
      },
      {
        'title': 'Lead Flutter Training Program',
        'desc': 'Conduct 8 sessions for junior developers on advanced patterns',
        'progress': 0.625,
        'due': '30 Jun 2024',
        'weight': '15%',
        'status': 'On Track',
      },
      {
        'title': 'Achieve PMP Certification',
        'desc': 'Complete PMI coursework and pass the PMP examination',
        'progress': 0.30,
        'due': '31 Aug 2024',
        'weight': '10%',
        'status': 'Needs Attention',
      },
      {
        'title': 'Mentor 3 New Team Members',
        'desc': 'Onboard and provide structured mentorship for Q2 hires',
        'progress': 1.0,
        'due': '15 Mar 2024',
        'weight': '10%',
        'status': 'Completed',
      },
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: goals.length,
      itemBuilder: (context, i) {
        final g = goals[i];
        final progress = g['progress'] as double;
        Color statusColor = AppColors.success;
        if (g['status'] == 'At Risk') statusColor = AppColors.warning;
        if (g['status'] == 'Needs Attention') statusColor = AppColors.error;

        return FadeInUp(
          delay: Duration(milliseconds: i * 100),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        g['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        g['status'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  g['desc'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 8,
                  percent: progress,
                  progressColor: statusColor,
                  backgroundColor: statusColor.withOpacity(0.12),
                  barRadius: const Radius.circular(4),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Weight: ${g['weight']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.grey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Due: ${g['due']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
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

  Widget _buildFeedbackTab(AppLocalizations l10n, bool isDark) {
    final feedbacks = [
      {
        'from': 'Sarah R. (Manager)',
        'type': 'Appreciation',
        'comment':
            'Excellent work on the new dashboard animations! Your attention to detail in micro-interactions has set a new standard.',
        'date': 'Today',
        'icon': Icons.star_rounded,
        'color': AppColors.secondary,
      },
      {
        'from': 'Omar K. (Peer)',
        'type': 'Collaboration',
        'comment':
            'Very helpful in resolving the complex merge conflicts last week. Great team player!',
        'date': '2 days ago',
        'icon': Icons.handshake_rounded,
        'color': AppColors.info,
      },
      {
        'from': 'HR System',
        'type': 'Milestone',
        'comment':
            'Congratulations! You completed 2 years at Inforabia. Your dedication is valued.',
        'date': '1 week ago',
        'icon': Icons.emoji_events_rounded,
        'color': AppColors.success,
      },
      {
        'from': 'Fahad M. (Peer)',
        'type': 'Growth',
        'comment':
            'The Flutter training sessions you led were incredibly insightful. Consider creating advanced workshops.',
        'date': '2 weeks ago',
        'icon': Icons.school_rounded,
        'color': AppColors.chartPurple,
      },
      {
        'from': 'Sarah R. (Manager)',
        'type': 'Improvement',
        'comment':
            'Please focus on documenting your code more thoroughly. This will help with future maintenance.',
        'date': '3 weeks ago',
        'icon': Icons.edit_note_rounded,
        'color': AppColors.warning,
      },
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: feedbacks.length,
      itemBuilder: (context, i) {
        final f = feedbacks[i];
        return FadeInRight(
          delay: Duration(milliseconds: i * 100),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(color: f['color'] as Color, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (f['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        f['icon'] as IconData,
                        size: 16,
                        color: f['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f['from'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (f['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        f['type'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: f['color'] as Color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  f['comment'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextPrimary : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  f['date'] as String,
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

  Widget _buildReviewTab(AppLocalizations l10n, bool isDark) {
    final reviews = [
      {
        'period': 'Q1 2024',
        'overall': 4.8,
        'technical': 4.9,
        'leadership': 4.5,
        'communication': 4.7,
        'status': 'Final',
        'manager': 'Sarah R.',
      },
      {
        'period': 'H2 2023',
        'overall': 4.5,
        'technical': 4.7,
        'leadership': 4.2,
        'communication': 4.5,
        'status': 'Final',
        'manager': 'Sarah R.',
      },
      {
        'period': 'H1 2023',
        'overall': 4.2,
        'technical': 4.3,
        'leadership': 3.9,
        'communication': 4.4,
        'status': 'Final',
        'manager': 'Ahmed M.',
      },
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, i) {
        final r = reviews[i];
        return FadeInLeft(
          delay: Duration(milliseconds: i * 100),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
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
                    Text(
                      r['period'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${r['overall']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Manager: ${r['manager']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                _ratingRow(
                  'Technical Skills',
                  r['technical'] as double,
                  AppColors.primary,
                ),
                _ratingRow(
                  'Leadership',
                  r['leadership'] as double,
                  AppColors.info,
                ),
                _ratingRow(
                  'Communication',
                  r['communication'] as double,
                  AppColors.success,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ratingRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 11)),
          ),
          Expanded(
            child: LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 6,
              percent: value / 5,
              progressColor: color,
              backgroundColor: color.withOpacity(0.12),
              barRadius: const Radius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
