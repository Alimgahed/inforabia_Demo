import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:inforabia/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class PayslipScreen extends StatelessWidget {
  const PayslipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.accent : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.payslip),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net Salary Card
            FadeInDown(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.netSalary,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'SAR 18,450',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'April 2026',
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Salary Breakdown
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: _buildSection(
                l10n.totalEarnings,
                [
                  _PayItem(l10n.basicSalary, 'SAR 12,000', AppColors.success),
                  _PayItem(
                    l10n.housingAllowance,
                    'SAR 5,000',
                    AppColors.success,
                  ),
                  _PayItem(
                    l10n.transportAllowance,
                    'SAR 2,000',
                    AppColors.success,
                  ),
                  _PayItem(
                    l10n.otherAllowances,
                    'SAR 1,500',
                    AppColors.success,
                  ),
                ],
                'SAR 20,500',
                AppColors.success,
                isDark,
              ),
            ),

            const SizedBox(height: 16),

            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: _buildSection(
                l10n.deductions,
                [
                  _PayItem(l10n.socialInsurance, 'SAR 1,200', AppColors.error),
                  _PayItem(l10n.tax, 'SAR 850', AppColors.error),
                ],
                'SAR 2,050',
                AppColors.error,
                isDark,
              ),
            ),

            const SizedBox(height: 24),

            // Salary History Chart
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.salaryHistory,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = [
                                    'Nov',
                                    'Dec',
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < months.length) {
                                    return Text(
                                      months[value.toInt()],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.grey,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 17.8),
                                FlSpot(1, 18.1),
                                FlSpot(2, 18.0),
                                FlSpot(3, 18.2),
                                FlSpot(4, 18.3),
                                FlSpot(5, 18.45),
                              ],
                              isCurved: true,
                              color: primaryColor,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter:
                                    (spot, percent, barData, index) =>
                                        FlDotCirclePainter(
                                          radius: 4,
                                          color: primaryColor,
                                          strokeWidth: 2,
                                          strokeColor: Colors.white,
                                        ),
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: primaryColor.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<_PayItem> items,
    String total,
    Color totalColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.grey,
                    ),
                  ),
                  Text(
                    item.value,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: item.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  total,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: totalColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PayItem {
  final String label;
  final String value;
  final Color color;
  const _PayItem(this.label, this.value, this.color);
}
