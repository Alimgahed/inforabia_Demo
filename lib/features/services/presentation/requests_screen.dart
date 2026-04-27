import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});
  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _filterIndex = 0;

  final List<Map<String, dynamic>> _myRequests = [
    {
      'title': 'Employment Certificate',
      'id': 'REQ-8821',
      'date': '12 Apr 2024',
      'status': 'Approved',
      'type': 'Certificate',
      'color': AppColors.success,
      'icon': Icons.description_rounded,
      'dept': 'HR',
    },
    {
      'title': 'Business Trip: Riyadh HQ',
      'id': 'TRP-1029',
      'date': '11 Apr 2024',
      'status': 'Approved',
      'type': 'Travel',
      'color': AppColors.success,
      'icon': Icons.flight_takeoff_rounded,
      'dept': 'Admin',
    },
    {
      'title': 'New Office Chair',
      'id': 'FUR-552',
      'date': '10 Apr 2024',
      'status': 'Pending',
      'type': 'Furniture',
      'color': AppColors.warning,
      'icon': Icons.chair_rounded,
      'dept': 'Procurement',
    },
    {
      'title': 'Purchase Order: HP Monitor',
      'id': 'PO-4412',
      'date': '10 Apr 2024',
      'status': 'Pending',
      'type': 'Purchase',
      'color': AppColors.warning,
      'icon': Icons.shopping_cart_rounded,
      'dept': 'IT',
    },
    {
      'title': 'Attendance Correction AM',
      'id': 'ATT-092',
      'date': '08 Apr 2024',
      'status': 'Rejected',
      'type': 'Attendance',
      'color': AppColors.error,
      'icon': Icons.fingerprint_rounded,
      'dept': 'HR',
    },
    {
      'title': 'Arabic Language Course',
      'id': 'EDU-221',
      'date': '05 Apr 2024',
      'status': 'Approved',
      'type': 'Training',
      'color': AppColors.success,
      'icon': Icons.school_rounded,
      'dept': 'L&D',
    },
    {
      'title': 'Delegation Rule: Leave System',
      'id': 'DEL-001',
      'date': '14 Apr 2024',
      'status': 'Active',
      'type': 'Delegation',
      'color': AppColors.primary,
      'icon': Icons.swap_horiz_rounded,
      'dept': 'HR',
    },
    {
      'title': 'Basic Data Update: Phone',
      'id': 'UPD-113',
      'date': '02 Apr 2024',
      'status': 'Approved',
      'type': 'Data Update',
      'color': AppColors.success,
      'icon': Icons.phone_android_rounded,
      'dept': 'Self-Service',
    },
  ];

  final List<Map<String, dynamic>> _approvals = [
    {
      'name': 'Sara Al-Qurashi',
      'initial': 'S',
      'title': 'Annual Leave (10 Days)',
      'dept': 'Engineering',
      'date': '15 Apr 2024',
      'icon': Icons.beach_access_rounded,
      'priority': 'High',
      'desc': 'Apr 20 – Apr 30, 2024',
    },
    {
      'name': 'Omar Khalid',
      'initial': 'O',
      'title': 'Asset Request: Laptop Bag',
      'dept': 'Product',
      'date': '14 Apr 2024',
      'icon': Icons.laptop_rounded,
      'priority': 'Medium',
      'desc': 'Dell Laptop Bag 15" × 1',
    },
    {
      'name': 'Fahad Al-Malki',
      'initial': 'F',
      'title': 'Training: Flutter Advanced',
      'dept': 'Engineering',
      'date': '13 Apr 2024',
      'icon': Icons.psychology_rounded,
      'priority': 'Low',
      'desc': 'Apr 22 – Apr 24, 3 days workshop',
    },
    {
      'name': 'Mona Ahmed',
      'initial': 'M',
      'title': 'Overtime Authorization (8h)',
      'dept': 'Marketing',
      'date': '12 Apr 2024',
      'icon': Icons.timer_rounded,
      'priority': 'Medium',
      'desc': 'Project Delta deadline crunch',
    },
    {
      'name': 'Ali Hassan',
      'initial': 'A',
      'title': 'End of Service Request',
      'dept': 'Operations',
      'date': '10 Apr 2024',
      'icon': Icons.exit_to_app_rounded,
      'priority': 'High',
      'desc': 'Resignation effective 30 Apr 2024',
    },
  ];

  List<String> get _filters => [
        l10n.filterAll,
        l10n.filterApproved,
        l10n.filterPending,
        l10n.filterRejected,
      ];

  late AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
  }

  List<Map<String, dynamic>> get _filteredRequests {
    if (_filterIndex == 0) return _myRequests;
    final statusMap = {
      1: 'Approved',
      2: 'Pending',
      3: 'Rejected',
    };
    return _myRequests
        .where((r) => r['status'] == statusMap[_filterIndex])
        .toList();
  }

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final approved = _myRequests.where((r) => r['status'] == 'Approved').length;
    final pending = _myRequests.where((r) => r['status'] == 'Pending').length;
    final rejected = _myRequests.where((r) => r['status'] == 'Rejected').length;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF0F4FA),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.darkTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -40,
                      child: Opacity(
                        opacity: 0.07,
                        child: Icon(
                          Icons.assignment_rounded,
                          size: 220,
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
                            l10n.requestsAndApprovals,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.trackManageRequests,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                               _headerStat(
                                l10n.filterApproved,
                                '$approved',
                                AppColors.accent,
                              ),
                              const SizedBox(width: 10),
                              _headerStat(
                                l10n.filterPending,
                                '$pending',
                                AppColors.secondary,
                              ),
                              const SizedBox(width: 10),
                              _headerStat(
                                l10n.filterRejected,
                                '$rejected',
                                Colors.redAccent.shade100,
                              ),
                              const SizedBox(width: 10),
                              _headerStat(
                                l10n.totalRequests,
                                '${_myRequests.length}',
                                Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(height: 60),
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
                decoration: const BoxDecoration(color: AppColors.darkTeal),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  tabs: [
                    Tab(text: l10n.myRequests),
                    Tab(text: l10n.pendingApprovals),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildMyRequestsTab(l10n, isDark),
            _buildApprovalsTab(l10n, isDark),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewRequestPicker(context, l10n, isDark),
        label: Text(l10n.newRequest),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
    );
  }

  Widget _headerStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
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
  }

  Widget _buildMyRequestsTab(AppLocalizations l10n, bool isDark) {
    return Column(
      children: [
        // Filter chips
        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _filters.length,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => setState(() => _filterIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _filterIndex == i
                      ? AppColors.primary
                      : (isDark ? AppColors.darkCard : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _filterIndex == i
                        ? AppColors.primary
                        : AppColors.grey.withOpacity(0.3),
                  ),
                  boxShadow: _filterIndex == i
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  _filters[i],
                  style: TextStyle(
                    color: _filterIndex == i
                        ? Colors.white
                        : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.black),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: _filteredRequests.length,
            itemBuilder: (context, i) {
              final req = _filteredRequests[i];
              final color = req['color'] as Color;
              return FadeInUp(
                delay: Duration(milliseconds: i * 70),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Column(
                      children: [
                        // Top color accent bar
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
                                          color.withOpacity(0.06),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      req['icon'] as IconData,
                                      color: color,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          req['title'] as String,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            _metaChip(
                                              req['type'] as String,
                                              isDark,
                                            ),
                                            const SizedBox(width: 6),
                                            _metaChip(
                                              req['dept'] as String,
                                              isDark,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: color.withOpacity(0.25),
                                      ),
                                    ),
                                    child: Text(
                                      req['status'] == 'Approved'
                                          ? l10n.filterApproved
                                          : req['status'] == 'Pending'
                                              ? l10n.filterPending
                                              : req['status'] == 'Rejected'
                                                  ? l10n.filterRejected
                                                  : req['status'] as String,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.tag_rounded,
                                    size: 13,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    req['id'] as String,
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
                                    size: 12,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    req['date'] as String,
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
          ),
        ),
      ],
    );
  }

  Widget _metaChip(String label, bool isDark) {
    return Container(
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
  }

  Widget _buildApprovalsTab(AppLocalizations l10n, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _approvals.length,
      itemBuilder: (context, i) {
        final a = _approvals[i];
        Color priorityColor = AppColors.accent;
        if (a['priority'] == 'High') priorityColor = AppColors.secondary;
        if (a['priority'] == 'Medium') priorityColor = AppColors.primary;

        // Avatar gradient colors cycle through brand palette
        final avatarColors = [
          AppColors.primary,
          AppColors.secondary,
          AppColors.accent,
          AppColors.darkTeal,
        ];
        final avatarColor = avatarColors[i % avatarColors.length];

        return FadeInUp(
          delay: Duration(milliseconds: i * 70),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  // Priority color stripe
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [priorityColor, priorityColor.withOpacity(0.4)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    avatarColor,
                                    avatarColor.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  a['initial'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '${a['dept']} • ${a['date']}',
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
                                color: priorityColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: priorityColor.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 7,
                                    color: priorityColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    a['priority'] as String,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: priorityColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkBackground
                                : const Color(0xFFF6F8FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  a['icon'] as IconData,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      a['title'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      a['desc'] as String,
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48, // نفس الارتفاع للاتنين
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                  ),
                                  label: Text(l10n.reject),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.secondary,
                                    side: const BorderSide(
                                      color: AppColors.secondary,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 48, // نفس الارتفاع هنا
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                  ),
                                  label: Text(l10n.approve),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
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
  }

  void _showNewRequestPicker(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkDivider : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.newRequest,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _bottomSheetOption(
              Icons.description_rounded,
              l10n.certificateRequest,
              'Employment, salary, experience',
              AppColors.primary,
              isDark,
            ),
            _bottomSheetOption(
              Icons.shopping_cart_rounded,
              l10n.purchaseOrder,
              'Equipment, software, supplies',
              AppColors.accent,
              isDark,
            ),
            _bottomSheetOption(
              Icons.fingerprint_rounded,
              l10n.attendanceCorrection,
              'Missing punch, remote work',
              AppColors.darkTeal,
              isDark,
            ),
            _bottomSheetOption(
              Icons.swap_horiz_rounded,
              l10n.leaveDelegationRules,
              'Setup approval delegation',
              AppColors.secondary,
              isDark,
            ),
            _bottomSheetOption(
              Icons.exit_to_app_rounded,
              l10n.terminationOfServices,
              'End of service request',
              Colors.redAccent,
              isDark,
            ),
            _bottomSheetOption(
              Icons.edit_note_rounded,
              l10n.basicDataUpdate,
              'Phone, address, qualifications',
              AppColors.primary,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheetOption(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    bool isDark,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.18), color.withOpacity(0.06)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      subtitle,
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
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
