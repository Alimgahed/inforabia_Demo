import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen>
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
          l10n.payrollAndFinance,
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
          isScrollable: true,
          tabs: [
            Tab(text: l10n.payslip),
            Tab(text: l10n.salaryHistory),
            Tab(text: l10n.invoices),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPayslipsTab(l10n, isDark),
          _buildSalaryHistoryTab(l10n, isDark),
          _buildInvoicesTab(l10n, isDark),
        ],
      ),
    );
  }

  Widget _buildPayslipsTab(AppLocalizations l10n, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(child: _buildLatestPayslipCard(l10n, isDark)),
          const SizedBox(height: 24),
          Text(
            l10n.previousPayslips,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, i) {
              final months = [
                'April',
                'March',
                'February',
                'January',
                'December',
                'November',
                'October',
                'September',
              ];
              final years = [2024, 2024, 2024, 2024, 2023, 2023, 2023, 2023];
              return FadeInUp(
                delay: Duration(milliseconds: i * 50),
                child: _payslipListItem(months[i], years[i], isDark),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLatestPayslipCard(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.appGradient,
        borderRadius: BorderRadius.circular(24),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.latestPayslip,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    'April 2024',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.download_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Net Salary',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    '14,250 SAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white30,
                size: 48,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _payslipMiniDetail(l10n.earnings, '16,500'),
              const VerticalDivider(color: Colors.white24),
              _payslipMiniDetail(l10n.deductions, '2,250'),
              const VerticalDivider(color: Colors.white24),
              _payslipMiniDetail('Tax/Ins', '1,100'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _payslipMiniDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _payslipListItem(String month, int year, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$month $year',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.grey),
        ],
      ),
    );
  }

  Widget _buildSalaryHistoryTab(AppLocalizations l10n, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FadeInDown(
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 10000),
                        FlSpot(1, 10000),
                        FlSpot(2, 10500),
                        FlSpot(3, 11000),
                        FlSpot(4, 11000),
                        FlSpot(5, 12000),
                        FlSpot(6, 12000),
                        FlSpot(7, 13000),
                        FlSpot(8, 14250),
                      ],
                      isCurved: true,
                      color: AppColors.secondary,
                      barWidth: 4,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.secondary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _salaryChangeItem(
                  '${l10n.promotion}: Senior Developer',
                  'Apr 2024',
                  '+2,250 SAR',
                  isDark,
                ),
                _salaryChangeItem(
                  l10n.annualIncrement,
                  'Jan 2023',
                  '+2,000 SAR',
                  isDark,
                ),
                _salaryChangeItem(
                  'Job Start',
                  'Jun 2022',
                  '10,000 SAR',
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _salaryChangeItem(
    String title,
    String date,
    String change,
    bool isDark,
  ) {
    return FadeInUp(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Text(
          change,
          style: const TextStyle(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildInvoicesTab(AppLocalizations l10n, bool isDark) {
    final invoices = [
      {
        'title': 'Travel Reimbursement',
        'date': '14 Apr',
        'amount': '450 SAR',
        'status': 'Pending',
      },
      {
        'title': 'Office Supplies',
        'date': '10 Apr',
        'amount': '120 SAR',
        'status': 'Approved',
      },
      {
        'title': 'Client Lunch',
        'date': '02 Apr',
        'amount': '320 SAR',
        'status': 'Approved',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: invoices.length,
      itemBuilder: (context, i) {
        final inv = invoices[i];
        final isPending = inv['status'] == 'Pending';
        return FadeInRight(
          delay: Duration(milliseconds: i * 100),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: isDark ? AppColors.darkCard : Colors.white,
            child: ListTile(
              leading: Icon(
                Icons.description_outlined,
                color: isPending ? AppColors.warning : AppColors.success,
              ),
              title: Text(
                inv['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(inv['date']!),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    inv['amount']!,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    inv['status'] == 'Pending' ? l10n.pending : l10n.approved,
                    style: TextStyle(
                      color: isPending ? AppColors.warning : AppColors.success,
                      fontSize: 10,
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
}
