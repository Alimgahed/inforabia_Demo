import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';

/// A detailed, data-rich screen for HR self-service modules that don't have
/// their own dedicated screen. Shows relevant demo data based on the service type.
class ServiceDetailScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const ServiceDetailScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = _getDataForService(title);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF4F6FC),
      body: CustomScrollView(
        slivers: [
          // ── Premium Gradient AppBar ──
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(icon, size: 200, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 20,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data['records'].length} Records',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                data['subtitle'] as String,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 11,
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
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),

          // ── Summary Stats ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FadeInUp(
                child: Row(
                  children: (data['stats'] as List<Map<String, dynamic>>)
                      .map(
                        (s) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  s['value'] as String,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: s['color'] as Color,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  s['label'] as String,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          // ── Records List ──
          SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              final record = (data['records'] as List<Map<String, dynamic>>)[i];
              return FadeInUp(
                delay: Duration(milliseconds: i * 60),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border(
                      left: BorderSide(
                        color: record['color'] as Color,
                        width: 3,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.12 : 0.03),
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
                          color: (record['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          record['icon'] as IconData,
                          color: record['color'] as Color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            if (record['subtitle'] != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                record['subtitle'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (record['trailing'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: (record['color'] as Color).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            record['trailing'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: record['color'] as Color,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }, childCount: (data['records'] as List).length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Map<String, dynamic> _getDataForService(String serviceTitle) {
    // Return data based on certain keywords to cover all untapped services
    if (serviceTitle.contains('Data Update') ||
        serviceTitle.contains('تحديث')) {
      return {
        'subtitle': 'Personal data change requests',
        'stats': [
          {'label': 'Total', 'value': '12', 'color': AppColors.primary},
          {'label': 'Approved', 'value': '10', 'color': AppColors.success},
          {'label': 'Pending', 'value': '2', 'color': AppColors.warning},
        ],
        'records': [
          {
            'title': 'Marital Status Update',
            'subtitle': 'Changed to Married • 01 Mar 2024',
            'icon': Icons.favorite_rounded,
            'color': AppColors.success,
            'trailing': 'Approved',
          },
          {
            'title': 'Emergency Contact Change',
            'subtitle': 'Updated contact: Omar Rashid • 15 Feb 2024',
            'icon': Icons.contact_phone_rounded,
            'color': AppColors.success,
            'trailing': 'Approved',
          },
          {
            'title': 'Nationality Document Update',
            'subtitle': 'New passport uploaded • 10 Apr 2024',
            'icon': Icons.badge_rounded,
            'color': AppColors.warning,
            'trailing': 'Pending',
          },
          {
            'title': 'Bank Account Change',
            'subtitle': 'Al-Rajhi to SNB transfer • 05 Apr 2024',
            'icon': Icons.account_balance_rounded,
            'color': AppColors.warning,
            'trailing': 'Pending',
          },
          {
            'title': 'Blood Type Record',
            'subtitle': 'Updated to O+ • 20 Jan 2024',
            'icon': Icons.bloodtype_rounded,
            'color': AppColors.success,
            'trailing': 'Approved',
          },
        ],
      };
    }
    if (serviceTitle.contains('Phone') || serviceTitle.contains('هواتف')) {
      return {
        'subtitle': 'Registered phone numbers',
        'stats': [
          {'label': 'Primary', 'value': '1', 'color': AppColors.primary},
          {'label': 'Secondary', 'value': '1', 'color': AppColors.accent},
          {'label': 'Emergency', 'value': '2', 'color': AppColors.error},
        ],
        'records': [
          {
            'title': '+966 55 123 4567',
            'subtitle': 'Primary Mobile • Verified ✓',
            'icon': Icons.phone_android_rounded,
            'color': AppColors.primary,
            'trailing': 'Active',
          },
          {
            'title': '+966 11 456 7890',
            'subtitle': 'Office Landline • Ext. 204',
            'icon': Icons.phone_rounded,
            'color': AppColors.accent,
            'trailing': 'Active',
          },
          {
            'title': '+966 55 987 6543',
            'subtitle': 'Emergency: Sara Al-Rashid (Wife)',
            'icon': Icons.emergency_rounded,
            'color': AppColors.error,
            'trailing': 'Emergency',
          },
          {
            'title': '+966 50 111 2233',
            'subtitle': 'Emergency: Mohammed Rashid (Father)',
            'icon': Icons.emergency_rounded,
            'color': AppColors.error,
            'trailing': 'Emergency',
          },
        ],
      };
    }
    if (serviceTitle.contains('Address') || serviceTitle.contains('عنوان')) {
      return {
        'subtitle': 'Registered addresses',
        'stats': [
          {'label': 'Home', 'value': '1', 'color': AppColors.primary},
          {'label': 'Work', 'value': '1', 'color': AppColors.accent},
          {'label': 'Mailing', 'value': '1', 'color': AppColors.info},
        ],
        'records': [
          {
            'title': 'King Fahad Road, Al-Olaya District',
            'subtitle': 'Home Address • Riyadh 12271, Saudi Arabia',
            'icon': Icons.home_rounded,
            'color': AppColors.primary,
            'trailing': 'Primary',
          },
          {
            'title': 'Prince Sultan St, Al-Sulaimaniyah',
            'subtitle': 'Office Address • P.O. Box 84210, Riyadh',
            'icon': Icons.business_rounded,
            'color': AppColors.accent,
            'trailing': 'Work',
          },
          {
            'title': 'National Address: RACA1234',
            'subtitle': 'Registered via Absher • Verified ✓',
            'icon': Icons.location_on_rounded,
            'color': AppColors.info,
            'trailing': 'National',
          },
        ],
      };
    }
    if (serviceTitle.contains('Qualif') || serviceTitle.contains('مؤهل')) {
      return {
        'subtitle': 'Educational background',
        'stats': [
          {'label': 'Degrees', 'value': '2', 'color': AppColors.primary},
          {'label': 'Certs', 'value': '4', 'color': AppColors.primary},
          {'label': 'Languages', 'value': '3', 'color': AppColors.accent},
        ],
        'records': [
          {
            'title': 'M.Sc. Computer Science',
            'subtitle': 'King Saud University • 2020 • GPA 3.85',
            'icon': Icons.school_rounded,
            'color': AppColors.primary,
            'trailing': 'Masters',
          },
          {
            'title': 'B.Sc. Software Engineering',
            'subtitle': 'KFUPM • 2018 • First Honor',
            'icon': Icons.school_rounded,
            'color': AppColors.accent,
            'trailing': 'Bachelors',
          },
          {
            'title': 'PMP – Project Management Professional',
            'subtitle': 'PMI Institute • Valid until Dec 2025',
            'icon': Icons.workspace_premium_rounded,
            'color': AppColors.primary,
            'trailing': 'Active',
          },
          {
            'title': 'AWS Solutions Architect',
            'subtitle': 'Amazon Web Services • Issued Jan 2024',
            'icon': Icons.cloud_rounded,
            'color': AppColors.chartOrange,
            'trailing': 'Active',
          },
          {
            'title': 'ITIL v4 Foundation',
            'subtitle': 'Axelos • Issued Sep 2023',
            'icon': Icons.settings_suggest_rounded,
            'color': AppColors.chartTeal,
            'trailing': 'Active',
          },
        ],
      };
    }
    if (serviceTitle.contains('Family') ||
        serviceTitle.contains('أسرة') ||
        serviceTitle.contains('معرف')) {
      return {
        'subtitle': 'Dependents & emergency references',
        'stats': [
          {'label': 'Dependents', 'value': '4', 'color': AppColors.primary},
          {'label': 'References', 'value': '2', 'color': AppColors.info},
          {'label': 'Insured', 'value': '5', 'color': AppColors.success},
        ],
        'records': [
          {
            'title': 'Sara Al-Rashid',
            'subtitle': 'Spouse • DOB: 15 Jun 1992 • Insured ✓',
            'icon': Icons.favorite_rounded,
            'color': AppColors.error,
            'trailing': 'Wife',
          },
          {
            'title': 'Omar Ahmed Al-Rashid',
            'subtitle': 'Son • DOB: 20 Mar 2020 • Insured ✓',
            'icon': Icons.child_care_rounded,
            'color': AppColors.primary,
            'trailing': 'Son',
          },
          {
            'title': 'Layla Ahmed Al-Rashid',
            'subtitle': 'Daughter • DOB: 10 Nov 2022 • Insured ✓',
            'icon': Icons.child_care_rounded,
            'color': AppColors.chartPurple,
            'trailing': 'Daughter',
          },
          {
            'title': 'Mohammed Al-Rashid',
            'subtitle': 'Father • DOB: 01 Jan 1960 • Emergency Contact',
            'icon': Icons.person_rounded,
            'color': AppColors.info,
            'trailing': 'Father',
          },
          {
            'title': 'Dr. Fahad Al-Qahtani',
            'subtitle': 'Professional Reference • CTO, TechCorp Ltd',
            'icon': Icons.contact_mail_rounded,
            'color': AppColors.accent,
            'trailing': 'Reference',
          },
          {
            'title': 'Prof. Ahmed Saleh',
            'subtitle': 'Academic Reference • KSU Faculty',
            'icon': Icons.contact_mail_rounded,
            'color': AppColors.info,
            'trailing': 'Reference',
          },
        ],
      };
    }
    if (serviceTitle.contains('Absence') ||
        serviceTitle.contains('ترصيد') ||
        serviceTitle.contains('غياب')) {
      return {
        'subtitle': 'Leave allocation & accrual plans',
        'stats': [
          {'label': 'Annual', 'value': '18/30', 'color': AppColors.primary},
          {'label': 'Sick', 'value': '12/15', 'color': AppColors.warning},
          {'label': 'Personal', 'value': '3/5', 'color': AppColors.accent},
        ],
        'records': [
          {
            'title': 'Annual Leave Accrual',
            'subtitle': 'Earned: 30 days/year • Remaining: 18',
            'icon': Icons.event_available_rounded,
            'color': AppColors.primary,
            'trailing': '60%',
          },
          {
            'title': 'Sick Leave Balance',
            'subtitle': 'Earned: 15 days/year • Used: 3',
            'icon': Icons.local_hospital_rounded,
            'color': AppColors.warning,
            'trailing': '80%',
          },
          {
            'title': 'Emergency Leave',
            'subtitle': 'Earned: 5 days/year • Used: 1',
            'icon': Icons.emergency_rounded,
            'color': AppColors.error,
            'trailing': '80%',
          },
          {
            'title': 'Carry Forward from 2023',
            'subtitle': 'Transferred: 5 days • Expires: 31 Mar 2024',
            'icon': Icons.history_rounded,
            'color': AppColors.success,
            'trailing': 'Expired',
          },
          {
            'title': 'Remote Work Days',
            'subtitle': 'Used: 8 of 12 days/quarter',
            'icon': Icons.laptop_rounded,
            'color': AppColors.info,
            'trailing': '67%',
          },
        ],
      };
    }
    if (serviceTitle.contains('Salary') || serviceTitle.contains('راتب')) {
      return {
        'subtitle': 'Historical salary adjustments',
        'stats': [
          {'label': 'Current', 'value': '14.9K', 'color': AppColors.primary},
          {'label': 'Increases', 'value': '5', 'color': AppColors.success},
          {'label': 'YoY Growth', 'value': '+8%', 'color': AppColors.accent},
        ],
        'records': [
          {
            'title': 'Annual Increment 2024',
            'subtitle': 'SAR 12,500 → SAR 14,962 • 5% Merit + Cost of Living',
            'icon': Icons.trending_up_rounded,
            'color': AppColors.success,
            'trailing': '+SAR 2,462',
          },
          {
            'title': 'Promotion Adjustment 2023',
            'subtitle': 'SAR 11,000 → SAR 12,500 • Senior Consultant',
            'icon': Icons.military_tech_rounded,
            'color': AppColors.accent,
            'trailing': '+SAR 1,500',
          },
          {
            'title': 'Annual Increment 2022',
            'subtitle': 'SAR 10,500 → SAR 11,000 • Standard 5%',
            'icon': Icons.trending_up_rounded,
            'color': AppColors.success,
            'trailing': '+SAR 500',
          },
          {
            'title': 'Joining Salary 2021',
            'subtitle': 'Starting package: SAR 10,500/month',
            'icon': Icons.work_rounded,
            'color': AppColors.primary,
            'trailing': 'Base',
          },
        ],
      };
    }
    if (serviceTitle.contains('Self') || serviceTitle.contains('ذاتية')) {
      return {
        'subtitle': 'Self-service requests by status',
        'stats': [
          {'label': 'Total', 'value': '24', 'color': AppColors.primary},
          {'label': 'Approved', 'value': '19', 'color': AppColors.success},
          {'label': 'Pending', 'value': '5', 'color': AppColors.warning},
        ],
        'records': [
          {
            'title': 'Leave Requests',
            'subtitle': 'Approved: 8 • Pending: 1 • Rejected: 0',
            'icon': Icons.event_available_rounded,
            'color': AppColors.success,
            'trailing': '9 total',
          },
          {
            'title': 'Certificate Requests',
            'subtitle': 'Approved: 3 • Pending: 0 • Rejected: 1',
            'icon': Icons.description_rounded,
            'color': AppColors.info,
            'trailing': '4 total',
          },
          {
            'title': 'Data Update Requests',
            'subtitle': 'Approved: 5 • Pending: 2 • Rejected: 0',
            'icon': Icons.edit_note_rounded,
            'color': AppColors.warning,
            'trailing': '7 total',
          },
          {
            'title': 'Travel Requests',
            'subtitle': 'Approved: 2 • Pending: 1 • Rejected: 0',
            'icon': Icons.flight_takeoff_rounded,
            'color': AppColors.primary,
            'trailing': '3 total',
          },
          {
            'title': 'Asset Requests',
            'subtitle': 'Approved: 1 • Pending: 1 • Rejected: 0',
            'icon': Icons.devices_rounded,
            'color': AppColors.accent,
            'trailing': '2 total',
          },
        ],
      };
    }
    if (serviceTitle.contains('Employment') || serviceTitle.contains('توظيف')) {
      return {
        'subtitle': 'Employment lifecycle details',
        'stats': [
          {'label': 'Tenure', 'value': '3.2Y', 'color': AppColors.primary},
          {'label': 'Grade', 'value': '12', 'color': AppColors.accent},
          {'label': 'Band', 'value': 'C', 'color': AppColors.accent},
        ],
        'records': [
          {
            'title': 'Job Title: Senior Consultant',
            'subtitle': 'Department: Solutions & Consultancy',
            'icon': Icons.work_rounded,
            'color': AppColors.primary,
            'trailing': 'Current',
          },
          {
            'title': 'Joining Date: 15 Jan 2021',
            'subtitle': 'Probation completed: 15 Jul 2021',
            'icon': Icons.date_range_rounded,
            'color': AppColors.success,
            'trailing': '3.2 Years',
          },
          {
            'title': 'Manager: Sarah Richardson',
            'subtitle': 'Director, Solutions Division',
            'icon': Icons.supervisor_account_rounded,
            'color': AppColors.accent,
            'trailing': 'Active',
          },
          {
            'title': 'Contract Type: Full-Time',
            'subtitle': 'Indefinite • Saudi Labor Law',
            'icon': Icons.assignment_rounded,
            'color': AppColors.info,
            'trailing': 'Permanent',
          },
          {
            'title': 'Work Location: Riyadh HQ',
            'subtitle': 'Hybrid: 3 Office + 2 Remote days',
            'icon': Icons.location_on_rounded,
            'color': AppColors.chartOrange,
            'trailing': 'Hybrid',
          },
        ],
      };
    }
    // Default fallback for team-related or other services
    return {
      'subtitle': 'Service records & details',
      'stats': [
        {'label': 'Active', 'value': '6', 'color': AppColors.primary},
        {'label': 'Completed', 'value': '14', 'color': AppColors.success},
        {'label': 'Total', 'value': '20', 'color': AppColors.accent},
      ],
      'records': [
        {
          'title': 'Team Attendance: 96.2%',
          'subtitle': 'April average • 142 employees tracked',
          'icon': Icons.groups_rounded,
          'color': AppColors.success,
          'trailing': '96.2%',
        },
        {
          'title': 'Active Employees',
          'subtitle': '128 On-site • 14 Remote',
          'icon': Icons.person_rounded,
          'color': AppColors.primary,
          'trailing': '142',
        },
        {
          'title': 'On Leave Today',
          'subtitle': '8 Annual • 2 Sick • 1 Emergency',
          'icon': Icons.event_busy_rounded,
          'color': AppColors.warning,
          'trailing': '11',
        },
        {
          'title': 'New Hires - April',
          'subtitle': '4 Engineering • 2 Sales • 1 Marketing',
          'icon': Icons.person_add_rounded,
          'color': AppColors.info,
          'trailing': '7',
        },
        {
          'title': 'Pending Actions',
          'subtitle': '3 Leave Approvals • 2 PR Reviews',
          'icon': Icons.pending_actions_rounded,
          'color': AppColors.error,
          'trailing': '5',
        },
      ],
    };
  }
}
