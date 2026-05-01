import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:Panda/core/theme/app_colors.dart';

// ─── Data Model ───────────────────────────────────────────────────────────────

class EmployeePerformance {
  final String name;
  final String role;
  final String department;
  final int score;
  final int tasks;
  final int projects;
  final int awards;
  final int rank;
  final String initials;
  final Color avatarColor;
  final String? imagePath;
  final List<String> tags;

  const EmployeePerformance({
    required this.name,
    required this.role,
    required this.department,
    required this.score,
    required this.tasks,
    required this.projects,
    required this.awards,
    required this.rank,
    required this.initials,
    required this.avatarColor,
    this.imagePath,
    required this.tags,
  });
}

// ─── Sample Data ──────────────────────────────────────────────────────────────

const _employees = [
  EmployeePerformance(
    name: 'Fahad Al-Qahtani',
    role: 'Store Manager',
    department: 'Retail Operations',
    score: 97,
    tasks: 52,
    projects: 10,
    awards: 3,
    rank: 1,
    initials: 'FQ',
    avatarColor: Color(0xFF2E7D32),
    imagePath: 'assets/images/people/download (1).jpeg',
    tags: ['Leadership', 'Operations'],
  ),
  EmployeePerformance(
    name: 'Sara Al-Harbi',
    role: 'Supply Chain Supervisor',
    department: 'Logistics',
    score: 94,
    tasks: 45,
    projects: 8,
    awards: 2,
    rank: 2,
    initials: 'SH',
    avatarColor: Color(0xFFEF6C00),
    imagePath: 'assets/images/people/25b9c99d1a7f5bcc86d09ee85d82ee02.jpg',
    tags: ['Inventory', 'Logistics'],
  ),
  EmployeePerformance(
    name: 'Abdulrahman Al-Dossari',
    role: 'Branch Supervisor',
    department: 'Retail Operations',
    score: 91,
    tasks: 40,
    projects: 7,
    awards: 1,
    rank: 3,
    initials: 'AD',
    avatarColor: Color(0xFF1565C0),
    imagePath: 'assets/images/people/images (1).jpeg',
    tags: ['Customer Service', 'Team Lead'],
  ),
  EmployeePerformance(
    name: 'Nouf Al-Shammari',
    role: 'Visual Merchandiser',
    department: 'Marketing',
    score: 89,
    tasks: 36,
    projects: 9,
    awards: 2,
    rank: 4,
    initials: 'NS',
    avatarColor: Color(0xFFAD1457),
    imagePath: 'assets/images/people/download.jpeg',
    tags: ['Display', 'Creativity'],
  ),
];
// ─── App Colors (from your theme) ─────────────────────────────────────────────

// ─── Main Section Widget ───────────────────────────────────────────────────────

class BestEmployeesSection extends StatelessWidget {
  final bool isDark;

  const BestEmployeesSection({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employees of the month',
                    style: TextStyle(
                      fontFamily:
                          'Georgia', // or use google_fonts: PlayfairDisplay
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.black,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Top performers · October 2024',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.grey,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Horizontal scroll list
        SizedBox(
          height: 320,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
            itemCount: _employees.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return FadeInRight(
                delay: Duration(milliseconds: 80 * index),
                duration: const Duration(milliseconds: 500),
                child: RepaintBoundary(
                  child: _EmployeeCard(
                    employee: _employees[index],
                    isDark: isDark,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Employee Card ─────────────────────────────────────────────────────────────

class _EmployeeCard extends StatefulWidget {
  final EmployeePerformance employee;
  final bool isDark;

  const _EmployeeCard({required this.employee, required this.isDark});

  @override
  State<_EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<_EmployeeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _barController;
  late final Animation<double> _barAnimation;
  bool _isHovered = false;

  bool get isGold => widget.employee.rank == 1;

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _barAnimation = CurvedAnimation(
      parent: _barController,
      curve: Curves.easeOutCubic,
    );
    // Delay bar fill by card index-based delay + small offset
    Future.delayed(Duration(milliseconds: 400 + widget.employee.rank * 80), () {
      if (mounted) _barController.forward();
    });
  }

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 152,
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isGold
                  ? AppColors.secondary.withOpacity(0.5)
                  : (widget.isDark
                        ? AppColors.darkDivider
                        : const Color(0xFFEEEEEE)),
              width: isGold ? 1.5 : 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isGold
                    ? AppColors.secondary.withOpacity(_isHovered ? 0.3 : 0.12)
                    : Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
                blurRadius: isGold ? 18 : 12,
                offset: const Offset(0, 6),
                spreadRadius: isGold && _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Rank badge
              Positioned(
                top: -9,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    gradient: isGold ? AppColors.goldenGradient : null,
                    color: isGold
                        ? null
                        : (widget.isDark
                              ? AppColors.darkDivider
                              : const Color(0xFFEEEEEE)),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '#${widget.employee.rank}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isGold
                          ? Colors.white
                          : (widget.isDark ? Colors.white70 : AppColors.black),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                child: Column(
                  children: [
                    // Avatar area
                    _AvatarSection(employee: widget.employee, isGold: isGold),

                    const SizedBox(height: 10),

                    // Name
                    Text(
                      widget.employee.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: widget.isDark ? Colors.white : AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Role
                    Text(
                      widget.employee.role,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Department badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        widget.employee.department,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Stats row
                    Row(
                      children: [
                        _StatPill(
                          value: '${widget.employee.tasks}',
                          label: 'Tasks',
                          isDark: widget.isDark,
                          isGold: isGold,
                        ),
                        const SizedBox(width: 5),
                        _StatPill(
                          value: '${widget.employee.projects}',
                          label: 'Projects',
                          isDark: widget.isDark,
                          isGold: isGold,
                        ),
                        const SizedBox(width: 5),
                        _StatPill(
                          value: '${widget.employee.awards}',
                          label: 'Awards',
                          isDark: widget.isDark,
                          isGold: isGold,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Performance bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Performance',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: widget.isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.grey,
                              ),
                            ),
                            Text(
                              '${widget.employee.score}%',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: widget.isDark
                                    ? Colors.white
                                    : AppColors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: widget.isDark
                                ? AppColors.darkDivider
                                : const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: AnimatedBuilder(
                            animation: _barAnimation,
                            builder: (context, _) {
                              return FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor:
                                    _barAnimation.value *
                                    widget.employee.score /
                                    100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: isGold
                                        ? AppColors.goldenGradient
                                        : const LinearGradient(
                                            colors: [
                                              AppColors.primary,
                                              AppColors.darkTeal,
                                            ],
                                          ),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Tags
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      alignment: WrapAlignment.center,
                      children: widget.employee.tags
                          .map(
                            (tag) => _TagChip(
                              label: tag,
                              isDark: widget.isDark,
                              isGold: isGold,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Avatar Section (with pulsing ring for #1) ────────────────────────────────

class _AvatarSection extends StatefulWidget {
  final EmployeePerformance employee;
  final bool isGold;

  const _AvatarSection({required this.employee, required this.isGold});

  @override
  State<_AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<_AvatarSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _crownAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _crownAnimation = Tween<double>(begin: 0.0, end: -3.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      width: 72,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Pulsing ring (gold only)
          if (widget.isGold)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, _) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(
                          2 - _pulseAnimation.value,
                        ),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),

          // Avatar circle with gradient border
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.isGold
                  ? AppColors.goldenGradient
                  : LinearGradient(
                      colors: [
                        widget.employee.avatarColor.withOpacity(0.3),
                        widget.employee.avatarColor.withOpacity(0.1),
                      ],
                    ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: widget.employee.avatarColor,
              backgroundImage: widget.employee.imagePath != null
                  ? AssetImage(widget.employee.imagePath!)
                  : null,
              child: widget.employee.imagePath == null
                  ? Text(
                      widget.employee.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    )
                  : null,
            ),
          ),

          // Crown for #1
          if (widget.isGold)
            AnimatedBuilder(
              animation: _crownAnimation,
              builder: (context, _) {
                return Positioned(
                  top: -14 + _crownAnimation.value,
                  child: const Text('👑', style: TextStyle(fontSize: 16)),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ─── Stat Pill ────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;
  final bool isGold;

  const _StatPill({
    required this.value,
    required this.label,
    required this.isDark,
    required this.isGold,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkDivider : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isGold
                    ? const Color(0xFFC08A2A)
                    : (isDark ? Colors.white : AppColors.black),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                fontSize: 8.5,
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tag Chip ─────────────────────────────────────────────────────────────────

class _TagChip extends StatelessWidget {
  final String label;
  final bool isDark;
  final bool isGold;

  const _TagChip({
    required this.label,
    required this.isDark,
    required this.isGold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: isGold
            ? AppColors.secondary.withOpacity(0.08)
            : (isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isGold
              ? AppColors.secondary.withOpacity(0.25)
              : (isDark ? AppColors.darkDivider : const Color(0xFFDDDDDD)),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: isGold
              ? const Color(0xFFC08A2A)
              : (isDark ? AppColors.darkTextSecondary : AppColors.grey),
        ),
      ),
    );
  }
}

// ─── Preview ──────────────────────────────────────────────────────────────────

void main() {
  runApp(const _PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: const BestEmployeesSection(isDark: false),
          ),
        ),
      ),
    );
  }
}
