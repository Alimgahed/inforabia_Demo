import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});
  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _invoices = [
    {
      'id': 'INV-3321',
      'vendor': 'Oracle Corporation',
      'amount': 'SAR 45,000',
      'date': '15 Apr 2024',
      'status': 'Approved',
      'type': 'Software License',
      'color': AppColors.success,
    },
    {
      'id': 'INV-3320',
      'vendor': 'Accenture Middle East',
      'amount': 'SAR 128,500',
      'date': '14 Apr 2024',
      'status': 'Pending',
      'type': 'Consulting',
      'color': AppColors.secondary,
    },
    {
      'id': 'INV-3315',
      'vendor': 'STC Business',
      'amount': 'SAR 18,750',
      'date': '12 Apr 2024',
      'status': 'Paid',
      'type': 'Telecom',
      'color': AppColors.accent,
    },
    {
      'id': 'INV-3312',
      'vendor': 'HP Enterprise',
      'amount': 'SAR 32,000',
      'date': '10 Apr 2024',
      'status': 'Approved',
      'type': 'Hardware',
      'color': AppColors.success,
    },
    {
      'id': 'INV-3308',
      'vendor': 'AWS Saudi Arabia',
      'amount': 'SAR 56,200',
      'date': '08 Apr 2024',
      'status': 'Rejected',
      'type': 'Cloud Services',
      'color': AppColors.error,
    },
    {
      'id': 'INV-3301',
      'vendor': 'Regus Office Co.',
      'amount': 'SAR 22,000',
      'date': '05 Apr 2024',
      'status': 'Paid',
      'type': 'Facility Rent',
      'color': AppColors.accent,
    },
  ];

  final _entries = [
    {
      'id': 'JE-2024-0432',
      'desc': 'Payroll Processing — March 2024',
      'debit': 'SAR 1,240,000',
      'credit': 'SAR 1,240,000',
      'date': '31 Mar 2024',
      'posted': true,
      'category': 'Payroll',
    },
    {
      'id': 'JE-2024-0428',
      'desc': 'Accrued Leave Provision Q1 2024',
      'debit': 'SAR 185,000',
      'credit': 'SAR 185,000',
      'date': '31 Mar 2024',
      'posted': true,
      'category': 'Accrual',
    },
    {
      'id': 'JE-2024-0425',
      'desc': 'Asset Depreciation — IT Equipment',
      'debit': 'SAR 45,000',
      'credit': 'SAR 45,000',
      'date': '28 Mar 2024',
      'posted': true,
      'category': 'Depreciation',
    },
    {
      'id': 'JE-2024-0420',
      'desc': 'Revenue Recognition — Project Alpha',
      'debit': 'SAR 320,000',
      'credit': 'SAR 320,000',
      'date': '25 Mar 2024',
      'posted': false,
      'category': 'Revenue',
    },
    {
      'id': 'JE-2024-0418',
      'desc': 'Vendor Payment — Cloud Infrastructure',
      'debit': 'SAR 56,200',
      'credit': 'SAR 56,200',
      'date': '22 Mar 2024',
      'posted': true,
      'category': 'Payables',
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
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            fontSize: 16,
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
    final l10n = AppLocalizations.of(context)!;
    final paid = _invoices.where((i) => i['status'] == 'Paid').length;
    final pending = _invoices.where((i) => i['status'] == 'Pending').length;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF0F4FA),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.darkTeal,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.darkTeal, AppColors.primary],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Opacity(
                        opacity: 0.07,
                        child: const Icon(
                          Icons.account_balance_rounded,
                          size: 200,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 40,
                        bottom: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            l10n.financialNotifications,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Invoice management & journal entries',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _headerStat(
                                'Invoices',
                                '${_invoices.length}',
                                Colors.white,
                              ),
                              const SizedBox(width: 10),
                              _headerStat('Paid', '$paid', AppColors.accent),
                              const SizedBox(width: 10),
                              _headerStat(
                                'Pending',
                                '$pending',
                                AppColors.secondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
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
                  indicatorColor: AppColors.secondary,
                  indicatorWeight: 3,
                  labelColor: AppColors.secondary,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  tabs: [
                    Tab(text: l10n.invoices),
                    Tab(text: l10n.consolidatedEntries),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_buildInvoicesTab(isDark), _buildEntriesTab(isDark)],
        ),
      ),
    );
  }

  Widget _buildInvoicesTab(bool isDark) => ListView.builder(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
    itemCount: _invoices.length,
    itemBuilder: (_, i) {
      final inv = _invoices[i];
      final color = inv['color'] as Color;
      return FadeInUp(
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
                              Icons.receipt_long_rounded,
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
                                  inv['vendor'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                _pill(inv['type'] as String, isDark),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                inv['amount'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: color.withOpacity(0.25),
                                  ),
                                ),
                                child: Text(
                                  inv['status'] as String,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.tag_rounded,
                            size: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            inv['id'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.grey,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 11,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            inv['date'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.grey,
                            ),
                          ),
                        ],
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

  Widget _buildEntriesTab(bool isDark) => ListView.builder(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
    itemCount: _entries.length,
    itemBuilder: (_, i) {
      final e = _entries[i];
      final isPosted = e['posted'] as bool;
      final stColor = isPosted ? AppColors.success : AppColors.secondary;
      return FadeInLeft(
        delay: Duration(milliseconds: i * 70),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.12 : 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              children: [
                Container(height: 3, color: stColor),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.book_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e['id'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  e['date'] as String,
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
                              color: stColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: stColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              isPosted ? 'Posted' : 'Draft',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: stColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        e['desc'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _pill(e['category'] as String, isDark),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkBackground
                              : const Color(0xFFF6F8FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_outward_rounded,
                              size: 14,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Dr: ${e['debit']}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_downward_rounded,
                              size: 14,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Cr: ${e['credit']}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ],
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
