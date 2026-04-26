import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class WorklistScreen extends StatefulWidget {
  const WorklistScreen({super.key});

  @override
  State<WorklistScreen> createState() => _WorklistScreenState();
}

class _WorklistScreenState extends State<WorklistScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.darkTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        l10n.worklistManagement,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _statChip('8 Active', AppColors.accent),
                          const SizedBox(width: 8),
                          _statChip('24 Completed', AppColors.secondary),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: AppColors.primary,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.secondary,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  tabs: [
                    Tab(text: l10n.active),
                    Tab(text: l10n.history),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_buildActiveTab(isDark), _buildHistoryTab(isDark)],
        ),
      ),
    );
  }

  Widget _statChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildActiveTab(bool isDark) {
    final tasks = [
      {
        'title': 'Review Purchase Request PR-8839',
        'due': 'Today',
        'priority': 'High',
        'cat': 'Procurement',
        'color': AppColors.error,
      },
      {
        'title': 'Approve Sara\'s Leave Request',
        'due': 'Today',
        'priority': 'High',
        'cat': 'HR',
        'color': AppColors.error,
      },
      {
        'title': 'Verify Invoice INV-4421',
        'due': 'Tomorrow',
        'priority': 'Medium',
        'cat': 'Finance',
        'color': AppColors.warning,
      },
      {
        'title': 'Performance Review Meeting',
        'due': '22 Apr',
        'priority': 'Low',
        'cat': 'Management',
        'color': AppColors.info,
      },
      {
        'title': 'Sign Off Security Audit',
        'due': '24 Apr',
        'priority': 'Medium',
        'cat': 'Compliance',
        'color': AppColors.warning,
      },
      {
        'title': 'Asset Transfer Request AT-992',
        'due': '28 Apr',
        'priority': 'Low',
        'cat': 'Warehouse',
        'color': AppColors.success,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: tasks.length,
      itemBuilder: (ctx, i) {
        final t = tasks[i];
        final color = t['color'] as Color;
        return FadeInUp(
          delay: Duration(milliseconds: 60 * i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 10,
                            color: isDark ? Colors.white38 : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            t['cat'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white38 : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time_rounded,
                            size: 10,
                            color: color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Due: ${t['due']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _priorityTag(t['priority'] as String, color),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _priorityTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildHistoryTab(bool isDark) {
    final history = [
      {
        'title': 'Leave Approved - Omar K.',
        'date': '14 Apr',
        'status': 'Approved',
        'color': AppColors.success,
      },
      {
        'title': 'PR-8332 Forwarded to Finance',
        'date': '13 Apr',
        'status': 'Forwarded',
        'color': AppColors.info,
      },
      {
        'title': 'Invoice INV-2210 Rejected',
        'date': '12 Apr',
        'status': 'Rejected',
        'color': AppColors.error,
      },
      {
        'title': 'Training Cert Validated',
        'date': '10 Apr',
        'status': 'Completed',
        'color': AppColors.success,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (ctx, i) {
        final h = history[i];
        final color = h['color'] as Color;
        return FadeInLeft(
          delay: Duration(milliseconds: 60 * i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${h['status']} • ${h['date']}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white38 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: isDark ? Colors.white12 : Colors.grey.shade300,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
