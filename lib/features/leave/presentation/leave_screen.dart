import 'package:Panda/core/theme/app_colors.dart';
import 'package:Panda/core/constants/app_features.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';

// ─── Paste your AppColors here or import from your project ───────────────────

// ─────────────────────────────────────────────────────────────────────────────

// ── Saudi leave types data model ─────────────────────────────────────────────
class LeaveBalance {
  final String label;
  final String arabicLabel;
  final int used;
  final int total;
  final Color color;
  final Color bgColor;
  final Color textColor;

  const LeaveBalance({
    required this.label,
    required this.arabicLabel,
    required this.used,
    required this.total,
    required this.color,
    required this.bgColor,
    required this.textColor,
  });

  int get remaining => total - used;
  double get percent => used / total;
}

class LeaveRequest {
  final String type;
  final DateTime from;
  final DateTime to;
  final String status; // 'approved' | 'pending' | 'rejected'
  final Color color;

  const LeaveRequest({
    required this.type,
    required this.from,
    required this.to,
    required this.status,
    required this.color,
  });

  int get days => to.difference(from).inDays + 1;
}

// ── Dummy data ────────────────────────────────────────────────────────────────
final List<LeaveBalance> saudiLeaveBalances = [
  const LeaveBalance(
    label: 'Annual',
    arabicLabel: 'إجازة سنوية',
    used: 7,
    total: 21,
    color: AppColors.primary,
    bgColor: Color(0xFFE8F5E9),
    textColor: Color(0xFF1B432C),
  ),
  const LeaveBalance(
    label: 'Sick',
    arabicLabel: 'إجازة مرضية',
    used: 5,
    total: 7,
    color: AppColors.warning,
    bgColor: Color(0xFFFFF8E1),
    textColor: Color(0xFFB45309),
  ),

  const LeaveBalance(
    label: 'Hajj',
    arabicLabel: 'إجازة الحج',
    used: 15,
    total: 15,
    color: Color(0xFF7B1FA2),
    bgColor: Color(0xFFF3E5F5),
    textColor: Color(0xFF6A1B9A),
  ),
];

final List<LeaveRequest> leaveHistory = [
  LeaveRequest(
    type: 'Annual Leave',
    from: DateTime(2026, 3, 15),
    to: DateTime(2026, 3, 20),
    status: 'approved',
    color: AppColors.primary,
  ),
  LeaveRequest(
    type: 'Sick Leave',
    from: DateTime(2026, 2, 10),
    to: DateTime(2026, 2, 12),
    status: 'approved',
    color: AppColors.warning,
  ),
  LeaveRequest(
    type: 'Annual Leave',
    from: DateTime(2026, 1, 20),
    to: DateTime(2026, 1, 26),
    status: 'approved',
    color: AppColors.primary,
  ),
  LeaveRequest(
    type: 'Emergency Leave',
    from: DateTime(2026, 4, 1),
    to: DateTime(2026, 4, 1),
    status: 'pending',
    color: AppColors.error,
  ),
  LeaveRequest(
    type: 'Annual Leave',
    from: DateTime(2026, 5, 10),
    to: DateTime(2026, 5, 12),
    status: 'pending',
    color: AppColors.primary,
  ),
  LeaveRequest(
    type: 'Sick Leave',
    from: DateTime(2025, 12, 3),
    to: DateTime(2025, 12, 4),
    status: 'rejected',
    color: AppColors.warning,
  ),
];

// ── Approved / pending calendar days ─────────────────────────────────────────
final Map<String, List<int>> approvedDays = {
  '2026-3': [15, 16, 17, 18, 19, 20],
  '2026-2': [10, 11, 12],
  '2026-1': [20, 21, 22, 23, 24, 25, 26],
};
final Map<String, List<int>> pendingDays = {
  '2026-4': [1],
  '2026-5': [10, 11, 12],
};

// ── Main Screen ───────────────────────────────────────────────────────────────
class LeaveScreen extends StatefulWidget {
  final FeatureArguments? args;
  const LeaveScreen({super.key, this.args});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, 
      vsync: this,
      initialIndex: widget.args?.initialSection ?? 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.background;
    final txtPrimary = isDark ? AppColors.darkTextPrimary : AppColors.black;
    final txtSecondary = isDark ? AppColors.darkTextSecondary : AppColors.grey;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ── Employee summary strip ──────────────────────────────────────
          _EmployeeSummaryStrip(isDark: isDark),

          // ── Custom tab bar ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: _CustomTabBar(
              controller: _tabController,
              isDark: isDark,
              cardColor: cardColor,
            ),
          ),
          const SizedBox(height: 14),

          // ── Tab views ───────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _OverviewTab(
                  isDark: isDark,
                  cardColor: cardColor,
                  txtPrimary: txtPrimary,
                  txtSecondary: txtSecondary,
                ),
                _CalendarTab(
                  isDark: isDark,
                  cardColor: cardColor,
                  txtPrimary: txtPrimary,
                  txtSecondary: txtSecondary,
                ),
                _HistoryTab(
                  isDark: isDark,
                  cardColor: cardColor,
                  txtPrimary: txtPrimary,
                  txtSecondary: txtSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Employee Summary Strip ────────────────────────────────────────────────────
class _EmployeeSummaryStrip extends StatelessWidget {
  final bool isDark;
  const _EmployeeSummaryStrip({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(18, topPad + 16, 18, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkTeal, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          // Avatar
          _buildProfileAvatar(
            'assets/images/pngtree-a-saudi-man-traditional-attire-middle-aged-wearing-white-thobe-and-png-image_16610073.webp',
            AppColors.primary,
          ),
          const SizedBox(width: 12),
          // Name & title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ahmed Khalid · HR-4021',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Leaves',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          // Quick stats
          Row(
            children: [
              _QuickStat(label: 'Total', value: '28'),
              Container(
                width: 0.5,
                height: 32,
                color: Colors.white.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 14),
              ),

              _QuickStat(label: 'Remaining', value: '21'),
              Container(
                width: 0.5,
                height: 32,
                color: Colors.white.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 14),
              ),
              _QuickStat(label: 'Used', value: '7'),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  const _QuickStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
        ),
      ],
    );
  }
}

// ── Custom Tab Bar ────────────────────────────────────────────────────────────
class _CustomTabBar extends StatefulWidget {
  final TabController controller;
  final bool isDark;
  final Color cardColor;

  const _CustomTabBar({
    required this.controller,
    required this.isDark,
    required this.cardColor,
  });

  @override
  State<_CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<_CustomTabBar> {
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) setState(() => _selected = widget.controller.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final tabs = ['Overview', 'Calendar', 'History'];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : const Color(0xFFDDDDDD),
          width: 0.5,
        ),
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (i) => Expanded(
            child: GestureDetector(
              onTap: () => widget.controller.animateTo(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: _selected == i
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _selected == i
                        ? Colors.white
                        : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.grey),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TAB 1 — OVERVIEW
// ═══════════════════════════════════════════════════════════════
class _OverviewTab extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color txtPrimary;
  final Color txtSecondary;

  const _OverviewTab({
    required this.isDark,
    required this.cardColor,
    required this.txtPrimary,
    required this.txtSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          _SectionLabel('Leave Balances', txtSecondary),
          SizedBox(height: 10),

          // Balance grid
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            child: ListView.separated(
      cacheExtent: 1000,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: saudiLeaveBalances.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _BalanceCard(
                balance: saudiLeaveBalances[i],
                isDark: isDark,
                cardColor: cardColor,
                txtPrimary: txtPrimary,
                txtSecondary: txtSecondary,
              ),
            ),
          ),

          const SizedBox(height: 20),
          _SectionLabel('Analytics', txtSecondary),
          const SizedBox(height: 10),

          // Donut chart
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: RepaintBoundary(
              child: _DonutChartCard(
                isDark: isDark,
                cardColor: cardColor,
                txtPrimary: txtPrimary,
                txtSecondary: txtSecondary,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Bar chart
          FadeInUp(
            delay: const Duration(milliseconds: 350),
            child: RepaintBoundary(
              child: _BarChartCard(
                isDark: isDark,
                cardColor: cardColor,
                txtSecondary: txtSecondary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Request button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  _showLeaveRequestSheet(context, isDark, cardColor),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Request Absence',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Balance Card ─────────────────────────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  final LeaveBalance balance;
  final bool isDark;
  final Color cardColor;
  final Color txtPrimary;
  final Color txtSecondary;

  const _BalanceCard({
    required this.balance,
    required this.isDark,
    required this.cardColor,
    required this.txtPrimary,
    required this.txtSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : const Color(0xFFE8E8E8),
          width: 0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      /// 🔥 NEW LAYOUT
      child: Row(
        children: [
          /// ─── LEFT (Main Info)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Label + Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: balance.bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        balance.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: balance.textColor,
                        ),
                      ),
                    ),
                    Text(
                      '${balance.total} days',
                      style: TextStyle(fontSize: 11, color: txtSecondary),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Remaining / Not Taken
                const SizedBox(height: 10),

                /// Progress (hide for Hajj not taken)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: balance.percent.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: balance.bgColor,
                    valueColor: AlwaysStoppedAnimation(balance.color),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${balance.used} used · ${(balance.percent * 100).round()}%',
                  style: TextStyle(fontSize: 10, color: txtSecondary),
                ),

                const SizedBox(height: 6),

                /// Arabic Label
                Text(
                  balance.arabicLabel,
                  style: TextStyle(
                    fontSize: 10,
                    color: txtSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// ─── RIGHT (Icon Circle)
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: balance.bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(balance.label),
              color: balance.color,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 Smart Icons
  IconData _getIcon(String label) {
    final l = label.toLowerCase();
    if (l.contains('annual')) return Icons.beach_access_outlined;
    if (l.contains('sick')) return Icons.local_hospital_outlined;
    if (l.contains('emergency')) return Icons.warning_amber_outlined;
    if (l.contains('hajj')) return Icons.mosque_outlined;
    return Icons.event_note_outlined;
  }
}

// ── Donut Chart Card ─────────────────────────────────────────────────────────
class _DonutChartCard extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color txtPrimary;
  final Color txtSecondary;

  const _DonutChartCard({
    required this.isDark,
    required this.cardColor,
    required this.txtPrimary,
    required this.txtSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      PieChartSectionData(
        value: 7,
        color: AppColors.primary,
        radius: 36,
        showTitle: false,
      ),
      PieChartSectionData(
        value: 5,
        color: AppColors.warning,
        radius: 36,
        showTitle: false,
      ),
      PieChartSectionData(
        value: 1,
        color: AppColors.error,
        radius: 36,
        showTitle: false,
      ),
    ];
    const legendItems = [
      ('Annual', AppColors.primary, '7d · 54%'),
      ('Sick', AppColors.warning, '5d · 38%'),
      ('Emergency', AppColors.error, '1d · 8%'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : const Color(0xFFE8E8E8),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usage by type',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: txtSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 32,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: legendItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: item.$2,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.$1,
                              style: TextStyle(
                                fontSize: 11,
                                color: txtSecondary,
                              ),
                            ),
                          ),
                          Text(
                            item.$3,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: txtPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bar Chart Card ────────────────────────────────────────────────────────────
class _BarChartCard extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color txtSecondary;

  const _BarChartCard({
    required this.isDark,
    required this.cardColor,
    required this.txtSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    final values = [0.0, 3.0, 5.0, 1.0, 3.0, 0.0];
    final colors = [
      AppColors.primary,
      AppColors.primary,
      AppColors.primary,
      AppColors.warning,
      AppColors.warning,
      AppColors.primary,
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : const Color(0xFFE8E8E8),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly trend 2026',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: txtSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 130,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 7,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) => Text(
                        months[v.toInt()],
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: (isDark ? Colors.white : Colors.black).withOpacity(
                      0.05,
                    ),
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  values.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i],
                        color: colors[i],
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TAB 2 — CALENDAR
// ═══════════════════════════════════════════════════════════════
class _CalendarTab extends StatefulWidget {
  final bool isDark;
  final Color cardColor;
  final Color txtPrimary;
  final Color txtSecondary;

  const _CalendarTab({
    required this.isDark,
    required this.cardColor,
    required this.txtPrimary,
    required this.txtSecondary,
  });

  @override
  State<_CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<_CalendarTab> {
  int _year = 2026;
  int _month = 4;

  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  void _prev() => setState(() {
    _month--;
    if (_month < 1) {
      _month = 12;
      _year--;
    }
  });

  void _next() => setState(() {
    _month++;
    if (_month > 12) {
      _month = 1;
      _year++;
    }
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final firstDay = DateTime(_year, _month, 1).weekday % 7;
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    final appr = approvedDays['$_year-$_month'] ?? [];
    final pend = pendingDays['$_year-$_month'] ?? [];
    final isDark = widget.isDark;
    final cardColor = widget.cardColor;
    final txtSecondary = widget.txtSecondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 30),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : const Color(0xFFE8E8E8),
                width: 0.5,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // Month nav
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavBtn(
                      onTap: _prev,
                      icon: Icons.chevron_left,
                      isDark: isDark,
                    ),
                    Text(
                      '${_monthNames[_month - 1]} $_year',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.txtPrimary,
                      ),
                    ),
                    _NavBtn(
                      onTap: _next,
                      icon: Icons.chevron_right,
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Day headers
                Row(
                  children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                      .map(
                        (d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: txtSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 6),
                // Calendar grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: firstDay + daysInMonth,
                  itemBuilder: (_, i) {
                    if (i < firstDay) return const SizedBox();
                    final day = i - firstDay + 1;
                    final isToday =
                        day == today.day &&
                        _month == today.month &&
                        _year == today.year;
                    final isAppr = appr.contains(day);
                    final isPend = pend.contains(day);

                    Color bg = Colors.transparent;
                    Color fg = widget.txtPrimary;
                    FontWeight fw = FontWeight.w400;
                    Border? border;

                    if (isToday) {
                      bg = AppColors.accent;
                      fg = Colors.white;
                      fw = FontWeight.w700;
                    } else if (isAppr) {
                      bg = AppColors.primary;
                      fg = Colors.white;
                      fw = FontWeight.w600;
                    } else if (isPend) {
                      bg = AppColors.warning.withOpacity(0.15);
                      fg = const Color(0xFFB45309);
                      border = Border.all(color: AppColors.warning, width: 0.8);
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(7),
                        border: border,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: fw,
                          color: fg,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                // Legend
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: const [
                    _LegendItem(color: AppColors.primary, label: 'Annual'),
                    _LegendItem(color: AppColors.warning, label: 'Sick'),
                    _LegendItem(color: AppColors.error, label: 'Emergency'),
                    _LegendItem(color: AppColors.accent, label: 'Today'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Upcoming
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : const Color(0xFFE8E8E8),
                width: 0.5,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming absences',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: txtSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                _HistoryItemCard(
                  item: leaveHistory[4],
                  isDark: isDark,
                  cardColor: cardColor,
                  txtPrimary: widget.txtPrimary,
                  txtSecondary: txtSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final bool isDark;

  const _NavBtn({
    required this.onTap,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.darkDivider : const Color(0xFFDDDDDD),
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.darkTextPrimary : AppColors.black,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.grey),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TAB 3 — HISTORY
// ═══════════════════════════════════════════════════════════════
class _HistoryTab extends StatefulWidget {
  final bool isDark;
  final Color cardColor;
  final Color txtPrimary;
  final Color txtSecondary;

  const _HistoryTab({
    required this.isDark,
    required this.cardColor,
    required this.txtPrimary,
    required this.txtSecondary,
  });

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  String _filter = 'all';

  List<LeaveRequest> get _filtered => _filter == 'all'
      ? leaveHistory
      : leaveHistory.where((l) => l.status == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final filters = ['all', 'approved', 'pending', 'rejected'];
    final isDark = widget.isDark;

    return Column(
      children: [
        // Filter chips
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters
                  .map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _filter == f
                                ? AppColors.primary
                                : widget.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _filter == f
                                  ? AppColors.primary
                                  : (isDark
                                        ? AppColors.darkDivider
                                        : const Color(0xFFDDDDDD)),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            f[0].toUpperCase() + f.substring(1),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: _filter == f
                                  ? Colors.white
                                  : widget.txtSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        // List
        Expanded(
          child: _filtered.isEmpty
              ? Center(
                  child: Text(
                    'No records found',
                    style: TextStyle(color: widget.txtSecondary, fontSize: 13),
                  ),
                )
              : ListView.separated(
      cacheExtent: 1000,
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 30),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 9),
                  itemBuilder: (_, i) => FadeInUp(
                    delay: Duration(milliseconds: i * 60),
                    child: _HistoryItemCard(
                      item: _filtered[i],
                      isDark: isDark,
                      cardColor: widget.cardColor,
                      txtPrimary: widget.txtPrimary,
                      txtSecondary: widget.txtSecondary,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _HistoryItemCard extends StatelessWidget {
  final LeaveRequest item;
  final bool isDark;
  final Color cardColor;
  final Color txtPrimary;
  final Color txtSecondary;

  const _HistoryItemCard({
    required this.item,
    required this.isDark,
    required this.cardColor,
    required this.txtPrimary,
    required this.txtSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = {
      'approved': (AppColors.success, const Color(0xFFE8F5E9)),
      'pending': (AppColors.warning, const Color(0xFFFFF8E1)),
      'rejected': (AppColors.error, const Color(0xFFFFEBEE)),
    };
    final (statusColor, statusBg) =
        statusConfig[item.status] ?? (AppColors.grey, const Color(0xFFF5F5F5));

    final df =
        '${item.from.year}-${item.from.month.toString().padLeft(2, '0')}-${item.from.day.toString().padLeft(2, '0')}';
    final dt =
        '${item.to.year}-${item.to.month.toString().padLeft(2, '0')}-${item.to.day.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : const Color(0xFFE8E8E8),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Color bar
          Container(
            width: 3,
            height: 46,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.type,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: txtPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$df → $dt',
                  style: TextStyle(fontSize: 11, color: txtSecondary),
                ),
                Text(
                  '${item.days} ${item.days == 1 ? 'day' : 'days'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: txtSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              item.status[0].toUpperCase() + item.status.substring(1),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// LEAVE REQUEST BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════
void _showLeaveRequestSheet(
  BuildContext context,
  bool isDark,
  Color cardColor,
) {
  final leaveTypes = [
    'Annual Leave (إجازة سنوية)',
    'Sick Leave (إجازة مرضية)',
    'Emergency Leave (إجازة طارئة)',
    'Hajj Leave (إجازة الحج)',
    'Maternity Leave (إجازة أمومة)',
    'Paternity Leave (إجازة الأبوة)',
    'Bereavement Leave (إجازة وفاة)',
    'Study / Exam Leave (إجازة دراسية)',
    'Unpaid Leave (إجازة بدون راتب)',
  ];
  String selectedType = leaveTypes[0];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(ctx).viewInsets.bottom + 28,
      ),
      child: StatefulBuilder(
        builder: (_, set) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'New Absence Request',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.black,
              ),
            ),
            const SizedBox(height: 18),
            _SheetLabel('Absence Type', isDark),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedType,
              isExpanded: true,
              decoration: _inputDeco('', isDark),
              items: leaveTypes
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t, style: const TextStyle(fontSize: 13)),
                    ),
                  )
                  .toList(),
              onChanged: (v) => set(() => selectedType = v!),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SheetLabel('From', isDark),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: _inputDeco('YYYY-MM-DD', isDark),
                        style: const TextStyle(fontSize: 13),
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SheetLabel('To', isDark),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: _inputDeco('YYYY-MM-DD', isDark),
                        style: const TextStyle(fontSize: 13),
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SheetLabel('Reason (optional)', isDark),
            const SizedBox(height: 6),
            TextField(
              maxLines: 3,
              decoration: _inputDeco('Add a reason...', isDark),
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Submit Request',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _SheetLabel(String label, bool isDark) => Text(
  label,
  style: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
  ),
);

InputDecoration _inputDeco(String hint, bool isDark) => InputDecoration(
  hintText: hint,
  hintStyle: TextStyle(
    color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
    fontSize: 13,
  ),
  filled: true,
  fillColor: isDark ? AppColors.darkSurface : const Color(0xFFF5F5F5),
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(9),
    borderSide: BorderSide(
      color: isDark ? AppColors.darkDivider : const Color(0xFFDDDDDD),
      width: 0.5,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(9),
    borderSide: BorderSide(
      color: isDark ? AppColors.darkDivider : const Color(0xFFDDDDDD),
      width: 0.5,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(9),
    borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
  ),
);

Widget _buildProfileAvatar(String imagePath, Color primaryColor) {
  return Container(
    padding: const EdgeInsets.all(3), // Increased padding for a "ring" effect
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: primaryColor.withOpacity(0.5), // Softer ring
        width: 1.5,
      ),
    ),
    child: CircleAvatar(
      radius: 24,
      backgroundColor: primaryColor.withOpacity(0.1),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: 48, // Double the radius
          height: 48,
          // Error handling is essential for professional apps
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.person_rounded, color: primaryColor, size: 24),
        ),
      ),
    ),
  );
}
