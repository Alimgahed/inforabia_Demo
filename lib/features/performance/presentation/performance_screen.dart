// ─────────────────────────────────────────────────────────────────────────────
// models.dart  –  All data models for the Performance Management demo
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:Panda/core/theme/app_colors.dart';

class KPI {
  final String id;
  final String name;
  final String description;
  final double weight; // percentage

  const KPI({
    required this.id,
    required this.name,
    required this.description,
    required this.weight,
  });
}

class Goal {
  final String id;
  final String title;
  final String description;
  final double weight; // percentage
  final String startDate;
  final String endDate;
  final String kpiId;

  // Employee input
  double employeeProgress; // 0–100
  String employeeComment;

  // Manager input
  double managerProgress; // 0–100
  String managerComment;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.weight,
    required this.startDate,
    required this.endDate,
    required this.kpiId,
    this.employeeProgress = 0,
    this.employeeComment = '',
    this.managerProgress = 0,
    this.managerComment = '',
  });
}

class HR360Item {
  final String id;
  final String nameAr;
  final String nameEn;
  int rating; // 1–5
  String comment;

  HR360Item({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.rating = 3,
    this.comment = '',
  });
}

class AttendanceData {
  final int totalDays;
  final int present;
  final int absent;
  final int late;

  const AttendanceData({
    required this.totalDays,
    required this.present,
    required this.absent,
    required this.late,
  });

  double get attendancePercent =>
      totalDays == 0 ? 0 : (present / totalDays) * 100;

  double get score {
    final pct = attendancePercent;
    if (pct >= 95) return 100;
    if (pct >= 85) return 80;
    if (pct >= 75) return 60;
    return 40;
  }
}

class Employee {
  final String id;
  final String name;
  final String jobTitle;
  final String department;
  final String avatarInitials;

  const Employee({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.department,
    required this.avatarInitials,
  });
}

class Objective {
  final String title;
  final bool isCompleted;

  const Objective({required this.title, this.isCompleted = false});
}

// ─────────────────────────────────────────────────────────────────────────────
// Dummy data factory
// ─────────────────────────────────────────────────────────────────────────────

class DummyData {
  static final Employee employee = Employee(
    id: 'e001',
    name: 'Ahmed Al-Rashid',
    jobTitle: 'Operations Supervisor',
    department: 'Retail Operations - Store 45',
    avatarInitials: 'AR',
  );

  static final List<KPI> kpis = [
    const KPI(
      id: 'k1',
      name: 'Customer Excellence',
      description: 'Delivering superior service and delighting customers',
      weight: 40,
    ),
    const KPI(
      id: 'k2',
      name: 'Operational Efficiency',
      description: 'Inventory accuracy, shrinkage control, and safety',
      weight: 30,
    ),
    const KPI(
      id: 'k3',
      name: 'Values & Leadership',
      description: 'Living Panda values (Ownership, Agility, Teamwork)',
      weight: 30,
    ),
  ];

  static List<Goal> buildGoals() => [
    Goal(
      id: 'g1',
      title: 'Optimize Freshness Management',
      description:
          'Reduce food waste in the Produce department by 15% through better rotation',
      weight: 30,
      startDate: '01 Jan 2024',
      endDate: '30 Apr 2024',
      kpiId: 'k2',
      employeeProgress: 85,
      employeeComment:
          'New rotation schedule implemented. Waste reduced by 12% so far.',
      managerProgress: 80,
    ),
    Goal(
      id: 'g2',
      title: 'Customer Satisfaction Score',
      description:
          'Achieve a CSAT score of 4.5/5.0 for Store 45 through improved checkout speed',
      weight: 30,
      startDate: '01 Feb 2024',
      endDate: '15 May 2024',
      kpiId: 'k1',
      employeeProgress: 70,
      employeeComment:
          'Checkout queues are moving faster. Customers noticed the change.',
      managerProgress: 65,
    ),
    Goal(
      id: 'g3',
      title: 'Safety Compliance Audit',
      description:
          'Achieve 100% compliance in the quarterly Health & Safety inspection',
      weight: 20,
      startDate: '01 Mar 2024',
      endDate: '30 Jun 2024',
      kpiId: 'k2',
      employeeProgress: 90,
      employeeComment: 'Pre-audit completed. All high-risk areas cleared.',
      managerProgress: 90,
    ),
    Goal(
      id: 'g4',
      title: 'Values Training Program',
      description: 'Lead "Panda Values" workshop for 15 new floor associates',
      weight: 10,
      startDate: '01 Jan 2024',
      endDate: '31 Aug 2024',
      kpiId: 'k3',
      employeeProgress: 100,
      employeeComment: 'Workshop completed for all 15 associates in February.',
      managerProgress: 100,
    ),
    Goal(
      id: 'g5',
      title: 'Inventory Accuracy Score',
      description: 'Maintain 98% accuracy in the stock replenishment system',
      weight: 10,
      startDate: '01 Jan 2024',
      endDate: '15 Mar 2024',
      kpiId: 'k2',
      employeeProgress: 95,
      employeeComment: 'Accuracy is currently at 97.8% following last audit.',
      managerProgress: 98,
    ),
  ];

  static List<HR360Item> buildHR360Items() => [
    HR360Item(
      id: 'h1',
      nameAr: 'التملك والمبادرة',
      nameEn: 'Ownership',
      rating: 4,
    ),
    HR360Item(
      id: 'h2',
      nameAr: 'المرونة والرشاقة',
      nameEn: 'Agility',
      rating: 5,
    ),
    HR360Item(id: 'h3', nameAr: 'العمل الجماعي', nameEn: 'Teamwork', rating: 4),
    HR360Item(
      id: 'h4',
      nameAr: 'التميز في خدمة العميل',
      nameEn: 'Customer Excellence',
      rating: 3,
    ),
    HR360Item(
      id: 'h5',
      nameAr: 'النزاهة والمهنية',
      nameEn: 'Integrity',
      rating: 5,
    ),
    HR360Item(
      id: 'h6',
      nameAr: 'السلوك والالتزام',
      nameEn: 'Behavior & Commitment',
      rating: 5,
    ),
  ];

  static const AttendanceData attendance = AttendanceData(
    totalDays: 90,
    present: 84,
    absent: 3,
    late: 3,
  );

  static const List<Objective> objectives = [
    Objective(
      title: 'Exceed 10 million SAR in gross revenue by the end of 2026',
    ),
    Objective(
      title:
          'Achieve a net profit margin of at least 15% across all product lines this fiscal year',
    ),
    Objective(
      title:
          'Reduce overall operational expenses by 8% without compromising product quality or headcount',
    ),
    Objective(
      title:
          'Maintain a minimum of 2 million SAR in operating cash flow reserves at all times',
    ),
  ];
}

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle('Performance Cycle'),
                const SizedBox(height: 12),
                _buildFlowCard(context),
                const SizedBox(height: 24),
                _buildSectionTitle('Quick Access'),
                const SizedBox(height: 12),
                _buildMenuGrid(context),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Static Data ──────────────────────────────────────────────────────────

  static final List<_FlowStep> _steps = [
    _FlowStep('1', 'KPI Setup', Icons.flag_outlined, AppColors.secondary),
    _FlowStep('2', 'Goals', Icons.track_changes_outlined, AppColors.primary),
    _FlowStep('3', 'Employee\nInput', Icons.edit_outlined, AppColors.info),
    _FlowStep(
      '4',
      'Manager\nReview',
      Icons.rate_review_outlined,
      AppColors.success,
    ),
  ];

  static List<_MenuItem> _getMenuItems(BuildContext context) => [
    _MenuItem(
      'KPI & Goals Setup',
      'Manage KPIs and create goals',
      Icons.flag_rounded,
      AppColors.secondary,
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KpiGoalsScreen()),
      ),
    ),
    _MenuItem(
      'Employee Input',
      'Set progress & comments',
      Icons.person_outlined,
      AppColors.info,
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EmployeeInputScreen()),
      ),
    ),
    _MenuItem(
      'Manager Review',
      'Complete full performance review',
      Icons.rate_review_rounded,
      AppColors.primary,
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ManagerReviewScreen()),
      ),
      highlight: true,
    ),
    _MenuItem(
      'Reports',
      'View performance history',
      Icons.bar_chart_rounded,
      AppColors.success,
      () {},
    ),
  ];

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Performance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                right: 40,
                bottom: 10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFlowCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: _steps.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: s.color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(s.icon, color: s.color, size: 20),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: s.color,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < _steps.length - 1)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: AppColors.textHint,
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final items = _getMenuItems(context);

    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: items.map((item) => _buildMenuTile(item)).toList(),
    );
  }

  Widget _buildMenuTile(_MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.highlight ? item.color : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: item.highlight
              ? AppColors.elevatedShadow
              : AppColors.cardShadow,
          border: item.highlight
              ? null
              : Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item.highlight
                    ? Colors.white.withOpacity(0.2)
                    : item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                color: item.highlight ? Colors.white : item.color,
                size: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: item.highlight
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: item.highlight
                        ? Colors.white.withOpacity(0.8)
                        : AppColors.textSecondary,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowStep {
  final String number;
  final String label;
  final IconData icon;
  final Color color;
  _FlowStep(this.number, this.label, this.icon, this.color);
}

class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool highlight;
  _MenuItem(
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.onTap, {
    this.highlight = false,
  });
}

class KpiGoalsScreen extends StatefulWidget {
  const KpiGoalsScreen({super.key});

  @override
  State<KpiGoalsScreen> createState() => _KpiGoalsScreenState();
}

class _KpiGoalsScreenState extends State<KpiGoalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Local state for KPIs and Goals (mutable copies)
  final List<KPI> _kpis = List.from(DummyData.kpis);
  final List<Goal> _goals = DummyData.buildGoals();

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'KPI & Goals Setup',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.appGradient),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'KPIs'),
            Tab(text: 'Goals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildKPITab(), _buildGoalsTab()],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (ctx, _) => FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => _tabController.index == 0
              ? _showAddKPIDialog()
              : _showAddGoalDialog(),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            _tabController.index == 0 ? 'Add KPI' : 'Add Goal',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ─── KPI Tab ────────────────────────────────────────────────────────────────

  Widget _buildKPITab() {
    final totalWeight = _kpis.fold<double>(0, (sum, k) => sum + k.weight);
    return Column(
      children: [
        _buildWeightSummary(totalWeight, AppColors.secondary),
        Expanded(
          child: ListView.builder(
            cacheExtent: 1000,
            padding: const EdgeInsets.all(16),
            itemCount: _kpis.length,
            itemBuilder: (ctx, i) => _buildKPICard(_kpis[i], i),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightSummary(double total, Color color) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: total == 100 ? AppColors.successLight : AppColors.warningLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: total == 100 ? AppColors.success : AppColors.warning,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            total == 100 ? Icons.check_circle : Icons.warning_amber_rounded,
            color: total == 100 ? AppColors.success : AppColors.warning,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Total Weight: ${total.toInt()}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: total == 100 ? AppColors.success : AppColors.warning,
            ),
          ),
          const Spacer(),
          if (total != 100)
            Text(
              'Must equal 100%',
              style: TextStyle(fontSize: 11, color: AppColors.warning),
            ),
        ],
      ),
    );
  }

  Widget _buildKPICard(KPI kpi, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${kpi.weight.toInt()}%',
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
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
                  kpi.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  kpi.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.drag_indicator, color: AppColors.textHint),
        ],
      ),
    );
  }

  // ─── Goals Tab ──────────────────────────────────────────────────────────────

  Widget _buildGoalsTab() {
    final totalWeight = _goals.fold<double>(0, (sum, g) => sum + g.weight);
    return Column(
      children: [
        _buildWeightSummary(totalWeight, AppColors.primary),
        Expanded(
          child: ListView.builder(
            cacheExtent: 1000,
            padding: const EdgeInsets.all(16),
            itemCount: _goals.length,
            itemBuilder: (ctx, i) => _buildGoalCard(_goals[i], i),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(Goal goal, int index) {
    final kpi = _kpis.firstWhere(
      (k) => k.id == goal.kpiId,
      orElse: () => _kpis.first,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${goal.weight.toInt()}%',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            goal.description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _chip(Icons.flag_outlined, kpi.name, AppColors.secondary),
              const SizedBox(width: 8),
              _chip(
                Icons.calendar_today_outlined,
                '${goal.startDate} → ${goal.endDate}',
                AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: color)),
      ],
    );
  }

  // ─── Dialogs ────────────────────────────────────────────────────────────────

  void _showAddKPIDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    double weight = 10;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Add KPI'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'KPI Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Weight: ${weight.toInt()}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Slider(
                        value: weight,
                        min: 5,
                        max: 50,
                        divisions: 9,
                        activeColor: AppColors.secondary,
                        onChanged: (v) => setS(() => weight = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  setState(() {
                    _kpis.add(
                      KPI(
                        id: 'k${_kpis.length + 1}',
                        name: nameCtrl.text,
                        description: descCtrl.text,
                        weight: weight,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGoalDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    double weight = 10;
    String selectedKpiId = _kpis.first.id;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Add Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Goal Title'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      'Weight: ${weight.toInt()}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Slider(
                        value: weight,
                        min: 5,
                        max: 50,
                        divisions: 9,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setS(() => weight = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  setState(() {
                    _goals.add(
                      Goal(
                        id: 'g${_goals.length + 1}',
                        title: titleCtrl.text,
                        description: descCtrl.text,
                        weight: weight,
                        startDate: '01 Jan 2024',
                        endDate: '31 Dec 2024',
                        kpiId: selectedKpiId,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeInputScreen extends StatefulWidget {
  EmployeeInputScreen({super.key});

  // Shared goals state - in a real app this would be shared properly
  final List<Goal> goals = DummyData.buildGoals();

  @override
  State<EmployeeInputScreen> createState() => _EmployeeInputScreenState();
}

class _EmployeeInputScreenState extends State<EmployeeInputScreen> {
  late List<TextEditingController> _commentControllers;

  @override
  void initState() {
    super.initState();
    _commentControllers = widget.goals
        .map((g) => TextEditingController(text: g.employeeComment))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _commentControllers) {
      c.dispose();
    }
    super.dispose();
  }

  double _calculateOverallProgress() {
    double totalWeight = widget.goals.fold(0, (s, g) => s + g.weight);
    if (totalWeight == 0) return 0;
    double weightedSum = widget.goals.fold(
      0,
      (s, g) => s + (g.employeeProgress * g.weight / 100),
    );
    return weightedSum / totalWeight * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Goals – Employee Input',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.appGradient),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        cacheExtent: 1000,
        padding: const EdgeInsets.all(16),
        children: [
          RepaintBoundary(child: _buildOverallProgressCard()),
          const SizedBox(height: 16),
          ...widget.goals.asMap().entries.map(
            (entry) => _buildGoalCard(entry.key, entry.value),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _submit,
        icon: const Icon(Icons.send_rounded, color: Colors.white),
        label: const Text(
          'Submit to Manager',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOverallProgressCard() {
    final overall = _calculateOverallProgress();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.info, AppColors.info.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overall Goal Progress',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${overall.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'weighted average',
                  style: TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: overall / 100,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(int index, Goal goal) {
    final statusColor = _getStatusColor(goal.employeeProgress);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.track_changes,
                    color: statusColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        goal.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Wt: ${goal.weight.toInt()}%',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Slider + progress
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'My Progress',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${goal.employeeProgress.toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: statusColor,
                    inactiveTrackColor: statusColor.withOpacity(0.15),
                    thumbColor: statusColor,
                    overlayColor: statusColor.withOpacity(0.1),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: goal.employeeProgress,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: (v) {
                      setState(() {
                        goal.employeeProgress = v;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Comment
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: TextField(
              controller: _commentControllers[index],
              onChanged: (v) => goal.employeeComment = v,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Add a comment about your progress...',
                hintStyle: TextStyle(fontSize: 12, color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: statusColor, width: 1.5),
                ),
                prefixIcon: Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: AppColors.textHint,
                ),
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(double progress) {
    if (progress >= 75) return AppColors.success;
    if (progress >= 40) return AppColors.warning;
    return AppColors.error;
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Progress submitted to manager successfully!'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Manager Review Screen  –  ALL-IN-ONE unified manager evaluation screen
// ─────────────────────────────────────────────────────────────────────────────

class ManagerReviewScreen extends StatefulWidget {
  ManagerReviewScreen({super.key});

  @override
  State<ManagerReviewScreen> createState() => _ManagerReviewScreenState();
}

class _ManagerReviewScreenState extends State<ManagerReviewScreen> {
  // ── Data ──────────────────────────────────────────────────────────────────
  final Employee _employee = DummyData.employee;
  final List<Goal> _goals = DummyData.buildGoals();
  final List<HR360Item> _hrItems = DummyData.buildHR360Items();
  final AttendanceData _attendance = DummyData.attendance;

  // ── Section collapse state ────────────────────────────────────────────────
  bool _goalsExpanded = false;
  bool _hrExpanded = false;
  bool _attendanceExpanded = false;
  bool _finalExpanded = false;
  bool _objectivesExpanded = true;

  // ── Manager comment controllers ───────────────────────────────────────────
  late List<TextEditingController> _goalCommentControllers;
  late List<TextEditingController> _hrCommentControllers;
  final TextEditingController _finalCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _goalCommentControllers = _goals
        .map((g) => TextEditingController(text: g.managerComment))
        .toList();
    _hrCommentControllers = _hrItems
        .map((h) => TextEditingController(text: h.comment))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _goalCommentControllers) c.dispose();
    for (final c in _hrCommentControllers) c.dispose();
    _finalCommentController.dispose();
    super.dispose();
  }

  // ── Score Calculations ────────────────────────────────────────────────────

  double get _goalsScore {
    final totalWeight = _goals.fold<double>(0, (s, g) => s + g.weight);
    if (totalWeight == 0) return 0;
    final weighted = _goals.fold<double>(
      0,
      (s, g) => s + (g.managerProgress * g.weight / 100),
    );
    return (weighted / totalWeight) * 100;
  }

  double get _hrScore {
    final avg =
        _hrItems.fold<double>(0, (s, h) => s + h.rating) / _hrItems.length;
    return (avg / 5) * 100;
  }

  double get _attendanceScore => _attendance.score;

  double get _objectivesScore => 92.5; // High performance demo score

  double get _finalScore =>
      (_objectivesScore * 0.2) + // Company Objectives: 20%
      (_goalsScore * 0.6) + // Goals Assessment: 60%
      (_hrScore * 0.1) + // HR 360: 10%
      (_attendanceScore * 0.1); // Attendance: 10%

  String get _finalStatus {
    if (_finalScore >= 80) return 'Excellent';
    if (_finalScore >= 65) return 'Good';
    if (_finalScore >= 50) return 'Average';
    return 'Needs Improvement';
  }

  Color get _finalStatusColor {
    if (_finalScore >= 80) return AppColors.success;
    if (_finalScore >= 65) return AppColors.info;
    if (_finalScore >= 50) return AppColors.warning;
    return AppColors.error;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Manager Review',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.appGradient),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Score: ${_finalScore.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        cacheExtent: 1000,
        padding: const EdgeInsets.all(16),
        children: [
          RepaintBoundary(child: _buildScoreOverview()),
          const SizedBox(height: 16),

          // ── Objectives Section ──────────────────────────────────────────
          _buildSectionHeader(
            'Company Objectives',
            '20% weight',
            Icons.ads_click,
            AppColors.info,
            _objectivesExpanded,
            () => setState(() => _objectivesExpanded = !_objectivesExpanded),
            '${_objectivesScore.toStringAsFixed(1)}%',
          ),
          RepaintBoundary(
            child: AnimatedCrossFade(
              firstChild: _buildObjectivesSection(),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _objectivesExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
          ),

          const SizedBox(height: 8),

          // ── Goals Section ─────────────────────────────────────────────
          _buildSectionHeader(
            'Goals Assessment',
            '60% weight',
            Icons.track_changes_rounded,
            AppColors.primary,
            _goalsExpanded,
            () => setState(() => _goalsExpanded = !_goalsExpanded),
            '${_goalsScore.toStringAsFixed(1)}%',
          ),
          RepaintBoundary(
            child: AnimatedCrossFade(
              firstChild: _buildGoalsSection(),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _goalsExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
          ),

          const SizedBox(height: 8),

          // ── HR 360 Section ────────────────────────────────────────────
          _buildSectionHeader(
            'HR 360° Evaluation',
            '10% weight',
            Icons.people_alt_rounded,
            AppColors.secondary,
            _hrExpanded,
            () => setState(() => _hrExpanded = !_hrExpanded),
            '${_hrScore.toStringAsFixed(1)}%',
          ),
          RepaintBoundary(
            child: AnimatedCrossFade(
              firstChild: _buildHRSection(),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _hrExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
          ),

          const SizedBox(height: 8),

          // ── Attendance Section ────────────────────────────────────────
          _buildSectionHeader(
            'Attendance',
            '10% weight',
            Icons.calendar_month_rounded,
            AppColors.success,
            _attendanceExpanded,
            () => setState(() => _attendanceExpanded = !_attendanceExpanded),
            '${_attendanceScore.toStringAsFixed(0)}%',
          ),
          RepaintBoundary(
            child: AnimatedCrossFade(
              firstChild: _buildAttendanceSection(),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _attendanceExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
          ),

          const SizedBox(height: 8),

          // ── Final Section ─────────────────────────────────────────────
          _buildSectionHeader(
            'Final Evaluation',
            'Submit',
            Icons.done_all_rounded,
            _finalStatusColor,
            _finalExpanded,
            () => setState(() => _finalExpanded = !_finalExpanded),
            _finalStatus,
          ),
          RepaintBoundary(
            child: AnimatedCrossFade(
              firstChild: _buildFinalSection(),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _finalExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ─── Employee Header ───────────────────────────────────────────────────────

  // ─── Score Overview ────────────────────────────────────────────────────────

  Widget _buildScoreOverview() {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            _finalStatusColor,
            _finalStatusColor.withBlue(255).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _finalStatusColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Decorative Background elements
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Left Side: Main Score
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'FINAL SCORE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _finalScore.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _finalStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  color: Colors.white24,
                  width: 32,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                // Right Side: Weights
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _optimizedScoreBar(
                        'Company Objectives (20%)',
                        _objectivesScore,
                      ),
                      const SizedBox(height: 10),
                      _optimizedScoreBar('Goals Assessment (60%)', _goalsScore),
                      const SizedBox(height: 10),
                      _optimizedScoreBar('HR 360° Evaluation (10%)', _hrScore),
                      const SizedBox(height: 10),
                      _optimizedScoreBar(
                        'Attendance Record (10%)',
                        _attendanceScore,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optimizedScoreBar(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${value.toInt()}%',
              style: const TextStyle(
                fontSize: 9,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (value / 100).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Section Header ────────────────────────────────────────────────────────

  Widget _buildSectionHeader(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isExpanded,
    VoidCallback onToggle,
    String badge,
  ) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.cardShadow,
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Objectives Section ───────────────────────────────────────────────────

  Widget _buildObjectivesSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: DummyData.objectives.asMap().entries.map((e) {
          final obj = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.info,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    obj.title,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Goals Section ─────────────────────────────────────────────────────────

  Widget _buildGoalsSection() {
    return Column(
      children: [
        ..._goals.asMap().entries.map(
          (e) => _buildGoalReviewCard(e.key, e.value),
        ),
        _buildGoalsTotalCard(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildGoalReviewCard(int index, Goal goal) {
    final empProgress = goal.employeeProgress;
    final mgrProgress = goal.managerProgress;
    final statusColor = _progressColor(mgrProgress);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Weight: ${goal.weight.toInt()}%',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Employee progress (read-only)
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person_outlined,
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Employee Input',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${empProgress.toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: empProgress / 100,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.textSecondary,
                    ),
                    minHeight: 5,
                  ),
                ),
                if (goal.employeeComment.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.format_quote,
                        size: 12,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          goal.employeeComment,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Manager progress slider
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.manage_accounts_outlined,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Manager Rating',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${mgrProgress.toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: statusColor,
                    inactiveTrackColor: statusColor.withOpacity(0.15),
                    thumbColor: statusColor,
                    overlayColor: statusColor.withOpacity(0.1),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                  ),
                  child: Slider(
                    value: mgrProgress,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: (v) {
                      setState(() {
                        goal.managerProgress = v;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Manager comment
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: TextField(
              controller: _goalCommentControllers[index],
              onChanged: (v) => goal.managerComment = v,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Manager comment...',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
                isDense: true,
                prefixIcon: const Icon(
                  Icons.edit_outlined,
                  size: 14,
                  color: AppColors.textHint,
                ),
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsTotalCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calculate_outlined,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 10),
          const Text(
            'Goals Total Score',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            '${_goalsScore.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ─── HR 360 Section ────────────────────────────────────────────────────────

  Widget _buildHRSection() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: _hrItems.asMap().entries.map((e) {
              return _buildHRRow(e.key, e.value);
            }).toList(),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star_half_rounded,
                color: AppColors.secondary,
                size: 18,
              ),
              const SizedBox(width: 10),
              const Text(
                'HR 360° Score',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Text(
                '${_hrScore.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHRRow(int index, HR360Item item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nameAr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      item.nameEn,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Star rating
              Row(
                children: List.generate(5, (star) {
                  final filled = star < item.rating;
                  return GestureDetector(
                    onTap: () => setState(() => item.rating = star + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(
                        filled
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: filled ? AppColors.warning : AppColors.textHint,
                        size: 26,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _hrCommentControllers[index],
            onChanged: (v) => item.comment = v,
            style: const TextStyle(fontSize: 11),
            decoration: InputDecoration(
              hintText: 'Optional comment...',
              hintStyle: const TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
              ),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.secondary,
                  width: 1.5,
                ),
              ),
              isDense: true,
            ),
          ),
          if (index < _hrItems.length - 1)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Divider(color: AppColors.border, height: 1),
            ),
        ],
      ),
    );
  }

  // ─── Attendance Section ────────────────────────────────────────────────────

  Widget _buildAttendanceSection() {
    final att = _attendance;
    final pct = att.attendancePercent;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          // Stats row
          Row(
            children: [
              _attStat(
                'Total Days',
                '${att.totalDays}',
                AppColors.textSecondary,
              ),
              _attDivider(),
              _attStat('Present', '${att.present}', AppColors.success),
              _attDivider(),
              _attStat('Absent', '${att.absent}', AppColors.error),
              _attDivider(),
              _attStat('Late', '${att.late}', AppColors.warning),
            ],
          ),
          const SizedBox(height: 20),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Attendance Rate',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${pct.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: pct / 100,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    pct >= 90
                        ? AppColors.success
                        : pct >= 75
                        ? AppColors.warning
                        : AppColors.error,
                  ),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _progressLabel(
                    'Score',
                    '${att.score.toStringAsFixed(0)}%',
                    AppColors.success,
                  ),
                  _progressLabel(
                    'Status',
                    pct >= 90
                        ? 'Excellent'
                        : pct >= 75
                        ? 'Good'
                        : 'Poor',
                    pct >= 90
                        ? AppColors.success
                        : pct >= 75
                        ? AppColors.warning
                        : AppColors.error,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attStat(String label, String value, Color color) {
    return Expanded(
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
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _attDivider() {
    return Container(height: 40, width: 1, color: AppColors.border);
  }

  Widget _progressLabel(String label, String value, Color color) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // ─── Final Section ─────────────────────────────────────────────────────────

  Widget _buildFinalSection() {
    return Column(
      children: [
        // Premium Score Card
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppColors.cardShadow,
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              // Formula Breakdown Header
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Calculation Breakdown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Formula Rows
              _formulaRow(
                'Company Objectives (×0.2)',
                _objectivesScore * 0.2,
                AppColors.info,
              ),
              const SizedBox(height: 10),
              _formulaRow(
                'Goals Assessment (×0.6)',
                _goalsScore * 0.6,
                AppColors.primary,
              ),
              const SizedBox(height: 10),
              _formulaRow(
                'HR 360° Evaluation (×0.1)',
                _hrScore * 0.1,
                AppColors.secondary,
              ),
              const SizedBox(height: 10),
              _formulaRow(
                'Attendance Record (×0.1)',
                _attendanceScore * 0.1,
                AppColors.success,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(height: 1),
              ),
              // Result Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Performance Result',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _finalStatus,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: _finalStatusColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _finalScore.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Manager Final Comment Card
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.comment_bank_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Final Evaluation Summary',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _finalCommentController,
                style: const TextStyle(fontSize: 14, height: 1.5),
                decoration: InputDecoration(
                  hintText: 'Provide overall feedback and next steps...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.textHint.withOpacity(0.7),
                  ),
                  filled: true,
                  fillColor: AppColors.background.withOpacity(0.5),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),

        // Submission Control
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            onPressed: _submitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.4),
            ),
            icon: const Icon(Icons.verified_user_rounded, size: 22),
            label: const Text(
              'COMPLETE PERFORMANCE REVIEW',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _formulaRow(String label, double value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _progressColor(double progress) {
    if (progress >= 75) return AppColors.success;
    if (progress >= 40) return AppColors.warning;
    return AppColors.error;
  }

  void _submitReview() {
    if (_finalCommentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('Please add a final comment before submitting.'),
            ],
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.success,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Review Submitted!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Performance review for ${_employee.name} has been submitted successfully.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _finalStatusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Final Score: ${_finalScore.toStringAsFixed(1)} – $_finalStatus',
                    style: TextStyle(
                      color: _finalStatusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
