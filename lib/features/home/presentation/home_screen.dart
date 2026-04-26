import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:inforabia/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../attendance/presentation/attendance_screen.dart';
import '../../leave/presentation/leave_screen.dart';
import '../../payroll/presentation/payslip_screen.dart';
import '../../performance/presentation/performance_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../team/presentation/my_team_screen.dart';
import '../../services/presentation/requests_screen.dart';
import '../../services/presentation/payroll_screen.dart' as payroll_service;
import '../../services/presentation/hr_insights_screen.dart';
import '../../services/presentation/documents_screen.dart';
import '../../services/presentation/procurement_screen.dart';
import '../../services/presentation/finance_screen.dart';
import '../../services/presentation/worklist_screen.dart';
import '../../services/presentation/news_offers_screen.dart';
import '../../services/presentation/service_detail_screen.dart';
import 'widgets/best_employees_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;

  // Animation controllers for KPI counters
  late AnimationController _kpiController;
  late Animation<double> _kpiAnimation;

  // Animation controller for bars
  late AnimationController _barController;
  late Animation<double> _barAnimation;

  // Carousel Controller for News
  late PageController _newsPageController;
  Timer? _newsTimer;
  int _newsCurrentPage = 0;

  @override
  void initState() {
    super.initState();
    _kpiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _barController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _kpiAnimation = CurvedAnimation(
      parent: _kpiController,
      curve: Curves.easeOutCubic,
    );
    _barAnimation = CurvedAnimation(
      parent: _barController,
      curve: Curves.easeOutCubic,
    );
    _newsPageController = PageController(viewportFraction: 0.92);
    _startNewsTimer();

    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        _kpiController.forward();
        _barController.forward();
      }
    });
  }

  @override
  void dispose() {
    _kpiController.dispose();
    _barController.dispose();
    _newsPageController.dispose();
    _newsTimer?.cancel();
    super.dispose();
  }

  void _startNewsTimer() {
    _newsTimer?.cancel();
    _newsTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_newsPageController.hasClients) {
        _newsCurrentPage++;
        if (_newsCurrentPage >= 4) {
          // Assuming 4 news items
          _newsCurrentPage = 0;
          _newsPageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
          );
        } else {
          _newsPageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
          );
        }
      }
    });
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.accent : AppColors.primary;

    final screens = [
      _buildDashboard(context, l10n, isDark, primaryColor),
      _buildServicesGrid(context, l10n, isDark, primaryColor),
      const MyTeamScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: _BottomNavBar(
        width: MediaQuery.of(context).size.width,
        isDark: isDark,
        labels: l10n,
        currentIndex: _currentIndex,
        onChanged: (int p1) {
          setState(() {
            _currentIndex = p1;
          });
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // DASHBOARD TAB
  // ════════════════════════════════════════════════════════════════════

  Widget _buildDashboard(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    Color primaryColor,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            FadeInDown(
              child: _buildHeader(context, l10n, isDark, primaryColor),
            ),
            const SizedBox(height: 20),

            // ── Employee Banner ──
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: _buildEmployeeBanner(isDark, primaryColor),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: _buildNewsSection(l10n, isDark, primaryColor),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              delay: const Duration(milliseconds: 280),
              child: BestEmployeesSection(isDark: isDark),
            ),
            const SizedBox(height: 20),
            // ── Quick Action Chips ──
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _quickChip(
                      Icons.fingerprint_rounded,
                      l10n.attendance,
                      AppColors.primary,
                      isDark,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AttendanceScreen(),
                        ),
                      ),
                    ),
                    _quickChip(
                      Icons.event_available_rounded,
                      l10n.leaveManagement,
                      AppColors.success,
                      isDark,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LeaveScreen()),
                      ),
                    ),
                    _quickChip(
                      Icons.receipt_long_rounded,
                      l10n.payslip,
                      AppColors.secondary,
                      isDark,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PayslipScreen(),
                        ),
                      ),
                    ),
                    _quickChip(
                      Icons.trending_up_rounded,
                      l10n.performance,
                      AppColors.info,
                      isDark,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PerformanceScreen(),
                        ),
                      ),
                    ),
                    _quickChip(
                      Icons.description_rounded,
                      l10n.requests,
                      AppColors.chartPurple,
                      isDark,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RequestsScreen(),
                        ),
                      ),
                    ),
                    _quickChip(
                      Icons.checklist_rounded,
                      l10n.worklist,
                      AppColors.chartOrange,
                      isDark,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WorklistScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Animated KPI Cards Row ──
            FadeInUp(
              delay: const Duration(milliseconds: 250),
              child: _buildAnimatedKpiRow(isDark),
            ),
            const SizedBox(height: 24),

            // ── Best Employees of the Month ──

            // ── Predicted Retention Line Chart ──
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: _buildRetentionLineChart(l10n, isDark, primaryColor),
            ),
            const SizedBox(height: 16),

            // ── Attrition Risk Horizontal Bars ──
            FadeInUp(
              delay: const Duration(milliseconds: 380),
              child: _buildAttritionByBU(l10n, isDark),
            ),
            const SizedBox(height: 16),

            // ── Donut + Heat Map Row ──
            FadeInUp(
              delay: const Duration(milliseconds: 440),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildAttritionDonut(l10n, isDark)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTalentHeatMap(l10n, isDark)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Tenure Headcount Bar Chart ──
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: _buildTenureChart(l10n, isDark),
            ),
            const SizedBox(height: 16),

            // ── Gender Ratio Stacked Bar ──
            FadeInUp(
              delay: const Duration(milliseconds: 560),
              child: _buildGenderRatioChart(l10n, isDark, primaryColor),
            ),
            const SizedBox(height: 16),

            // ── Salary Summary ──
            FadeInUp(
              delay: const Duration(milliseconds: 620),
              child: _buildSalarySummary(l10n, isDark),
            ),
            const SizedBox(height: 16),

            // ── Upcoming Events ──
            FadeInUp(
              delay: const Duration(milliseconds: 680),
              child: _buildUpcomingEvents(l10n, isDark, primaryColor),
            ),
            const SizedBox(height: 16),

            // // ── Performance Snapshot (Quarterly bar) ──
            FadeInUp(
              delay: const Duration(milliseconds: 740),
              child: _buildPerformanceSnapshot(l10n, isDark),
            ),
            const SizedBox(height: 16),

            // ── Latest News ──
          ],
        ),
      ),
    );
  }

  // ── Animated KPI Counter Cards ──
  Widget _buildAnimatedKpiRow(bool isDark) {
    final kpis = [
      _KpiData(
        'Top Talent\nRetained',
        75,
        '%',
        AppColors.primary,
        Icons.workspace_premium_rounded,
      ),
      _KpiData(
        'Total\nEmployees',
        1210,
        '',
        AppColors.info,
        Icons.people_rounded,
      ),
      _KpiData(
        'Annualized\nRetention',
        74,
        '%',
        AppColors.secondary,
        Icons.trending_up_rounded,
      ),
      _KpiData(
        'Avg Tenure\n(yrs)',
        9,
        '',
        AppColors.success,
        Icons.schedule_rounded,
      ),
    ];
    return SizedBox(
      height: 125,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kpis.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final k = kpis[i];
          return AnimatedBuilder(
            animation: _kpiAnimation,
            builder: (_, _) {
              final val = (k.target * _kpiAnimation.value).round();
              return Container(
                width: 140,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(bottom: BorderSide(color: k.color, width: 3)),
                  boxShadow: [
                    BoxShadow(
                      color: k.color.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: k.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(k.icon, color: k.color, size: 14),
                        ),
                        const Spacer(),
                        Container(
                          width: 28,
                          height: 3,
                          decoration: BoxDecoration(
                            color: k.color.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: _kpiAnimation.value,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: k.color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$val${k.suffix}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: k.color,
                      ),
                    ),
                    Text(
                      k.label,
                      style: TextStyle(
                        fontSize: 9,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ── Predicted Retention Line Chart ──
  Widget _buildRetentionLineChart(
    AppLocalizations l10n,
    bool isDark,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            'Predicted Retention by High Performer',
            'Q2 2018 – Q2 2020',
            primaryColor,
            isDark,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: (isDark ? Colors.white : Colors.black).withOpacity(
                      0.05,
                    ),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}%',
                        style: TextStyle(
                          fontSize: 9,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const labels = [
                          'Q2 18',
                          'Q4 18',
                          'Q2 19',
                          'Q4 19',
                          'Q2 20',
                        ];
                        final i = v.toInt();
                        if (i < 0 || i >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 9,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 4,
                minY: 60,
                maxY: 92,
                lineBarsData: [
                  // High Performance (Gold)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 86),
                      FlSpot(1, 83),
                      FlSpot(2, 81),
                      FlSpot(3, 74),
                      FlSpot(4, 68),
                    ],
                    isCurved: true,
                    color: AppColors.secondary,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                        radius: 3.5,
                        color: AppColors.secondary,
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.secondary.withOpacity(0.06),
                    ),
                  ),
                  // High Potential (Cyan)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 80),
                      FlSpot(1, 81),
                      FlSpot(2, 79),
                      FlSpot(3, 72),
                      FlSpot(4, 65),
                    ],
                    isCurved: true,
                    color: AppColors.accent,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                        radius: 3.5,
                        color: AppColors.accent,
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.accent.withOpacity(0.06),
                    ),
                  ),
                  // Top Talent (Deep Teal)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 83),
                      FlSpot(1, 84),
                      FlSpot(2, 80),
                      FlSpot(3, 74),
                      FlSpot(4, 69),
                    ],
                    isCurved: true,
                    color: AppColors.darkTeal,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                        radius: 3.5,
                        color: AppColors.darkTeal,
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.darkTeal.withOpacity(0.06),
                    ),
                  ),
                  // Forecast (dashed grey)
                  LineChartBarData(
                    spots: const [FlSpot(3, 74), FlSpot(4, 68)],
                    isCurved: false,
                    color: Colors.grey.withOpacity(0.4),
                    barWidth: 1.5,
                    dashArray: [5, 4],
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.grey.withOpacity(0.06),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _legendItem('High Performance', AppColors.secondary),
              const SizedBox(width: 12),
              _legendItem('High Potential', AppColors.accent),
              const SizedBox(width: 12),
              _legendItem('Top Talent', AppColors.darkTeal),
              const SizedBox(width: 12),
              _legendItemDashed('Forecast', Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  // ── Attrition Risk by Business Unit (animated horizontal bars) ──
  Widget _buildAttritionByBU(AppLocalizations l10n, bool isDark) {
    final units = [
      _BUData('Human Resources', 93, AppColors.primary),
      _BUData('Finance', 89, AppColors.darkTeal),
      _BUData('R&D', 77, AppColors.accent),
      _BUData('Sales', 71, AppColors.secondary),
      _BUData('Marketing', 65, AppColors.chartOrange),
      _BUData('Operations', 60, AppColors.chartPurple),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            'Top Talent Retention by Business Unit',
            'This Year',
            AppColors.primary,
            isDark,
          ),
          const SizedBox(height: 16),
          ...units.map(
            (u) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          u.name,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _barAnimation,
                          builder: (_, _) {
                            return Stack(
                              children: [
                                Container(
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: u.color.withOpacity(
                                      isDark ? 0.15 : 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor:
                                      (u.value / 100) * _barAnimation.value,
                                  child: Container(
                                    height: 18,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          u.color.withOpacity(0.7),
                                          u.color,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Text(
                                      _barAnimation.value > 0.5
                                          ? '${u.value}%'
                                          : '',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Attrition Risk Donut ──
  Widget _buildAttritionDonut(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Predicted Attrition Risk',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 36,
                startDegreeOffset: -90,
                sections: [
                  PieChartSectionData(
                    value: 513,
                    title: '513',
                    color: AppColors.primary,
                    radius: 38,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: 172,
                    title: '172',
                    color: AppColors.secondary,
                    radius: 32,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                pieTouchData: PieTouchData(touchCallback: (_, _) {}),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _legendItem('Retained 74.9%', AppColors.primary),
          const SizedBox(height: 4),
          _legendItem('At Risk 25.1%', AppColors.secondary),
        ],
      ),
    );
  }

  // ── Talent Heat Map (Performance × Potential) ──
  Widget _buildTalentHeatMap(AppLocalizations l10n, bool isDark) {
    // [High, Med, Low] x [Low, Medium, High potential]
    final cells = [
      [72, 82, 72],
      [76, 59, 59],
      [59, 68, 80],
    ];
    final rowLabels = ['High', 'Med', 'Low'];
    final colLabels = ['Low', 'Med', 'High'];

    Color heatColor(int v) {
      if (v >= 80) return AppColors.success;
      if (v >= 70) return AppColors.success.withOpacity(0.6);
      if (v >= 60) return AppColors.warning.withOpacity(0.7);
      return AppColors.error.withOpacity(0.6);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      height: 262,
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Talent Heat Map',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Performance × Potential',
            style: TextStyle(
              fontSize: 9,
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
          ),
          const SizedBox(height: 12),
          // Column headers
          Row(
            children: [
              const SizedBox(width: 32),
              ...colLabels.map(
                (c) => Expanded(
                  child: Center(
                    child: Text(
                      c,
                      style: TextStyle(
                        fontSize: 9,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...List.generate(
            3,
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      rowLabels[row],
                      style: TextStyle(
                        fontSize: 9,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.grey,
                      ),
                    ),
                  ),
                  ...List.generate(3, (col) {
                    final val = cells[row][col];
                    final color = heatColor(val);
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 38,
                        decoration: BoxDecoration(
                          color: color.withOpacity(isDark ? 0.4 : 0.25),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: color.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$val',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : color.withOpacity(0.9).withAlpha(220),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tenure Headcount Bar Chart ──
  Widget _buildTenureChart(AppLocalizations l10n, bool isDark) {
    final colors = [
      AppColors.primary,
      AppColors.darkTeal,
      AppColors.secondary,
      AppColors.accent,
      AppColors.chartOrange,
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            'Average Tenure (years)',
            'Headcount Distribution',
            AppColors.primary,
            isDark,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 5000,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, _, rod, _) {
                      const labels = [
                        '<2yr',
                        '2-5yr',
                        '6-10yr',
                        '11-19yr',
                        '20+yr',
                      ];
                      return BarTooltipItem(
                        '${labels[group.x]}\n${rod.toY.toInt()}',
                        const TextStyle(color: Colors.white, fontSize: 11),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const labels = [
                          '<2yr',
                          '2-5yr',
                          '6-10yr',
                          '11-19yr',
                          '20+yr',
                        ];
                        final i = v.toInt();
                        if (i < 0 || i >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 9,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (v, _) => Text(
                        '${(v / 1000).toStringAsFixed(0)}K',
                        style: TextStyle(
                          fontSize: 9,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: (isDark ? Colors.white : Colors.black).withOpacity(
                      0.05,
                    ),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _barGroup(0, 300, colors[0], showBack: true, backY: 5000),
                  _barGroup(1, 2500, colors[1], showBack: true, backY: 5000),
                  _barGroup(2, 4000, colors[2], showBack: true, backY: 5000),
                  _barGroup(3, 3500, colors[3], showBack: true, backY: 5000),
                  _barGroup(4, 1000, colors[4], showBack: true, backY: 5000),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(
    int x,
    double y,
    Color color, {
    bool showBack = false,
    double backY = 5,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 28,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: showBack,
            toY: backY,
            color: color.withOpacity(0.07),
          ),
        ),
      ],
    );
  }

  // ── Gender Ratio Stacked Bar ──
  Widget _buildGenderRatioChart(
    AppLocalizations l10n,
    bool isDark,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            'Female Gender Ratio',
            '44% • Target 88.8%',
            AppColors.secondary,
            isDark,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const labels = [
                          'Q4 21',
                          'Q1 22',
                          'Q2 22',
                          'Q3 22',
                          'Q4 22',
                          'Q1 23',
                        ];
                        final i = v.toInt();
                        if (i < 0 || i >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 8,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}%',
                        style: TextStyle(
                          fontSize: 9,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: (isDark ? Colors.white : Colors.black).withOpacity(
                      0.05,
                    ),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _stackedBarGroup(0, 42, 58),
                  _stackedBarGroup(1, 43, 57),
                  _stackedBarGroup(2, 44, 56),
                  _stackedBarGroup(3, 46, 54),
                  _stackedBarGroup(4, 47, 53),
                  _stackedBarGroup(5, 44, 56),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _legendItem('Women Ratio', AppColors.secondary),
              const SizedBox(width: 16),
              _legendItem('Gender Ratio', AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _stackedBarGroup(int x, double women, double men) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: 100,
          width: 28,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          rodStackItems: [
            BarChartRodStackItem(0, women, AppColors.secondary),
            BarChartRodStackItem(women, 100, AppColors.primary),
          ],
        ),
      ],
    );
  }

  // ── Salary Summary ──
  Widget _buildSalarySummary(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            'Salary Overview',
            'April 2024',
            AppColors.primary,
            isDark,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _salaryItem(
                  'Basic',
                  'SAR 12,500',
                  AppColors.primary,
                  isDark,
                ),
              ),
              Expanded(
                child: _salaryItem(
                  'Housing',
                  'SAR 3,125',
                  AppColors.chartOrange,
                  isDark,
                ),
              ),
              Expanded(
                child: _salaryItem(
                  'Transport',
                  'SAR 1,000',
                  AppColors.success,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Salary progress bars
          _salaryBar('Basic', 12500, 17625, AppColors.primary, isDark),
          const SizedBox(height: 8),
          _salaryBar('Housing', 3125, 17625, AppColors.chartOrange, isDark),
          const SizedBox(height: 8),
          _salaryBar('Transport', 1000, 17625, AppColors.success, isDark),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Net Salary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
              Text(
                'SAR 14,962.50',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _salaryBar(
    String label,
    num amount,
    num total,
    Color color,
    bool isDark,
  ) {
    return AnimatedBuilder(
      animation: _barAnimation,
      builder: (_, _) {
        final ratio = (amount / total * _barAnimation.value).clamp(0.0, 1.0);
        return Row(
          children: [
            SizedBox(
              width: 68,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'SAR ${amount.toInt()}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Performance Snapshot (quarterly bars) ──
  Widget _buildPerformanceSnapshot(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            'Performance Snapshot',
            'FY 2024',
            AppColors.primary,
            isDark,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _perfItem(
                  'Overall Rating',
                  '4.8/5',
                  AppColors.success,
                  isDark,
                ),
              ),
              Expanded(
                child: _perfItem(
                  'Goals Progress',
                  '85%',
                  AppColors.primary,
                  isDark,
                ),
              ),
              Expanded(
                child: _perfItem(
                  'Feedback Score',
                  '92%',
                  AppColors.info,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 5,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const labels = ['Q1', 'Q2', 'Q3', 'Q4'];
                        if (v.toInt() >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          labels[v.toInt()],
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  _barGroup(0, 4.2, AppColors.primary.withOpacity(0.5)),
                  _barGroup(1, 4.5, AppColors.primary.withOpacity(0.7)),
                  _barGroup(2, 4.8, AppColors.success),
                  _barGroup(3, 0, Colors.grey.withOpacity(0.2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _perfItem(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
          ),
        ),
      ],
    );
  }

  // ── Upcoming Events ──
  Widget _buildUpcomingEvents(
    AppLocalizations l10n,
    bool isDark,
    Color primaryColor,
  ) {
    final events = [
      {
        'title': 'Performance Review Deadline',
        'date': 'Apr 20, 2024',
        'icon': Icons.rate_review_rounded,
        'color': AppColors.warning,
      },
      {
        'title': 'Training: Flutter Advanced',
        'date': 'Apr 22, 2024',
        'icon': Icons.school_rounded,
        'color': AppColors.info,
      },
      {
        'title': 'Annual Leave Start',
        'date': 'Apr 25, 2024',
        'icon': Icons.flight_takeoff_rounded,
        'color': AppColors.success,
      },
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.upcomingEvents,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...events.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (e['color'] as Color).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      e['icon'] as IconData,
                      color: e['color'] as Color,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          e['date'] as String,
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
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── News Section ──
  Widget _buildNewsSection(
    AppLocalizations l10n,
    bool isDark,
    Color primaryColor,
  ) {
    final items = [
      {
        'title': 'Ramadan Working Hours Updated',
        'desc': 'New schedule effective from March 10',
        'image': 'assets/images/news_ramadan.png',
        'tag': 'Holiday',
        'color': AppColors.warning,
      },
      {
        'title': 'Annual Performance Bonus',
        'desc': 'Performance bonus distribution Q1 details',
        'image': 'assets/images/news_bonus.png',
        'tag': 'Financial',
        'color': AppColors.success,
      },
      {
        'title': 'New Leadership Workshop',
        'desc': 'Registration open until Apr 18',
        'image': 'assets/images/news_workshop.png',
        'tag': 'Training',
        'color': AppColors.info,
      },
      {
        'title': 'IT Policy Update',
        'desc': 'New BYOD and security guidelines released',
        'image': 'assets/images/news_security.png',
        'tag': 'Security',
        'color': AppColors.primary,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Text(
                l10n.news,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewsOffersScreen()),
                ),
                child: Text(
                  l10n.viewAll,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _newsPageController,
            onPageChanged: (index) {
              setState(() => _newsCurrentPage = index);
              _startNewsTimer(); // Reset timer on manual scroll
            },
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return AnimatedBuilder(
                animation: _newsPageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_newsPageController.position.haveDimensions) {
                    value = _newsPageController.page! - index;
                    value = (1 - (value.abs() * 0.1)).clamp(0.0, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeInOut.transform(value) * 190,
                      width: Curves.easeInOut.transform(value) * 400,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Background Image
                        Image.asset(
                          item['image'] as String,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: (item['color'] as Color).withOpacity(
                                    0.85,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['tag'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['title'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['desc'] as String,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
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
          ),
        ),
        const SizedBox(height: 16),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _newsCurrentPage == index ? 20 : 6,
              decoration: BoxDecoration(
                color: _newsCurrentPage == index
                    ? primaryColor
                    : primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SHARED HELPERS
  // ════════════════════════════════════════════════════════════════════

  BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
    color: isDark ? AppColors.darkCard : Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  Widget _cardHeader(String title, String sub, Color color, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            sub,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _legendItemDashed(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, Colors.transparent, color],
              stops: const [0, 0.5, 1],
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _salaryItem(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
          ),
        ),
      ],
    );
  }

  // ── Header ──
  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    Color primaryColor,
  ) {
    return Row(
      children: [
        _buildProfileAvatar(
          'assets/images/522857168_2687827868079555_4260036537523520364_n.jpg',
          AppColors.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting(l10n)} 👋',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                ),
              ),
              const Text(
                'Ahmed Al-Rashid',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              Text(
                'EMP-2024-0847 • Solutions Dept',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () => _showNotificationsSheet(context, l10n, isDark),
              icon: Icon(
                Icons.notifications_rounded,
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
          icon: Icon(
            Icons.settings_rounded,
            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
          ),
        ),
      ],
    );
  }

  // ── Employee Banner ──
  Widget _buildEmployeeBanner(bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Senior Consultant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Solutions & Consultancy Division',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _bannerChip(
                      'Active',
                      Icons.check_circle_outline,
                      Colors.greenAccent,
                    ),
                    const SizedBox(width: 8),
                    _bannerChip(
                      'Grade 12',
                      Icons.military_tech_outlined,
                      Colors.amberAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  '4.8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Rating',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickChip(
    IconData icon,
    String label,
    Color color,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SERVICES TAB
  // ════════════════════════════════════════════════════════════════════

  void _openDetail(BuildContext ctx, String title, IconData icon, Color color) {
    Navigator.push(
      ctx,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, a, _) => FadeTransition(
          opacity: a,
          child: ServiceDetailScreen(title: title, icon: icon, color: color),
        ),
      ),
    );
  }

  Widget _buildServicesGrid(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    Color primaryColor,
  ) {
    const teal = AppColors.primary;
    const gold = AppColors.secondary;
    const cyan = AppColors.accent;
    const deepTeal = AppColors.darkTeal;

    int sectionDelay = 0;

    Widget section(
      String title,
      IconData headerIcon,
      Color headerColor,
      List<_SvcItem> items,
    ) {
      sectionDelay += 100;
      final delay = sectionDelay;
      return FadeInUp(
        delay: Duration(milliseconds: delay),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              title,
              headerIcon,
              headerColor,
              isDark,
              items.length,
            ),
            const SizedBox(height: 10),
            _serviceGrid(context, isDark, items),
            const SizedBox(height: 18),
          ],
        ),
      );
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: buildHeader(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
              child: Column(
                children: [
                  section(
                    l10n.standardHRServices,
                    Icons.people_alt_rounded,
                    teal,
                    [
                      _SvcItem(
                        Icons.event_available_rounded,
                        l10n.leaveManagement,
                        teal,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LeaveScreen(),
                          ),
                        ),
                      ),
                      _SvcItem(
                        Icons.edit_note_rounded,
                        l10n.basicDataUpdate,
                        deepTeal,
                        () => _openDetail(
                          context,
                          l10n.basicDataUpdate,
                          Icons.edit_note_rounded,
                          deepTeal,
                        ),
                      ),
                      _SvcItem(
                        Icons.phone_android_rounded,
                        l10n.phoneData,
                        cyan,
                        () => _openDetail(
                          context,
                          l10n.phoneData,
                          Icons.phone_android_rounded,
                          cyan,
                        ),
                      ),
                      _SvcItem(
                        Icons.location_on_rounded,
                        l10n.addressData,
                        teal,
                        () => _openDetail(
                          context,
                          l10n.addressData,
                          Icons.location_on_rounded,
                          teal,
                        ),
                      ),
                      _SvcItem(
                        Icons.school_rounded,
                        l10n.educationalQualifications,
                        gold,
                        () => _openDetail(
                          context,
                          l10n.educationalQualifications,
                          Icons.school_rounded,
                          gold,
                        ),
                      ),
                      _SvcItem(
                        Icons.exit_to_app_rounded,
                        l10n.terminationOfServices,
                        deepTeal,
                        () => _openDetail(
                          context,
                          l10n.terminationOfServices,
                          Icons.exit_to_app_rounded,
                          deepTeal,
                        ),
                      ),
                      _SvcItem(
                        Icons.family_restroom_rounded,
                        l10n.familyAndReferences,
                        cyan,
                        () => _openDetail(
                          context,
                          l10n.familyAndReferences,
                          Icons.family_restroom_rounded,
                          cyan,
                        ),
                      ),
                      _SvcItem(
                        Icons.swap_horiz_rounded,
                        l10n.leaveDelegationRules,
                        gold,
                        () => _openDetail(
                          context,
                          l10n.leaveDelegationRules,
                          Icons.swap_horiz_rounded,
                          gold,
                        ),
                      ),
                    ],
                  ),
                  section(
                    l10n.extendedServices,
                    Icons.extension_rounded,
                    gold,
                    [
                      _SvcItem(
                        Icons.description_rounded,
                        l10n.requests,
                        teal,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RequestsScreen(),
                          ),
                        ),
                      ),
                      _SvcItem(
                        Icons.badge_rounded,
                        l10n.employmentInfo,
                        gold,
                        () => _openDetail(
                          context,
                          l10n.employmentInfo,
                          Icons.badge_rounded,
                          gold,
                        ),
                      ),
                    ],
                  ),
                  section(
                    l10n.specialistDashboard,
                    Icons.dashboard_customize_rounded,
                    cyan,
                    [
                      _SvcItem(
                        Icons.insights_rounded,
                        l10n.hrInsights,
                        cyan,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HRInsightsScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  section(l10n.attendance, Icons.fingerprint_rounded, teal, [
                    _SvcItem(
                      Icons.fingerprint_rounded,
                      l10n.attendance,
                      teal,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AttendanceScreen(),
                        ),
                      ),
                    ),
                  ]),
                  section(
                    l10n.performanceEvaluation,
                    Icons.trending_up_rounded,
                    gold,
                    [
                      _SvcItem(
                        Icons.flag_rounded,
                        l10n.goalsManagement,
                        gold,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PerformanceScreen(),
                          ),
                        ),
                      ),
                      _SvcItem(
                        Icons.feedback_rounded,
                        l10n.continuousFeedback,
                        teal,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PerformanceScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  section(
                    l10n.financialNotifications,
                    Icons.account_balance_rounded,
                    deepTeal,
                    [
                      _SvcItem(
                        Icons.receipt_long_rounded,
                        l10n.invoices,
                        deepTeal,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FinanceScreen(),
                          ),
                        ),
                      ),
                      _SvcItem(
                        Icons.book_rounded,
                        l10n.consolidatedEntries,
                        teal,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FinanceScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  section(l10n.procurement, Icons.shopping_cart_rounded, cyan, [
                    _SvcItem(
                      Icons.shopping_bag_rounded,
                      l10n.purchaseRequests,
                      cyan,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProcurementScreen(),
                        ),
                      ),
                    ),
                    _SvcItem(
                      Icons.emoji_events_rounded,
                      l10n.achievementCertificates,
                      gold,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProcurementScreen(),
                        ),
                      ),
                    ),
                    _SvcItem(
                      Icons.local_shipping_rounded,
                      l10n.itemTransfers,
                      teal,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProcurementScreen(),
                        ),
                      ),
                    ),
                  ]),
                  section(l10n.dashboard, Icons.bar_chart_rounded, teal, [
                    _SvcItem(
                      Icons.event_busy_rounded,
                      l10n.absencePlans,
                      teal,
                      () => _openDetail(
                        context,
                        l10n.absencePlans,
                        Icons.event_busy_rounded,
                        teal,
                      ),
                    ),
                    _SvcItem(
                      Icons.receipt_rounded,
                      l10n.payslip,
                      gold,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const payroll_service.PayrollScreen(),
                        ),
                      ),
                    ),
                    _SvcItem(
                      Icons.swap_vert_rounded,
                      l10n.salaryChanges,
                      deepTeal,
                      () => _openDetail(
                        context,
                        l10n.salaryChanges,
                        Icons.swap_vert_rounded,
                        deepTeal,
                      ),
                    ),
                    _SvcItem(
                      Icons.assignment_rounded,
                      l10n.selfServices,
                      cyan,
                      () => _openDetail(
                        context,
                        l10n.selfServices,
                        Icons.assignment_rounded,
                        cyan,
                      ),
                    ),
                    _SvcItem(
                      Icons.campaign_rounded,
                      l10n.news,
                      teal,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NewsOffersScreen(),
                        ),
                      ),
                    ),
                    _SvcItem(
                      Icons.local_offer_rounded,
                      l10n.offers,
                      gold,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NewsOffersScreen(),
                        ),
                      ),
                    ),
                    _SvcItem(
                      Icons.school_rounded,
                      l10n.training,
                      cyan,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DocumentsScreen(),
                        ),
                      ),
                    ),
                  ]),
                  section(
                    l10n.managerView,
                    Icons.supervisor_account_rounded,
                    deepTeal,
                    [
                      _SvcItem(
                        Icons.groups_rounded,
                        l10n.teamAttendance,
                        teal,
                        () => _openDetail(
                          context,
                          l10n.teamAttendance,
                          Icons.groups_rounded,
                          teal,
                        ),
                      ),
                      _SvcItem(
                        Icons.wc_rounded,
                        l10n.teamByGender,
                        gold,
                        () => _openDetail(
                          context,
                          l10n.teamByGender,
                          Icons.wc_rounded,
                          gold,
                        ),
                      ),
                      _SvcItem(
                        Icons.military_tech_rounded,
                        l10n.teamByGrade,
                        cyan,
                        () => _openDetail(
                          context,
                          l10n.teamByGrade,
                          Icons.military_tech_rounded,
                          cyan,
                        ),
                      ),
                      _SvcItem(
                        Icons.bar_chart_rounded,
                        l10n.headcount,
                        deepTeal,
                        () => _openDetail(
                          context,
                          l10n.headcount,
                          Icons.bar_chart_rounded,
                          deepTeal,
                        ),
                      ),
                      _SvcItem(
                        Icons.attach_money_rounded,
                        l10n.teamSalaryByDept,
                        gold,
                        () => _openDetail(
                          context,
                          l10n.teamSalaryByDept,
                          Icons.attach_money_rounded,
                          gold,
                        ),
                      ),
                      _SvcItem(
                        Icons.sync_alt_rounded,
                        l10n.hiresAndTerminations,
                        teal,
                        () => _openDetail(
                          context,
                          l10n.hiresAndTerminations,
                          Icons.sync_alt_rounded,
                          teal,
                        ),
                      ),
                    ],
                  ),
                  section(
                    l10n.documentLibrary,
                    Icons.folder_shared_rounded,
                    gold,
                    [
                      _SvcItem(
                        Icons.folder_open_rounded,
                        l10n.documents,
                        gold,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DocumentsScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  section(
                    l10n.worklistManagement,
                    Icons.checklist_rounded,
                    teal,
                    [
                      _SvcItem(
                        Icons.checklist_rounded,
                        l10n.worklist,
                        teal,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WorklistScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    String title,
    IconData icon,
    Color color,
    bool isDark,
    int count,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(isDark ? 0.20 : 0.10),
            color.withOpacity(isDark ? 0.08 : 0.03),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : color,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceGrid(BuildContext ctx, bool isDark, List<_SvcItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final s = items[i];
        return FadeInUp(
          delay: Duration(milliseconds: 50 * i),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: s.onTap,
              borderRadius: BorderRadius.circular(16),
              splashColor: s.color.withOpacity(0.15),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: s.color.withOpacity(isDark ? 0.15 : 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: s.color.withOpacity(isDark ? 0.08 : 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            s.color.withOpacity(0.15),
                            s.color.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(s.icon, color: s.color, size: 24),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        s.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00838F), Color(0xFF006064), Color(0xFF004D50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: 60,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.08),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: FadeInDown(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // top row
                    Row(
                      children: [
                        // logo block
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: const Icon(
                            Icons.grid_view_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Enterprise HRM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .3,
                                ),
                              ),
                              Text(
                                'ERP & HCM Portal',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.55),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // notification bell
                        GestureDetector(
                          // onTap: () => _showNotificationsSheet(context,l10n,isDark),
                          child: Stack(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.18),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.notifications_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              Positioned(
                                top: 7,
                                right: 7,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF006064),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // avatar
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD4AF37), Color(0xFFB8960C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'AH',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // stat pills
                    Row(
                      children: [
                        _statPill('42', 'Total Services', false),
                        const SizedBox(width: 8),
                        _statPill('3', 'New Alerts', true),
                        const SizedBox(width: 8),
                        _statPill('98%', 'Uptime', false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statPill(String num, String label, bool isGold) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isGold
              ? AppColors.secondary.withOpacity(0.15)
              : Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isGold
                ? AppColors.secondary.withOpacity(0.25)
                : Colors.white.withOpacity(0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              num,
              style: TextStyle(
                color: isGold ? AppColors.secondary : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                letterSpacing: .4,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ════════════════════════════════════════════════════════════════════
  // NOTIFICATIONS
  // ════════════════════════════════════════════════════════════════════

  void _showNotificationsSheet(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final items = [
      {
        'title': 'Leave Approved',
        'desc': 'Annual leave Apr 20–25 approved by Sarah R.',
        'time': '2h ago',
        'icon': Icons.check_circle_rounded,
        'color': AppColors.success,
        'read': false,
      },
      {
        'title': 'Payslip Available',
        'desc': 'March 2024 payslip ready to view',
        'time': '1d ago',
        'icon': Icons.receipt_rounded,
        'color': AppColors.secondary,
        'read': false,
      },
      {
        'title': 'Performance Review Due',
        'desc': 'Complete self-assessment by Apr 20',
        'time': '3d ago',
        'icon': Icons.rate_review_rounded,
        'color': AppColors.info,
        'read': false,
      },
      {
        'title': 'Invoice #INV-3321 Approved',
        'desc': 'SAR 45,000 vendor payment cleared',
        'time': '3d ago',
        'icon': Icons.receipt_long_rounded,
        'color': AppColors.chartOrange,
        'read': true,
      },
      {
        'title': 'PO-4412 Status Update',
        'desc': 'HP Monitor order shipped',
        'time': '4d ago',
        'icon': Icons.local_shipping_rounded,
        'color': AppColors.chartTeal,
        'read': true,
      },
      {
        'title': 'Training Registration',
        'desc': 'Flutter Advanced workshop Apr 22',
        'time': '1w ago',
        'icon': Icons.school_rounded,
        'color': AppColors.chartPurple,
        'read': true,
      },
      {
        'title': 'Attendance Alert',
        'desc': 'Late arrival recorded on Apr 8',
        'time': '1w ago',
        'icon': Icons.warning_rounded,
        'color': AppColors.warning,
        'read': true,
      },
      {
        'title': 'Delegation Rule Active',
        'desc': 'Leave approval delegated to Omar K.',
        'time': '2w ago',
        'icon': Icons.swap_horiz_rounded,
        'color': AppColors.primary,
        'read': true,
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            l10n.notifications,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '3 new',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Mark all read',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 6),
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final isUnread = !(item['read'] as bool);
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUnread
                              ? (item['color'] as Color).withOpacity(
                                  isDark ? 0.08 : 0.05,
                                )
                              : (isDark ? AppColors.darkCard : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: isUnread
                              ? Border(
                                  left: BorderSide(
                                    color: item['color'] as Color,
                                    width: 3,
                                  ),
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isDark ? 0.1 : 0.03,
                              ),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (item['color'] as Color).withOpacity(
                                  0.12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: item['color'] as Color,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      fontWeight: isUnread
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    item['desc'] as String,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.grey,
                                    ),
                                  ),
                                  Text(
                                    item['time'] as String,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: isDark
                                          ? Colors.white38
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: item['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────

class _SvcItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SvcItem(this.icon, this.label, this.color, this.onTap);
}

class _KpiData {
  final String label;
  final int target;
  final String suffix;
  final Color color;
  final IconData icon;
  const _KpiData(this.label, this.target, this.suffix, this.color, this.icon);
}

class _BUData {
  final String name;
  final int value;
  final Color color;
  const _BUData(this.name, this.value, this.color);
}

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

class _BottomNavBar extends StatelessWidget {
  // Changed to StatelessWidget as parent handles state
  final double width;
  final bool isDark;
  final AppLocalizations labels;
  final int currentIndex;
  final Function(int) onChanged; // Added this

  const _BottomNavBar({
    required this.width,
    required this.isDark,
    required this.labels,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 85,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(width, 85),
            painter: BNBCustomPainter(isDark: isDark),
          ),
          // Positioned FAB
          Positioned(top: -20, left: width / 2 - 33, child: const CenterFAB()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(0, Icons.home_rounded, labels.home),
              _item(1, Icons.dashboard, labels.services),
              const SizedBox(width: 60), // Space for FAB
              _item(2, Icons.people_rounded, labels.myTeam),
              _item(3, Icons.person_rounded, labels.profile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(int index, IconData icon, String label) {
    return BottomNavBarItem(
      icon: icon,
      label: label,
      isSelected: currentIndex == index,
      onTap: () => onChanged(index), // Trigger the parent update
    );
  }
}

class BottomNavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomNavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Professional color logic based on your AppColors
    final Color unselectedColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.grey;

    return Expanded(
      child: GestureDetector(
        // Using GestureDetector for a cleaner feel
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSelected
                ? ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.primaryGradient.createShader(bounds),
                    child: Icon(icon, color: Colors.white, size: 28),
                  )
                : Icon(icon, color: unselectedColor, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : AppColors.primary)
                    : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================
// Custom Painter for Bottom Navigation Bar
// =======================
class BNBCustomPainter extends CustomPainter {
  final bool isDark;

  BNBCustomPainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? AppColors.darkBackground : Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 20)
      ..quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0)
      ..quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20)
      ..arcToPoint(
        Offset(size.width * 0.60, 20),
        radius: const Radius.circular(20),
        clockwise: false,
      )
      ..quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0)
      ..quadraticBezierTo(size.width * 0.80, 0, size.width, 20)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawShadow(path, Colors.black, isDark ? 8 : 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BNBCustomPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

class CenterFAB extends StatelessWidget {
  const CenterFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => RequestsScreen()));
      },
      child: Container(
        decoration: BoxDecoration(
          // gradient: appGradient,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? AppColors.darkBackground : Colors.white,
            width: 6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary,

          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(Icons.add, color: AppColors.primary, size: 20),
          ),
        ),
      ),
    );
  }
}
