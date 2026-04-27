import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inforabia/core/theme/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _chartController;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _chartAnimation = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeInOutCubic,
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _chartController.forward();
    });
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  // ─── salary data ────────────────────────────────────────────────────────────
  static const _segments = [
    _SalarySegment('Basic', 12500, AppColors.primary),
    _SalarySegment('Housing', 3125, AppColors.secondary),
    _SalarySegment('Transport', 1000, AppColors.accent),
    _SalarySegment('Deductions', 1662.5, Color(0xFFE24B4A)),
  ];

  // ─── personal info ──────────────────────────────────────────────────────────
  static final _personalItems = [
    _InfoItem(Icons.fingerprint_outlined, 'National ID', '1084XXXX92'),
    _InfoItem(Icons.bloodtype_outlined, 'Blood type', 'O+'),
    _InfoItem(Icons.wc_outlined, 'Gender', 'Male'),
    _InfoItem(Icons.public_outlined, 'Nationality', 'Saudi Arabian'),
    _InfoItem(Icons.favorite_outline, 'Marital status', 'Married'),
    _InfoItem(Icons.cake_outlined, 'Date of birth', '12 May 1992'),
  ];

  static final _employmentItems = [
    _InfoItem(Icons.work_outline, 'Job title', 'Senior Consultant'),
    _InfoItem(Icons.business_outlined, 'Department', 'Solutions'),
    _InfoItem(Icons.calendar_month_outlined, 'Joining date', '01 Jan 2022'),
    _InfoItem(Icons.person_pin_outlined, 'Manager', 'Sarah R.'),
    _InfoItem(Icons.assignment_ind_outlined, 'Passport ID', 'L827XXXX5'),
    _InfoItem(Icons.verified_user_outlined, 'Visa', 'Resident'),
  ];

  static final _contactItems = [
    _InfoItem(Icons.phone_iphone_outlined, 'Phone', '+966 55 XXX 4567'),
    _InfoItem(Icons.alternate_email_outlined, 'Email', 'ahmed.r@company.com'),
    _InfoItem(Icons.home_outlined, 'Address', 'Al Malqa, Riyadh'),
    _InfoItem(Icons.emergency_outlined, 'Emergency', 'Ali Al-Rashid'),
  ];

  static final _educationItems = [
    _InfoItem(Icons.school_outlined, 'Master\'s', 'KFUPM — 2018'),
    _InfoItem(
      Icons.workspace_premium_outlined,
      'Bachelor\'s',
      'Riyadh Univ. — 2014',
    ),
  ];

  static final _familyItems = [
    _InfoItem(Icons.family_restroom_outlined, 'Spouse', 'Mona K.'),
    _InfoItem(Icons.child_care_outlined, 'Child (1)', 'Fahad A.'),
  ];

  // ─── build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFFF5F7FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: ProfileHeader(isDark: isDark)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Salary chart
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: _buildSalaryChartCard(isDark),
                ),
                const SizedBox(height: 12),

                // Payslip
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _buildPayslipCard(isDark),
                ),
                const SizedBox(height: 12),

                // Personal info
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: _buildSectionCard(
                    'Personal Information',
                    _personalItems,
                    isDark,
                    accentColor: AppColors.primary,
                    iconBg: AppColors.primary.withOpacity(0.08),
                  ),
                ),
                const SizedBox(height: 12),

                // Employment info
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: _buildSectionCard(
                    'Employment Details',
                    _employmentItems,
                    isDark,
                    accentColor: AppColors.primary,
                    iconBg: AppColors.primary.withOpacity(0.08),
                  ),
                ),
                const SizedBox(height: 12),

                // Contact
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: _buildSectionCard(
                    'Contact Details',
                    _contactItems,
                    isDark,
                    accentColor: AppColors.secondary,
                    iconBg: AppColors.secondary.withOpacity(0.10),
                    titleColor: const Color(0xFFBD7C31),
                  ),
                ),
                const SizedBox(height: 12),

                // Education
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: _buildSectionCard(
                    'Education',
                    _educationItems,
                    isDark,
                    accentColor: AppColors.primary,
                    iconBg: AppColors.primary.withOpacity(0.08),
                  ),
                ),
                const SizedBox(height: 12),

                // Family
                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: _buildSectionCard(
                    'Family & References',
                    _familyItems,
                    isDark,
                    accentColor: AppColors.secondary,
                    iconBg: AppColors.secondary.withOpacity(0.10),
                    titleColor: const Color(0xFFBD7C31),
                  ),
                ),
                const SizedBox(height: 16),

                // Update buttons row 1
                //     FadeInUp(
                //       delay: const Duration(milliseconds: 800),
                //       child: Row(
                //         children: [
                //           Expanded(
                //             child: _updateButton(
                //               'Basic Data',
                //               Icons.edit_note_rounded,
                //               isDark,
                //             ),
                //           ),
                //           const SizedBox(width: 12),
                //           Expanded(
                //             child: _updateButton(
                //               'Phone Data',
                //               Icons.phone_android_rounded,
                //               isDark,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     const SizedBox(height: 12),

                //     // Update buttons row 2
                //     FadeInUp(
                //       delay: const Duration(milliseconds: 900),
                //       child: Row(
                //         children: [
                //           Expanded(
                //             child: _updateButton(
                //               'Address Data',
                //               Icons.location_on_outlined,
                //               isDark,
                //             ),
                //           ),
                //           const SizedBox(width: 12),
                //           Expanded(
                //             child: _updateButton(
                //               'Documents',
                //               Icons.folder_open_outlined,
                //               isDark,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     const SizedBox(height: 20),

                //     // Settings button
                //     FadeInUp(
                //       delay: const Duration(milliseconds: 1000),
                //       child: _buildSettingsButton(),
                //     ),
                //     const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    const name = 'Ahmed Al-Rashid';
    const role = 'Senior Consultant';
    const department = 'Solutions';
    const empId = 'EMP-2024-0847';
    const location = 'Riyadh';
    const experience = '3 yrs';
    const joinDate = '2021';
    const isActive = true;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// 🔥 Decorative background
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ── Top Row (Avatar + Info)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Text(
                          'AR',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      /// status dot
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  /// Name + Role + chips
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$role • $department',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// chips row
                        Row(
                          children: [
                            _badge(icon: Icons.badge_outlined, label: empId),
                            const SizedBox(width: 6),
                            _badge(
                              icon: Icons.work_history_outlined,
                              label: experience,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// ── Bottom Info Box (same as ProfileHeader)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _infoItem(
                        Icons.location_on_outlined,
                        'Location',
                        location,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    Expanded(
                      child: _infoItem(
                        Icons.calendar_today_outlined,
                        'Joined',
                        joinDate,
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

  Widget _badge({required IconData icon, required String label, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white60, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── QR CODE BUTTON & OVERLAY ───────────────────────────────────────────────
  Widget _buildQrButton(bool isDark) {
    return GestureDetector(
      onTap: () => _showQrCodeSheet(context, isDark),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code_2_rounded,
              color: Colors.white.withOpacity(0.9),
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              'ID Card',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQrCodeSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Employee ID Card',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Scan to verify identity',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white60 : AppColors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // QR Code Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.white : const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white24
                      : Colors.black.withOpacity(0.05),
                ),
              ),
              child: Column(
                children: [
                  // Replace with your asset image
                  Image.asset(
                    'assets/images/qrcode.jpeg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.qr_code_2,
                        size: 120,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'EMP-2024-0847',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildQrActionButton(
                    'Share',
                    Icons.share_outlined,
                    AppColors.primary,
                    isDark,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQrActionButton(
                    'Download',
                    Icons.download_outlined,
                    AppColors.secondary,
                    isDark,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQrActionButton(
    String label,
    IconData icon,
    Color color,
    bool isDark, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 10),
          ),
        ],
      ),
    );
  }

  // ─── SALARY CHART ────────────────────────────────────────────────────────────
  Widget _buildSalaryChartCard(bool isDark) {
    final total = _segments.fold<double>(0, (s, e) => s + e.amount);

    return _Card(
      isDark: isDark,
      child: Column(
        children: [
          _CardHeader(
            title: 'Salary Distribution',
            accentColor: AppColors.primary,
            isDark: isDark,
            trailing: const _Badge('April 2025'),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _chartAnimation,
            builder: (_, _) {
              final p = _chartAnimation.value;
              return Row(
                children: [
                  // Donut
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            startDegreeOffset: -90,
                            sectionsSpace: 3,
                            centerSpaceRadius: 44,
                            sections: _segments
                                .map(
                                  (seg) => PieChartSectionData(
                                    value: (seg.amount / total) * p,
                                    color: seg.color,
                                    radius: 26,
                                    showTitle: false,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'NET',
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white38 : AppColors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'SAR',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.primary,
                              ),
                            ),
                            Text(
                              '14,962',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Legend
                  Expanded(
                    child: Column(
                      children: _segments.map((seg) {
                        final pct = (seg.amount / total * 100).toStringAsFixed(
                          1,
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: seg.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  seg.label,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              Text(
                                '$pct%',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: seg.color,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── PAYSLIP ─────────────────────────────────────────────────────────────────
  Widget _buildPayslipCard(bool isDark) {
    return _Card(
      isDark: isDark,
      accentBorder: AppColors.secondary.withOpacity(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: 'Monthly Payslip',
            accentColor: AppColors.secondary,
            isDark: isDark,
            titleColor: const Color(0xFFBD7C31),
          ),
          const SizedBox(height: 8),
          _salaryRow(
            'Basic Salary',
            'SAR 12,500.00',
            isDark,
            valueColor: AppColors.success,
          ),
          _salaryRow(
            'Housing Allowance',
            'SAR 3,125.00',
            isDark,
            valueColor: AppColors.success,
          ),
          _salaryRow(
            'Transport Allowance',
            'SAR 1,000.00',
            isDark,
            valueColor: AppColors.success,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, thickness: 0.5),
          ),
          _salaryRow(
            'Total Earnings',
            'SAR 17,125.00',
            isDark,
            labelColor: AppColors.primary,
            valueColor: AppColors.primary,
            bold: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, thickness: 0.5),
          ),
          _salaryRow(
            'Deductions',
            '- SAR 1,662.50',
            isDark,
            valueColor: AppColors.error,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Net Salary',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  'SAR 14,962.50',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _salaryRow(
    String label,
    String value,
    bool isDark, {
    Color? labelColor,
    Color? valueColor,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
              color: labelColor ?? (isDark ? Colors.white60 : AppColors.grey),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? (isDark ? Colors.white : AppColors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ─── SECTION CARD ────────────────────────────────────────────────────────────
  Widget _buildSectionCard(
    String title,
    List<_InfoItem> items,
    bool isDark, {
    required Color accentColor,
    required Color iconBg,
    Color? titleColor,
  }) {
    return _Card(
      isDark: isDark,
      accentBorder: accentColor.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: title,
            accentColor: accentColor,
            isDark: isDark,
            titleColor: titleColor,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3.0,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.03)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, size: 16, color: accentColor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── UPDATE BUTTON ───────────────────────────────────────────────────────────
  Widget _updateButton(String label, IconData icon, bool isDark) {
    return Material(
      color: isDark ? AppColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.darkTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SETTINGS BUTTON ─────────────────────────────────────────────────────────
  Widget _buildSettingsButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
          },
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings_suggest_outlined,
                  color: Colors.white,
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SHARED WIDGETS ───────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final bool isDark;
  final Widget child;
  final Color? accentBorder;

  const _Card({required this.isDark, required this.child, this.accentBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentBorder ?? AppColors.primary.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(isDark ? 0.06 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;
  final Color accentColor;
  final bool isDark;
  final Color? titleColor;
  final Widget? trailing;

  const _CardHeader({
    required this.title,
    required this.accentColor,
    required this.isDark,
    this.titleColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: titleColor ?? (isDark ? Colors.white : AppColors.primary),
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ─── DATA MODELS ─────────────────────────────────────────────────────────────

class _SalarySegment {
  final String label;
  final double amount;
  final Color color;
  const _SalarySegment(this.label, this.amount, this.color);
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem(this.icon, this.label, this.value);
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.isDark = false});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    const name = 'Ahmed Al-Rashid';
    const role = 'Senior Consultant';
    const department = 'Solutions';
    const empId = 'EMP-2024-0847';
    const location = 'Riyadh';
    const experience = '3 yrs';
    const joinDate = '2021';
    const isActive = true;

    return Container(
      width: double.infinity,
      height: 300, // 🔥 مهم عشان الصورة تبان
      child: Stack(
        children: [
          /// ───────── BACKGROUND IMAGE ─────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/pngtree-a-saudi-man-traditional-attire-middle-aged-wearing-white-thobe-and-png-image_16610073.webp', // 👈 صورة المستخدم
              fit: BoxFit.contain,
            ),
          ),

          /// ───────── DARK GRADIENT OVERLAY ─────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.85),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ── TOP ROW (QR)

                    /// ── NAME
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Spacer(),
                        _qrButton(context, empId),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '$role • $department',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ── CHIPS
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: [
                        _badge(Icons.badge_outlined, empId),
                        _badge(Icons.work_history_outlined, experience),
                        _badge(Icons.location_on_outlined, location),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// ── INFO ROW
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _infoItem(
                              Icons.calendar_today_outlined,
                              'Joined',
                              joinDate,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 25,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _infoItem(
                              Icons.work_outline,
                              'Manager',
                              'M. Meghed',
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 25,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _infoItem(
                              Icons.verified_user_outlined,
                              'Status',
                              isActive ? 'Active' : 'Inactive',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ───────── CONTENT ─────────
        ],
      ),
    );
  }

  /// ───────── QR BUTTON ─────────
  Widget _qrButton(BuildContext context, String empId) {
    return GestureDetector(
      onTap: () => _showQrSheet(context, empId),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.qr_code_2, color: Colors.white, size: 22),
      ),
    );
  }

  /// ───────── QR SHEET ─────────
  void _showQrSheet(BuildContext context, String empId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Employee QR",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 20),

              /// Dummy QR image
              Image.asset(
                'assets/images/qrcode.jpeg',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 12),

              Text(
                empId,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 20),

              /// SHARE BUTTON (SYSTEM SHARE SHEET)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text("Share QR"),
                  onPressed: () {
                    shareQrWithLoading(context, empId);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ───────── BADGE ─────────
  Widget _badge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// ───────── INFO ITEM ─────────
  Widget _infoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white60, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 9,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _hideLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            "Preparing QR...",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> shareQrWithLoading(BuildContext context, String empId) async {
  _showLoadingDialog(context);

  try {
    // Artificial delay to ensure user sees the transition
    await Future.delayed(const Duration(milliseconds: 800));

    /// load image
    final byteData = await rootBundle.load('assets/images/qrcode.jpeg');
    final bytes = byteData.buffer.asUint8List();

    /// temp file
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);

    if (context.mounted) _hideLoadingDialog(context);

    /// share
    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Employee Digital ID Card\nEmployee ID: $empId');
  } catch (e) {
    if (context.mounted) _hideLoadingDialog(context);
    debugPrint("Share error: $e");
  }
}
