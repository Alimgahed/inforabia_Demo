// payslip_screen.dart
// Premium Payslip Screen — Panda Retail Demo
// Optimized for 60 FPS performance with RepaintBoundary and localized text support.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:Panda/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

// ─────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────

class MonthlyPayslip {
  final String month;
  final double basicSalary;
  final double housingAllowance;
  final double transportAllowance;
  final double bonus;
  final double overtime;
  final double gosi;
  final double absenceDeduction;

  const MonthlyPayslip({
    required this.month,
    required this.basicSalary,
    required this.housingAllowance,
    required this.transportAllowance,
    required this.bonus,
    required this.overtime,
    required this.gosi,
    required this.absenceDeduction,
  });

  double get totalEarnings =>
      basicSalary + housingAllowance + transportAllowance + bonus + overtime;

  double get totalDeductions => gosi + absenceDeduction;

  double get netSalary => totalEarnings - totalDeductions;
}

// ─────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  bool _earningsExpanded = true;
  bool _deductionsExpanded = true;

  late final MonthlyPayslip _current;
  late final List<MonthlyPayslip> _salaryHistory;

  @override
  void initState() {
    super.initState();
    // Static dummy data for the demo
    _salaryHistory = const [
      MonthlyPayslip(
        month: 'Nov',
        basicSalary: 8000,
        housingAllowance: 3000,
        transportAllowance: 800,
        bonus: 0,
        overtime: 200,
        gosi: 900,
        absenceDeduction: 400,
      ),
      MonthlyPayslip(
        month: 'Dec',
        basicSalary: 8000,
        housingAllowance: 3000,
        transportAllowance: 800,
        bonus: 500,
        overtime: 150,
        gosi: 900,
        absenceDeduction: 200,
      ),
      MonthlyPayslip(
        month: 'Jan',
        basicSalary: 8000,
        housingAllowance: 3000,
        transportAllowance: 800,
        bonus: 0,
        overtime: 300,
        gosi: 900,
        absenceDeduction: 0,
      ),
      MonthlyPayslip(
        month: 'Feb',
        basicSalary: 8000,
        housingAllowance: 3000,
        transportAllowance: 800,
        bonus: 200,
        overtime: 100,
        gosi: 900,
        absenceDeduction: 200,
      ),
      MonthlyPayslip(
        month: 'Mar',
        basicSalary: 8000,
        housingAllowance: 3000,
        transportAllowance: 800,
        bonus: 300,
        overtime: 250,
        gosi: 900,
        absenceDeduction: 0,
      ),
      MonthlyPayslip(
        month: 'Apr',
        basicSalary: 8000,
        housingAllowance: 3000,
        transportAllowance: 800,
        bonus: 500,
        overtime: 300,
        gosi: 900,
        absenceDeduction: 200,
      ),
    ];
    _current = _salaryHistory.last;
  }

  String _formatCurrency(double value) {
    return 'SAR ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double previousNet = _salaryHistory[_salaryHistory.length - 2].netSalary;
    final double changePercent = ((_current.netSalary - previousNet) / previousNet) * 100;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(l10n.payslip),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Net Salary Hero ──────────────────
          SliverToBoxAdapter(
            child: FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: _buildNetSalaryHero(l10n, changePercent, isDark),
            ),
          ),

          // ── Quick Summary Pills ──────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                children: [
                  _HeroPill(
                    label: l10n.totalEarnings,
                    value: _current.totalEarnings,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 12),
                  _HeroPill(
                    label: l10n.deductions,
                    value: _current.totalDeductions,
                    color: AppColors.error,
                    isDeduction: true,
                  ),
                ],
              ),
            ),
          ),

          // ── Earnings Section ─────────────────
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: _CollapsibleSection(
                title: l10n.totalEarnings,
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.success,
                isExpanded: _earningsExpanded,
                total: _current.totalEarnings,
                totalColor: AppColors.success,
                onToggle: () => setState(() => _earningsExpanded = !_earningsExpanded),
                items: [
                  _LineItem(l10n.basicSalary, _current.basicSalary, AppColors.success),
                  _LineItem(l10n.housingAllowance, _current.housingAllowance, AppColors.success),
                  _LineItem(l10n.transportAllowance, _current.transportAllowance, AppColors.success),
                  _LineItem(l10n.bonus, _current.bonus, AppColors.success),
                  _LineItem(l10n.overtime, _current.overtime, AppColors.success),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── Deductions Section ───────────────
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: _CollapsibleSection(
                title: l10n.deductions,
                icon: Icons.trending_down_rounded,
                iconColor: AppColors.error,
                isExpanded: _deductionsExpanded,
                total: _current.totalDeductions,
                totalColor: AppColors.error,
                onToggle: () => setState(() => _deductionsExpanded = !_deductionsExpanded),
                items: [
                  _LineItem(l10n.gosi, _current.gosi, AppColors.error),
                  _LineItem(l10n.absenceDeduction, _current.absenceDeduction, AppColors.error),
                ],
              ),
            ),
          ),

          // ── Salary History Chart ─────────────
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: _buildChartSection(l10n, isDark),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildNetSalaryHero(AppLocalizations l10n, double change, bool isDark) {
    final isUp = change >= 0;
    final changeColor = isUp ? AppColors.success : AppColors.error;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.netSalary.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_current.month} 2026',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatCurrency(_current.netSalary),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isUp ? Colors.greenAccent : Colors.redAccent).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: (isUp ? Colors.greenAccent : Colors.redAccent).withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      color: isUp ? Colors.greenAccent : Colors.redAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${change.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: isUp ? Colors.greenAccent : Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(AppLocalizations l10n, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.salaryTrend,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: RepaintBoundary(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1000,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: isDark ? Colors.white10 : Colors.black12,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < _salaryHistory.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _salaryHistory[index].month,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? Colors.white54 : AppColors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _salaryHistory.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.netSalary);
                        }).toList(),
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 6,
                            color: AppColors.primary,
                            strokeWidth: 3,
                            strokeColor: Colors.white,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.3),
                              AppColors.primary.withOpacity(0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isDeduction;

  const _HeroPill({
    required this.label,
    required this.value,
    required this.color,
    this.isDeduction = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'SAR ${value.toInt()}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isDeduction ? AppColors.error : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineItem {
  final String label;
  final double value;
  final Color color;
  const _LineItem(this.label, this.value, this.color);
}

class _CollapsibleSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool isExpanded;
  final double total;
  final Color totalColor;
  final VoidCallback onToggle;
  final List<_LineItem> items;

  const _CollapsibleSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.isExpanded,
    required this.total,
    required this.totalColor,
    required this.onToggle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: iconColor, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'SAR ${total.toInt()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: totalColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 12),
                    ...items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                'SAR ${item.value.toInt()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}
