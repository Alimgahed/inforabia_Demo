import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:inforabia/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.accent : AppColors.primary;

    final balances = [
      {
        'type': l10n.annualLeave,
        'used': 12,
        'total': 30,
        'color': AppColors.primary,
      },
      {
        'type': l10n.sickLeave,
        'used': 3,
        'total': 15,
        'color': AppColors.warning,
      },
      {
        'type': l10n.emergencyLeave,
        'used': 1,
        'total': 5,
        'color': AppColors.error,
      },
      {
        'type': l10n.unpaidLeave,
        'used': 0,
        'total': 10,
        'color': AppColors.grey,
      },
    ];

    final history = [
      {
        'type': l10n.annualLeave,
        'from': '2026-03-15',
        'to': '2026-03-20',
        'status': 'approved',
        'days': 5,
      },
      {
        'type': l10n.sickLeave,
        'from': '2026-02-10',
        'to': '2026-02-12',
        'status': 'approved',
        'days': 3,
      },
      {
        'type': l10n.annualLeave,
        'from': '2026-01-20',
        'to': '2026-01-26',
        'status': 'approved',
        'days': 7,
      },
      {
        'type': l10n.emergencyLeave,
        'from': '2026-04-01',
        'to': '2026-04-01',
        'status': 'pending',
        'days': 1,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.leaveManagement),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLeaveRequestSheet(context, l10n, isDark),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          l10n.requestLeave,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Balances
            FadeInDown(
              child: Text(
                l10n.leaveBalance,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: balances.length,
                itemBuilder: (context, i) {
                  final b = balances[i];
                  final used = b['used'] as int;
                  final total = b['total'] as int;
                  final remaining = total - used;
                  final percent = used / total;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 36,
                          lineWidth: 6,
                          percent: percent.clamp(0.0, 1.0),
                          center: Text(
                            '$remaining',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: b['color'] as Color,
                            ),
                          ),
                          progressColor: b['color'] as Color,
                          backgroundColor: (b['color'] as Color).withOpacity(
                            0.15,
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          b['type'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.black,
                          ),
                        ),
                        Text(
                          '${l10n.used}: $used / $total',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // Leave History
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Text(
                l10n.leaveHistory,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(
              history.length,
              (i) => FadeInUp(
                delay: Duration(milliseconds: 500 + i * 100),
                child: _historyItem(history[i], l10n, isDark),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _historyItem(
    Map<String, dynamic> item,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final status = item['status'] as String;
    Color statusColor;
    String statusText;

    switch (status) {
      case 'approved':
        statusColor = AppColors.success;
        statusText = l10n.approved;
        break;
      case 'pending':
        statusColor = AppColors.warning;
        statusText = l10n.pending;
        break;
      default:
        statusColor = AppColors.error;
        statusText = l10n.rejected;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['type'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['from']} → ${item['to']}  (${item['days']} ${item['days'] == 1 ? 'day' : 'days'})',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLeaveRequestSheet(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.requestLeave,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: l10n.type,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                l10n.annualLeave,
                l10n.sickLeave,
                l10n.emergencyLeave,
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: l10n.reason,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.submit,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
