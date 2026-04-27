import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class HRInsightsScreen extends StatefulWidget {
  const HRInsightsScreen({super.key});

  @override
  State<HRInsightsScreen> createState() => _HRInsightsScreenState();
}

class _HRInsightsScreenState extends State<HRInsightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Text(
          l10n.hrInsights,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          tabs: [
            Tab(text: l10n.dashboard),
            Tab(text: l10n.managerView),
            Tab(text: l10n.specialistDashboard),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEmployeeDashboard(l10n, isDark),
          _buildManagerDashboard(l10n, isDark),
          _buildSpecialistDashboard(l10n, isDark),
        ],
      ),
    );
  }

  // ═══ Employee Dashboard ═══
  Widget _buildEmployeeDashboard(AppLocalizations l10n, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FadeInDown(child: _statsRow(isDark, l10n)),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: _attendancePieCard(l10n, isDark),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: _salaryHistoryCard(isDark),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: _selfServiceStatus(l10n, isDark),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: _trainingCard(l10n, isDark),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(bool isDark, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _statBadge(
            l10n.totalHeadcount,
            '142',
            AppColors.primary,
            isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statBadge(l10n.budgetUsed, '64%', AppColors.success, isDark),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statBadge(l10n.absencePlans, '12', AppColors.warning, isDark),
        ),
      ],
    );
  }

  Widget _statBadge(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendancePieCard(AppLocalizations l10n, bool isDark) {
    return _card(
      isDark,
      l10n.attendanceOverview,
      child: SizedBox(
        height: 180,
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                  sections: [
                    PieChartSectionData(
                      value: 20,
                      title: '20',
                      color: AppColors.success,
                      radius: 35,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 3,
                      title: '3',
                      color: AppColors.error,
                      radius: 35,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 2,
                      title: '2',
                      color: AppColors.warning,
                      radius: 35,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 4,
                      title: '4',
                      color: AppColors.info,
                      radius: 35,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _legend('Present', AppColors.success, '20'),
                _legend('Absent', AppColors.error, '3'),
                _legend('Late', AppColors.warning, '2'),
                _legend('Remote', AppColors.info, '4'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _salaryHistoryCard(bool isDark) {
    return _card(
      isDark,
      'Salary Changes',
      child: SizedBox(
        height: 160,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 10),
                  FlSpot(1, 11),
                  FlSpot(2, 11.5),
                  FlSpot(3, 12.5),
                  FlSpot(4, 12.5),
                  FlSpot(5, 14.9),
                ],
                isCurved: true,
                color: AppColors.primary,
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.primary.withOpacity(0.1),
                ),
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    const labels = [
                      '2019',
                      '2020',
                      '2021',
                      '2022',
                      '2023',
                      '2024',
                    ];
                    if (v.toInt() >= labels.length) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      labels[v.toInt()],
                      style: const TextStyle(fontSize: 9),
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
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  Widget _selfServiceStatus(AppLocalizations l10n, bool isDark) {
    final items = [
      {'title': 'Leave Requests', 'approved': 8, 'pending': 1, 'rejected': 0},
      {
        'title': 'Certificate Requests',
        'approved': 3,
        'pending': 0,
        'rejected': 1,
      },
      {'title': 'Data Updates', 'approved': 5, 'pending': 2, 'rejected': 0},
    ];
    return _card(
      isDark,
      l10n.selfServices,
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _statusChip('${item['approved']}', AppColors.success),
                    const SizedBox(width: 4),
                    _statusChip('${item['pending']}', AppColors.warning),
                    const SizedBox(width: 4),
                    _statusChip('${item['rejected']}', AppColors.error),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _trainingCard(AppLocalizations l10n, bool isDark) {
    final courses = [
      {
        'name': 'Flutter Advanced Development',
        'status': 'Enrolled',
        'progress': 0.6,
        'color': AppColors.info,
      },
      {
        'name': 'Leadership Excellence',
        'status': 'Completed',
        'progress': 1.0,
        'color': AppColors.success,
      },
      {
        'name': 'Arabic Communication Skills',
        'status': 'Not Started',
        'progress': 0.0,
        'color': AppColors.grey,
      },
    ];
    return _card(
      isDark,
      l10n.training,
      child: Column(
        children: courses
            .map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['name'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: c['progress'] as double,
                            color: c['color'] as Color,
                            backgroundColor: (c['color'] as Color).withOpacity(
                              0.15,
                            ),
                            minHeight: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      c['status'] as String,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: c['color'] as Color,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ═══ Manager Dashboard ═══
  Widget _buildManagerDashboard(AppLocalizations l10n, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FadeInDown(child: _teamGenderChart(l10n, isDark)),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: _teamByGradeChart(l10n, isDark),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: _headcountByDept(l10n, isDark),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: _hiresTerminationsChart(l10n, isDark),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: _teamSalaryBenchmark(l10n, isDark),
          ),
        ],
      ),
    );
  }

  Widget _teamGenderChart(AppLocalizations l10n, bool isDark) {
    return _card(
      isDark,
      l10n.teamByGender,
      child: SizedBox(
        height: 160,
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 65,
                      title: '65%',
                      color: AppColors.primary,
                      radius: 40,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 35,
                      title: '35%',
                      color: AppColors.secondary,
                      radius: 40,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _legend(l10n.male, AppColors.primary, '92'),
                _legend(l10n.female, AppColors.secondary, '50'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamByGradeChart(AppLocalizations l10n, bool isDark) {
    return _card(
      isDark,
      l10n.teamByGrade,
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            maxY: 50,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: 12,
                    color: AppColors.primary,
                    width: 18,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: 28,
                    color: AppColors.info,
                    width: 18,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: 45,
                    color: AppColors.success,
                    width: 18,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                    toY: 35,
                    color: AppColors.secondary,
                    width: 18,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 4,
                barRods: [
                  BarChartRodData(
                    toY: 22,
                    color: AppColors.chartPurple,
                    width: 18,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    const labels = [
                      'Exec',
                      'Senior',
                      'Mid',
                      'Junior',
                      'Intern',
                    ];
                    if (v.toInt() >= labels.length) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      labels[v.toInt()],
                      style: const TextStyle(fontSize: 9),
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
          ),
        ),
      ),
    );
  }

  Widget _headcountByDept(AppLocalizations l10n, bool isDark) {
    final depts = [
      {'name': 'Engineering', 'count': 42, 'color': AppColors.primary},
      {'name': 'Sales', 'count': 28, 'color': AppColors.success},
      {'name': 'HR', 'count': 15, 'color': AppColors.secondary},
      {'name': 'Marketing', 'count': 18, 'color': AppColors.info},
      {'name': 'Operations', 'count': 22, 'color': AppColors.chartOrange},
      {'name': 'Finance', 'count': 10, 'color': AppColors.chartPurple},
      {'name': 'Legal', 'count': 7, 'color': AppColors.chartTeal},
    ];
    return _card(
      isDark,
      l10n.headcount,
      child: Column(
        children: depts
            .map(
              (d) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: d['color'] as Color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        d['name'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      '${d['count']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: d['color'] as Color,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _hiresTerminationsChart(AppLocalizations l10n, bool isDark) {
    return _card(
      isDark,
      l10n.hiresAndTerminations,
      child: SizedBox(
        height: 160,
        child: BarChart(
          BarChartData(
            barGroups: List.generate(
              6,
              (i) => BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: [8, 12, 6, 15, 10, 9][i].toDouble(),
                    color: AppColors.success,
                    width: 12,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                  BarChartRodData(
                    toY: [3, 5, 2, 4, 6, 3][i].toDouble(),
                    color: AppColors.error,
                    width: 12,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                    if (v.toInt() >= labels.length) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      labels[v.toInt()],
                      style: const TextStyle(fontSize: 9),
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
          ),
        ),
      ),
    );
  }

  Widget _teamSalaryBenchmark(AppLocalizations l10n, bool isDark) {
    final data = [
      {'dept': 'Engineering', 'avg': 'SAR 18,500', 'color': AppColors.primary},
      {'dept': 'Sales', 'avg': 'SAR 15,200', 'color': AppColors.success},
      {'dept': 'HR', 'avg': 'SAR 14,000', 'color': AppColors.secondary},
      {'dept': 'Marketing', 'avg': 'SAR 13,800', 'color': AppColors.info},
      {'dept': 'Finance', 'avg': 'SAR 16,500', 'color': AppColors.chartPurple},
    ];
    return _card(
      isDark,
      l10n.teamSalaryByDept,
      child: Column(
        children: data
            .map(
              (d) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: d['color'] as Color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        d['dept'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      d['avg'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: d['color'] as Color,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ═══ Specialist Dashboard ═══
  Widget _buildSpecialistDashboard(AppLocalizations l10n, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FadeInDown(
            child: _card(
              isDark,
              l10n.departmentalPerformance,
              child: SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    maxY: 100,
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: 88,
                            color: AppColors.primary,
                            width: 20,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: 75,
                            color: AppColors.secondary,
                            width: 20,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: 92,
                            color: AppColors.success,
                            width: 20,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            toY: 68,
                            color: AppColors.warning,
                            width: 20,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                            toY: 84,
                            color: AppColors.chartTeal,
                            width: 20,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            const labels = [
                              'Sales',
                              'IT',
                              'HR',
                              'Ops',
                              'Finance',
                            ];
                            if (v.toInt() >= labels.length) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              labels[v.toInt()],
                              style: const TextStyle(fontSize: 9),
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
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: _card(
              isDark,
              l10n.financialInsights,
              child: SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 10),
                          FlSpot(1, 15),
                          FlSpot(2, 25),
                          FlSpot(3, 40),
                          FlSpot(4, 38),
                          FlSpot(5, 45),
                        ],
                        isCurved: true,
                        color: AppColors.info,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.info.withOpacity(0.1),
                        ),
                      ),
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 12),
                          FlSpot(1, 18),
                          FlSpot(2, 22),
                          FlSpot(3, 35),
                          FlSpot(4, 32),
                          FlSpot(5, 40),
                        ],
                        isCurved: true,
                        color: AppColors.secondary,
                        barWidth: 2,
                        dashArray: [5, 5],
                      ),
                    ],
                    titlesData: const FlTitlesData(show: false),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══ Shared Helpers ═══
  Widget _card(bool isDark, String title, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _legend(String label, Color color, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Text('$label: $value', style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _statusChip(String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
