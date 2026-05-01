import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

// ─── Data Model ───────────────────────────────────────────────────────────────

class TeamMember {
  final String name;
  final String jobTitle;
  final String department;
  final String employeeId;
  final String email;
  final String phone;
  final String joiningDate;
  final String status; // 'Active' | 'On Leave' | 'Remote'
  final String location;
  final double performance; // 0–100
  final int tasksCompleted;
  final int tasksPending;
  final Color accentColor;
  final IconData icon;
  final double salary;
  final String manager;
  final String nationality;
  final String contract; // 'Full-Time' | 'Part-Time' | 'Contract'
  final int leaveBalance;
  final int attendance; // % this month
  final List<double> weeklyPerf; // 5 weeks
  final String gender; // 'Male' | 'Female'
  final String avatarAsset;

  const TeamMember({
    required this.name,
    required this.jobTitle,
    required this.department,
    required this.employeeId,
    required this.email,
    required this.phone,
    required this.joiningDate,
    required this.status,
    required this.location,
    required this.performance,
    required this.tasksCompleted,
    required this.tasksPending,
    required this.accentColor,
    required this.icon,
    required this.salary,
    required this.manager,
    required this.nationality,
    required this.contract,
    required this.leaveBalance,
    required this.attendance,
    required this.weeklyPerf,
    required this.gender,
    required this.avatarAsset,
  });
}

// ─── Sample Data ──────────────────────────────────────────────────────────────

const _teamMembers = [
  TeamMember(
    name: 'Sara Al-Otaibi',
    jobTitle: 'Store Manager',
    department: 'Store Operations',
    employeeId: 'EMP-2022-0210',
    email: 'sara.o@panda.com.sa',
    phone: '+966 50 123 4567',
    joiningDate: '15 Mar 2022',
    status: 'Active',
    location: 'Riyadh Branch',
    performance: 94,
    tasksCompleted: 42,
    tasksPending: 3,
    accentColor: AppColors.primary, // Panda Green
    icon: Icons.storefront_rounded,
    salary: 18500,
    manager: 'Ahmed Al-Rashid',
    nationality: 'Saudi',
    contract: 'Full-Time',
    leaveBalance: 21,
    attendance: 98,
    weeklyPerf: [88, 91, 95, 93, 94],
    gender: 'Female',
    avatarAsset: 'assets/images/team/sara.png',
  ),
  TeamMember(
    name: 'Omar Al-Fouzan',
    jobTitle: 'Customer Service Lead',
    department: 'Customer Service',
    employeeId: 'EMP-2023-0415',
    email: 'omar.f@panda.com.sa',
    phone: '+966 55 987 6543',
    joiningDate: '01 Jun 2023',
    status: 'Active',
    location: 'Jeddah Branch',
    performance: 87,
    tasksCompleted: 34,
    tasksPending: 5,
    accentColor: Color(0xFF36D1BB),
    icon: Icons.support_agent_rounded,
    salary: 14000,
    manager: 'Sara Al-Otaibi',
    nationality: 'Saudi',
    contract: 'Full-Time',
    leaveBalance: 14,
    attendance: 90,
    weeklyPerf: [80, 84, 87, 85, 87],
    gender: 'Male',
    avatarAsset: 'assets/images/team/omar.png',
  ),
  TeamMember(
    name: 'Noura Al-Dosari',
    jobTitle: 'Fresh Produce Supervisor',
    department: 'Fresh Food',
    employeeId: 'EMP-2021-0095',
    email: 'noura.d@panda.com.sa',
    phone: '+966 53 555 1122',
    joiningDate: '10 Jan 2021',
    status: 'On Leave',
    location: 'Riyadh Branch',
    performance: 78,
    tasksCompleted: 28,
    tasksPending: 8,
    accentColor: AppColors.secondary, // Panda Red
    icon: Icons.eco_rounded,
    salary: 13500,
    manager: 'Sara Al-Otaibi',
    nationality: 'Saudi',
    contract: 'Full-Time',
    leaveBalance: 7,
    attendance: 72,
    weeklyPerf: [82, 76, 75, 79, 78],
    gender: 'Female',
    avatarAsset: 'assets/images/team/noura.png',
  ),
  TeamMember(
    name: 'Faisal Al-Harbi',
    jobTitle: 'Inventory Manager',
    department: 'Supply Chain',
    employeeId: 'EMP-2022-0341',
    email: 'faisal.h@panda.com.sa',
    phone: '+966 56 234 8890',
    joiningDate: '20 Sep 2022',
    status: 'Active',
    location: 'Riyadh HQ',
    performance: 91,
    tasksCompleted: 38,
    tasksPending: 2,
    accentColor: Color(0xFF1E5799),
    icon: Icons.inventory_2_rounded,
    salary: 16000,
    manager: 'Ahmed Al-Rashid',
    nationality: 'Saudi',
    contract: 'Full-Time',
    leaveBalance: 18,
    attendance: 96,
    weeklyPerf: [85, 88, 90, 92, 91],
    gender: 'Male',
    avatarAsset: 'assets/images/team/faisal.png',
  ),
  TeamMember(
    name: 'Reem Al-Shammari',
    jobTitle: 'Senior Cashier',
    department: 'Checkout',
    employeeId: 'EMP-2023-0620',
    email: 'reem.s@panda.com.sa',
    phone: '+966 59 778 3341',
    joiningDate: '01 Feb 2023',
    status: 'Active',
    location: 'Dammam Branch',
    performance: 83,
    tasksCompleted: 30,
    tasksPending: 6,
    accentColor: Color(0xFFF7971E),
    icon: Icons.point_of_sale_rounded,
    salary: 12500,
    manager: 'Sara Al-Otaibi',
    nationality: 'Saudi',
    contract: 'Part-Time',
    leaveBalance: 12,
    attendance: 88,
    weeklyPerf: [78, 80, 82, 84, 83],
    gender: 'Female',
    avatarAsset: 'assets/images/team/reem.png',
  ),
  TeamMember(
    name: 'Yasser Al-Qahtani',
    jobTitle: 'Bakery Supervisor',
    department: 'Bakery',
    employeeId: 'EMP-2020-0012',
    email: 'yasser.q@panda.com.sa',
    phone: '+966 50 441 9900',
    joiningDate: '05 Mar 2020',
    status: 'Active',
    location: 'Riyadh Branch',
    performance: 96,
    tasksCompleted: 55,
    tasksPending: 1,
    accentColor: AppColors.primary, // Panda Green
    icon: Icons.bakery_dining_rounded,
    salary: 22000,
    manager: 'Ahmed Al-Rashid',
    nationality: 'Saudi',
    contract: 'Full-Time',
    leaveBalance: 23,
    attendance: 99,
    weeklyPerf: [92, 94, 95, 97, 96],
    gender: 'Male',
    avatarAsset: 'assets/images/team/yasser.png',
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class MyTeamScreen extends StatefulWidget {
  const MyTeamScreen({super.key});

  @override
  State<MyTeamScreen> createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends State<MyTeamScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filter = 'All';
  int? _expandedIndex;

  static List<String> _getFilters(AppLocalizations l10n) => [
    'All',
    l10n.active,
    l10n.remote,
    l10n.onLeave,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var m in _teamMembers) {
      precacheImage(AssetImage(m.avatarAsset), context);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TeamMember> _getFiltered(AppLocalizations l10n) {
    if (_filter == 'All') return _teamMembers;
    final statusMap = {
      l10n.active: 'Active',
      l10n.remote: 'Remote',
      l10n.onLeave: 'On Leave',
    };
    return _teamMembers
        .where((m) => m.status == (statusMap[_filter] ?? 'Active'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : const Color(0xFFF4F6FC);

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: bg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverHeader(context, l10n, isDark, innerBoxIsScrolled),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildMembersTab(l10n, isDark),
            _buildStatsTab(l10n, isDark),
          ],
        ),
      ),
    );
  }

  // ── Sliver Header ──────────────────────────────────────────────────────────

  Widget _buildSliverHeader(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool collapsed,
  ) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      floating: false,
      backgroundColor: AppColors.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: _buildHeaderContent(l10n, isDark),
        title: collapsed
            ? Text(
                l10n.myTeam,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            : null,
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.secondary,
        indicatorWeight: 4,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        tabs: [
          Tab(
            icon: const Icon(Icons.people_rounded, size: 18),
            text: l10n.members,
          ),
          Tab(
            icon: const Icon(Icons.bar_chart_rounded, size: 18),
            text: l10n.statistics,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(AppLocalizations l10n, bool isDark) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 56),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInLeft(
                  child: Text(
                    l10n.myTeam,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FadeInLeft(
                  delay: const Duration(milliseconds: 150),
                  child: Text(
                    'Panda Hyper Market • ${_teamMembers.length} ${l10n.members}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          FadeInRight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _miniStat(
                  '${_teamMembers.where((m) => m.status == 'Active').length}',
                  l10n.active,
                  AppColors.chartBlue,
                ),
                const SizedBox(height: 6),
                _miniStat(
                  '${_teamMembers.where((m) => m.status == 'Remote').length}',
                  l10n.remote,
                  const Color(0xFF36D1BB),
                ),
                const SizedBox(height: 6),
                _miniStat(
                  '${_teamMembers.where((m) => m.status == 'On Leave').length}',
                  l10n.onLeave,
                  AppColors.warning,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String val, String lbl, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            val,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(lbl, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  // ── Members Tab ───────────────────────────────────────────────────────────

  Widget _buildMembersTab(AppLocalizations l10n, bool isDark) {
    final members = _getFiltered(l10n);
    return Column(
      children: [
        _buildFilterChips(l10n, isDark),
        Expanded(
          child: members.isEmpty
              ? Center(child: Text(l10n.noData))
              : ListView.builder(
                  cacheExtent: 1000,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: members.length,
                  itemBuilder: (context, i) {
                    final member = members[i];
                    final isExpanded = _expandedIndex == i;
                    return RepaintBoundary(
                      child: _MemberCard(
                        member: member,
                        isExpanded: isExpanded,
                        isDark: isDark,
                        l10n: l10n,
                        onTap: () => setState(
                          () => _expandedIndex = isExpanded ? null : i,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(AppLocalizations l10n, bool isDark) {
    final filters = _getFilters(l10n);
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        cacheExtent: 1000,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final f = filters[i];
          final selected = _filter == f;
          return ChoiceChip(
            label: Text(f == 'All' ? l10n.viewAll : f),
            selected: selected,
            onSelected: (val) {
              if (val) setState(() => _filter = f);
            },
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: selected
                  ? Colors.white
                  : (isDark ? Colors.white70 : AppColors.grey),
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          );
        },
      ),
    );
  }

  // ── Statistics Tab ────────────────────────────────────────────────────────

  Widget _buildStatsTab(AppLocalizations l10n, bool isDark) {
    final avgPerf =
        _teamMembers.fold<double>(0, (s, m) => s + m.performance) /
        _teamMembers.length;
    final avgAttendance =
        _teamMembers.fold<double>(0, (s, m) => s + m.attendance) /
        _teamMembers.length;
    final totalTasks = _teamMembers.fold<int>(
      0,
      (s, m) => s + m.tasksCompleted + m.tasksPending,
    );
    final completedTasks = _teamMembers.fold<int>(
      0,
      (s, m) => s + m.tasksCompleted,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      child: Column(
        children: [
          // Top KPI row
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            child: Row(
              children: [
                Expanded(
                  child: _kpiCard(
                    l10n.avgPerformance,
                    '${avgPerf.toStringAsFixed(1)}%',
                    Icons.trending_up_rounded,
                    AppColors.primary,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard(
                    l10n.avgAttendance,
                    '${avgAttendance.toStringAsFixed(0)}%',
                    Icons.calendar_today_rounded,
                    AppColors.success,
                    isDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: Row(
              children: [
                Expanded(
                  child: _kpiCard(
                    'Total Team Members',
                    '${_teamMembers.length}',
                    Icons.people_rounded,
                    const Color(0xFF8E44AD),
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard(
                    'Task Completion',
                    '${(completedTasks / totalTasks * 100).toStringAsFixed(0)}%',
                    Icons.task_alt_rounded,
                    AppColors.secondary,
                    isDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Department Breakdown Pie Chart
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: RepaintBoundary(
              child: _buildDepartmentPie(isDark),
            ),
          ),
          const SizedBox(height: 16),

          // Performance Bar Chart
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            child: RepaintBoundary(
              child: _buildPerformanceBar(isDark),
            ),
          ),
          const SizedBox(height: 16),

          // Status Distribution
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: _buildStatusCard(isDark),
          ),
          const SizedBox(height: 16),

          // Gender Breakdown
          FadeInUp(
            duration: const Duration(milliseconds: 875),
            child: _buildGenderCard(isDark),
          ),
          const SizedBox(height: 16),

          // Top Performers Leaderboard
          FadeInUp(
            duration: const Duration(milliseconds: 950),
            child: _buildLeaderboard(isDark),
          ),
        ],
      ),
    );
  }

  Widget _kpiCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentPie(bool isDark) {
    final depts = <String, int>{};
    for (final m in _teamMembers) {
      depts[m.department] = (depts[m.department] ?? 0) + 1;
    }
    final colors = [
      AppColors.primary,
      const Color(0xFF36D1BB),
      const Color(0xFFF7971E),
      const Color(0xFF8E44AD),
    ];
    final entries = depts.entries.toList();

    return _chartCard(
      'Department Breakdown',
      isDark,
      SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  sections: List.generate(entries.length, (i) {
                    return PieChartSectionData(
                      value: entries[i].value.toDouble(),
                      color: colors[i % colors.length],
                      radius: 38,
                      title: '${entries[i].value}',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                entries.length,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        entries[i].key,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white70 : Colors.black87,
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

  Widget _buildPerformanceBar(bool isDark) {
    return _chartCard(
      'Team Performance Scores',
      isDark,
      SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    final names = _teamMembers
                        .map((m) => m.name.split(' ')[0])
                        .toList();
                    if (v.toInt() >= names.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        names[v.toInt()],
                        style: TextStyle(
                          fontSize: 8,
                          color: isDark ? Colors.white54 : Colors.grey,
                        ),
                      ),
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
            barGroups: List.generate(_teamMembers.length, (i) {
              final m = _teamMembers[i];
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: m.performance,
                    gradient: LinearGradient(
                      colors: [m.accentColor.withOpacity(0.6), m.accentColor],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    width: 24,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    final statuses = {
      'Active': _teamMembers.where((m) => m.status == 'Active').length,
      'Remote': _teamMembers.where((m) => m.status == 'Remote').length,
      'On Leave': _teamMembers.where((m) => m.status == 'On Leave').length,
    };
    final colors = {
      'Active': AppColors.success,
      'Remote': const Color(0xFF36D1BB),
      'On Leave': AppColors.warning,
    };
    final total = _teamMembers.length;

    return _chartCard(
      'Status Distribution',
      isDark,
      Column(
        children: statuses.entries.map((e) {
          final pct = e.value / total;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Text(
                    e.key,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors[e.key]!,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 10,
                      backgroundColor: colors[e.key]!.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(colors[e.key]!),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${e.value}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors[e.key]!,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGenderCard(bool isDark) {
    final maleCount = _teamMembers.where((m) => m.gender == 'Male').length;
    final femaleCount = _teamMembers.where((m) => m.gender == 'Female').length;
    final total = _teamMembers.length;

    return _chartCard(
      'Gender Demographics',
      isDark,
      Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 140,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 30,
                  sections: [
                    PieChartSectionData(
                      value: maleCount.toDouble(),
                      color: const Color(0xFF2196F3),
                      radius: 35,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: femaleCount.toDouble(),
                      color: const Color(0xFFE91E63),
                      radius: 35,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGenderStatRow(
                  'Male',
                  maleCount,
                  total,
                  const Color(0xFF2196F3),
                  Icons.male_rounded,
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildGenderStatRow(
                  'Female',
                  femaleCount,
                  total,
                  const Color(0xFFE91E63),
                  Icons.female_rounded,
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderStatRow(
    String label,
    int count,
    int total,
    Color color,
    IconData icon,
    bool isDark,
  ) {
    final pct = (count / total * 100).toStringAsFixed(0);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  '$count Members',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$pct%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(bool isDark) {
    final sorted = [..._teamMembers]
      ..sort((a, b) => b.performance.compareTo(a.performance));
    return _chartCard(
      '🏆 Top Performers',
      isDark,
      Column(
        children: List.generate(sorted.length, (i) {
          final m = sorted[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: i == 0
                        ? const Color(0xFFFFD700).withOpacity(0.2)
                        : i == 1
                        ? Colors.grey.withOpacity(0.2)
                        : i == 2
                        ? const Color(0xFFCD7F32).withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '#${i + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: i == 0
                          ? const Color(0xFFFFD700)
                          : i == 1
                          ? Colors.grey
                          : i == 2
                          ? const Color(0xFFCD7F32)
                          : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: m.accentColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(m.icon, size: 16, color: m.accentColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        m.jobTitle,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white54 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: m.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${m.performance.toInt()}%',
                    style: TextStyle(
                      color: m.accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _chartCard(String title, bool isDark, Widget content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 12,
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
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          content,
        ],
      ),
    );
  }
}

// ─── Member Card Widget ────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  final TeamMember member;
  final bool isExpanded;
  final bool isDark;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _MemberCard({
    required this.member,
    required this.isExpanded,
    required this.isDark,
    required this.onTap,
    required this.l10n,
  });

  String _getLocalizedStatus(String status) {
    switch (status) {
      case 'Active':
        return l10n.active;
      case 'Remote':
        return l10n.remote;
      case 'On Leave':
        return l10n.onLeave;
      default:
        return status;
    }
  }

  Color get _statusColor {
    switch (member.status) {
      case 'Active':
        return AppColors.success;
      case 'Remote':
        return const Color(0xFF36D1BB);
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: member.accentColor.withOpacity(isExpanded ? 0.18 : 0.08),
              blurRadius: isExpanded ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: isExpanded
              ? Border.all(
                  color: member.accentColor.withOpacity(0.35),
                  width: 1.5,
                )
              : null,
        ),
        child: Column(
          children: [
            // ─ Header row ─
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // Avatar
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: member.accentColor.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: member.accentColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                member.avatarAsset,
                                fit: BoxFit.cover,
                                cacheWidth: 104,
                                cacheHeight: 104,
                                frameBuilder: (context, child, frame, wasSync) {
                                  if (wasSync) return child;
                                  return AnimatedOpacity(
                                    opacity: frame == null ? 0 : 1,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: child,
                                  );
                                },
                                errorBuilder: (_, __, ___) => Icon(
                                  member.icon,
                                  color: member.accentColor,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: _statusColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkCard
                                    : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Name + title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              member.jobTitle,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white54 : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _getLocalizedStatus(member.status),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _statusColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    member.department,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Performance score + expand icon
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _PerfRing(
                            perf: member.performance,
                            color: member.accentColor,
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: isDark ? Colors.white38 : Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Unread Indicator Logic (Pending tasks alert)
                if (member.tasksPending > 0 && !isExpanded)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            // ─ Expanded Details ─
            if (isExpanded) ...[
              Divider(
                height: 1,
                color: isDark ? Colors.white12 : Colors.grey.shade100,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                child: Column(
                  children: [
                    // Smart Navigation (Quick Actions)
                    _buildQuickActions(isDark),
                    const SizedBox(height: 14),
                    // Quick metric row
                    _buildMetricRow(),
                    const SizedBox(height: 14),
                    // Performance trend
                    _buildWeeklyTrend(),
                    const SizedBox(height: 14),
                    // Detail grid (HR fields)
                    _buildDetailGrid(isDark),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _quickActionBtn(Icons.call_rounded, 'Call', isDark),
        _quickActionBtn(Icons.email_rounded, 'Email', isDark),
        _quickActionBtn(Icons.chat_bubble_rounded, 'Message', isDark),
        _quickActionBtn(Icons.assignment_ind_rounded, 'Profile', isDark),
      ],
    );
  }

  Widget _quickActionBtn(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: member.accentColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: member.accentColor, size: 18),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.white70 : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow() {
    return Row(
      children: [
        _Metric(
          'Tasks Done',
          '${member.tasksCompleted}',
          Icons.check_circle_rounded,
          AppColors.success,
        ),
        _Metric(
          'Pending',
          '${member.tasksPending}',
          Icons.pending_rounded,
          AppColors.warning,
        ),
        _Metric(
          'Attendance',
          '${member.attendance}%',
          Icons.calendar_month_rounded,
          AppColors.primary,
        ),
        // Leave card with progress indicator
        Expanded(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      value: member.leaveBalance / 30, // Assuming 30 total
                      strokeWidth: 2,
                      backgroundColor: const Color(0xFF36D1BB).withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF36D1BB),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.beach_access_rounded,
                    color: Color(0xFF36D1BB),
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${member.leaveBalance}d',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF36D1BB),
                ),
              ),
              Builder(
                builder: (context) {
                  return Text(
                    'Leave Bal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white38
                          : Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyTrend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Trend (Last 5 Weeks)',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white54 : Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: LineChart(
            LineChartData(
              minY: 60,
              maxY: 100,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    member.weeklyPerf.length,
                    (i) => FlSpot(i.toDouble(), member.weeklyPerf[i]),
                  ),
                  isCurved: true,
                  color: member.accentColor,
                  barWidth: 2.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
                      radius: 3,
                      color: member.accentColor,
                      strokeWidth: 1.5,
                      strokeColor: Colors.white,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        member.accentColor.withOpacity(0.2),
                        member.accentColor.withOpacity(0.0),
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
      ],
    );
  }

  Widget _buildDetailGrid(bool isDark) {
    final fields = [
      _Field(Icons.badge_rounded, 'Employee ID', member.employeeId),
      _Field(Icons.email_rounded, 'Email', member.email),
      _Field(Icons.phone_rounded, 'Phone', member.phone),
      _Field(Icons.location_on_rounded, 'Location', member.location),
      _Field(Icons.calendar_today_rounded, 'Joining Date', member.joiningDate),
      _Field(Icons.supervisor_account_rounded, 'Manager', member.manager),
      _Field(Icons.public_rounded, 'Nationality', member.nationality),
      _Field(Icons.work_history_rounded, 'Contract', member.contract),
      _Field(
        Icons.attach_money_rounded,
        'Salary',
        'SAR ${member.salary.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')}',
      ),
    ];

    return Column(
      children: fields
          .map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: member.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(f.icon, size: 14, color: member.accentColor),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 90,
                    child: Text(
                      f.label,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            f.value,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (f.label == 'Salary') ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '+5%',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// ─── Performance Ring ─────────────────────────────────────────────────────────

class _PerfRing extends StatelessWidget {
  final double perf;
  final Color color;
  const _PerfRing({required this.perf, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: perf / 100,
            strokeWidth: 4,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Text(
            '${perf.toInt()}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Small helpers ────────────────────────────────────────────────────────────

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _Metric(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: color,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? Colors.white38 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _Field {
  final IconData icon;
  final String label;
  final String value;
  const _Field(this.icon, this.label, this.value);
}
