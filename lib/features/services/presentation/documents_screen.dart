import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});
  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
  }

  final _docs = [
    {
      'title': 'Employee Handbook 2024',
      'cat': 'Policy',
      'pages': '48',
      'updated': '01 Jan 2024',
      'icon': Icons.menu_book_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'Annual Leave Policy',
      'cat': 'HR Policy',
      'pages': '12',
      'updated': '15 Mar 2024',
      'icon': Icons.event_available_rounded,
      'color': AppColors.success,
    },
    {
      'title': 'Remote Work Guidelines',
      'cat': 'IT Policy',
      'pages': '8',
      'updated': '01 Feb 2024',
      'icon': Icons.laptop_rounded,
      'color': AppColors.accent,
    },
    {
      'title': 'Code of Conduct',
      'cat': 'Compliance',
      'pages': '24',
      'updated': '10 Jan 2024',
      'icon': Icons.gavel_rounded,
      'color': AppColors.secondary,
    },
    {
      'title': 'IT Security Standards',
      'cat': 'IT Policy',
      'pages': '32',
      'updated': '20 Mar 2024',
      'icon': Icons.security_rounded,
      'color': AppColors.darkTeal,
    },
    {
      'title': 'Procurement SOP',
      'cat': 'Operations',
      'pages': '16',
      'updated': '05 Feb 2024',
      'icon': Icons.shopping_cart_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'Performance Review Guide',
      'cat': 'HR',
      'pages': '10',
      'updated': '01 Mar 2024',
      'icon': Icons.trending_up_rounded,
      'color': AppColors.accent,
    },
    {
      'title': 'Emergency Procedures',
      'cat': 'HSE',
      'pages': '20',
      'updated': '15 Jan 2024',
      'icon': Icons.health_and_safety_rounded,
      'color': AppColors.secondary,
    },
  ];

  final _courses = [
    {
      'title': 'Flutter Advanced Development',
      'instructor': 'Dr. Ahmed Fawzi',
      'hours': '24h',
      'status': 'Enrolled',
      'progress': 0.6,
      'color': AppColors.primary,
    },
    {
      'title': 'Leadership Excellence Program',
      'instructor': 'Sarah Richardson',
      'hours': '16h',
      'status': 'Completed',
      'progress': 1.0,
      'color': AppColors.success,
    },
    {
      'title': 'Arabic Business Communication',
      'instructor': 'Prof. Laila Habash',
      'hours': '12h',
      'status': 'Not Started',
      'progress': 0.0,
      'color': AppColors.accent,
    },
    {
      'title': 'Project Management Professional',
      'instructor': 'PMI Institute',
      'hours': '40h',
      'status': 'Enrolled',
      'progress': 0.3,
      'color': AppColors.secondary,
    },
    {
      'title': 'Data Analytics with Python',
      'instructor': 'Eng. Fahad Yusuf',
      'hours': '20h',
      'status': 'Completed',
      'progress': 1.0,
      'color': AppColors.success,
    },
    {
      'title': 'Cybersecurity Awareness',
      'instructor': 'IT Security Team',
      'hours': '4h',
      'status': 'Not Started',
      'progress': 0.0,
      'color': AppColors.darkTeal,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _headerStat(String label, String value, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.12),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.4)),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: color.withOpacity(0.8), fontSize: 9),
        ),
      ],
    ),
  );

  Widget _pill(String label, bool isDark) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: isDark ? AppColors.darkBackground : const Color(0xFFF0F4FA),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final completed = _courses.where((c) => c['status'] == 'Completed').length;
    final enrolled = _courses.where((c) => c['status'] == 'Enrolled').length;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF0F4FA),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Opacity(
                        opacity: 0.07,
                        child: const Icon(
                          Icons.folder_special_rounded,
                          size: 200,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 80,
                        bottom: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            l10n.knowledgeAndAssets,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.docsPoliciesTraining,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                               _headerStat(
                                l10n.docsShort,
                                '${_docs.length}',
                                Colors.white,
                              ),
                              const SizedBox(width: 10),
                              _headerStat(
                                l10n.coursesShort,
                                '${_courses.length}',
                                Colors.white,
                              ),
                              const SizedBox(width: 10),
                              _headerStat(
                                l10n.doneShort,
                                '$completed',
                                AppColors.accent,
                              ),
                              const SizedBox(width: 10),
                              _headerStat(
                                l10n.activeShort,
                                '$enrolled',
                                AppColors.primary,
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: AppColors.darkTeal,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  tabs: [
                    Tab(text: l10n.documents),
                    Tab(text: l10n.training),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_buildDocsTab(isDark), _buildTrainingTab(isDark)],
        ),
      ),
    );
  }

  Widget _buildDocsTab(bool isDark) => ListView.builder(
      cacheExtent: 1000,
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
    itemCount: _docs.length,
    itemBuilder: (_, i) {
      final d = _docs[i];
      final color = d['color'] as Color;
      return FadeInUp(
        delay: Duration(milliseconds: i * 60),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Container(height: 2, color: color),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withOpacity(0.18),
                              color.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          d['icon'] as IconData,
                          color: color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                _pill(d['cat'] as String, isDark),
                                const SizedBox(width: 6),
                                 _pill(l10n.pagesCount(d['pages'] as String), isDark),
                                const SizedBox(width: 6),
                                _pill(d['updated'] as String, isDark),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.download_rounded, size: 20, color: color),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  Widget _buildTrainingTab(bool isDark) => ListView.builder(
      cacheExtent: 1000,
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
    itemCount: _courses.length,
    itemBuilder: (_, i) {
      final c = _courses[i];
      final color = c['color'] as Color;
      final progress = c['progress'] as double;
      return FadeInRight(
        delay: Duration(milliseconds: i * 70),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.07),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              children: [
                Container(height: 3, color: color),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(11),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  color.withOpacity(0.18),
                                  color.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.school_rounded,
                              color: color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c['title'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${c['instructor']} • ${c['hours']}',
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: color.withOpacity(0.25),
                              ),
                            ),
                             child: Text(
                               c['status'] == 'Enrolled'
                                   ? l10n.enrolled
                                   : c['status'] == 'Completed'
                                       ? l10n.completed
                                       : c['status'] == 'Not Started'
                                           ? l10n.notStarted
                                           : c['status'] as String,
                               style: TextStyle(
                                 fontSize: 10,
                                 fontWeight: FontWeight.w800,
                                 color: color,
                               ),
                             ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            progress == 1.0
                                ? '✓ Complete'
                                : progress == 0.0
                                ? 'Not started'
                                : 'In progress',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          color: color,
                          backgroundColor: color.withOpacity(0.12),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
