import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class AppColors {
  static const Color primary = Color(0xFF1B432C);
  static const Color darkTeal = Color(0xFF0D2116);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFBC02D);
  static const Color error = Color(0xFFD32F2F);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color black = Color(0xFF212121);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkDivider = Color(0xFF3A3A3A);
  static const Color darkSecText = Color(0xFF9E9E9E);
  static Color successBg(bool dark) =>
      dark ? const Color(0xFF1B3A1C) : const Color(0xFFE8F5E9);
  static Color warningBg(bool dark) =>
      dark ? const Color(0xFF3A2E0A) : const Color(0xFFFFF8E1);
  static Color errorBg(bool dark) =>
      dark ? const Color(0xFF3A1212) : const Color(0xFFFFEBEE);
}
// ─── Enums & Models ───────────────────────────────────────────────────────────

enum AttendanceStatus { present, late, absent, weekend, future }

class AttendanceRecord {
  final DateTime date;
  final AttendanceStatus status;
  final String note;
  final String? checkInTime;

  const AttendanceRecord({
    required this.date,
    required this.status,
    required this.note,
    this.checkInTime,
  });
}

// ─── Dummy data generator ─────────────────────────────────────────────────────

Map<DateTime, AttendanceStatus> generateMonthData(int year, int month) {
  final now = DateTime.now();
  final daysInMonth = DateUtils.getDaysInMonth(year, month);
  final result = <DateTime, AttendanceStatus>{};

  for (int d = 1; d <= daysInMonth; d++) {
    final date = DateTime(year, month, d);
    if (date.isAfter(now)) continue;
    if (date.weekday == DateTime.friday || date.weekday == DateTime.saturday) {
      result[date] = AttendanceStatus.weekend;
      continue;
    }
    final rng = Random(date.millisecondsSinceEpoch ~/ 86400000);
    // Manually assign some days to ensure visible variety
    // present ~65%, late ~20%, absent ~15%
    final r = rng.nextInt(100);
    if (r < 65) {
      result[date] = AttendanceStatus.present;
    } else if (r < 85)
      result[date] = AttendanceStatus.late;
    else
      result[date] = AttendanceStatus.absent;
  }
  return result;
}

List<AttendanceRecord> generateHistory() {
  final now = DateTime.now();
  final records = <AttendanceRecord>[];
  const notes = {
    AttendanceStatus.present: [
      'On time',
      'Checked in early',
      'Arrived on time',
    ],
    AttendanceStatus.late: [
      'Traffic delay',
      'Arrived 15 min late',
      'Arrived 30 min late',
    ],
    AttendanceStatus.absent: ['Sick leave', 'Unexcused', 'Annual leave'],
  };
  const times = {
    AttendanceStatus.present: ['08:02', '07:58', '08:00', '07:55'],
    AttendanceStatus.late: ['08:32', '09:10', '08:47'],
    AttendanceStatus.absent: null,
  };

  for (int i = 0; i < 60; i++) {
    final date = now.subtract(Duration(days: i));
    if (date.weekday == DateTime.friday || date.weekday == DateTime.saturday) {
      continue;
    }
    final rng = Random(date.millisecondsSinceEpoch ~/ 86400000);
    final r = rng.nextInt(100);
    AttendanceStatus status;
    if (r < 65) {
      status = AttendanceStatus.present;
    } else if (r < 85)
      status = AttendanceStatus.late;
    else
      status = AttendanceStatus.absent;

    final noteList = notes[status]!;
    final timeList = times[status];
    final noteIdx = i % noteList.length;
    records.add(
      AttendanceRecord(
        date: date,
        status: status,
        note: noteList[noteIdx],
        checkInTime: timeList != null ? timeList[i % timeList.length] : null,
      ),
    );
    if (records.length >= 10) break;
  }
  return records;
}

// ─── Main Widget ──────────────────────────────────────────────────────────────

class AttendanceCalendarScreen extends StatefulWidget {
  const AttendanceCalendarScreen({super.key});

  @override
  State<AttendanceCalendarScreen> createState() =>
      _AttendanceCalendarScreenState();
}

class _AttendanceCalendarScreenState extends State<AttendanceCalendarScreen> {
  late int _viewYear;
  late int _viewMonth;
  DateTime? _selectedDate;
  late Map<DateTime, AttendanceStatus> _monthData;
  late List<AttendanceRecord> _history;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _viewYear = now.year;
    _viewMonth = now.month;
    _selectedDate = DateTime(now.year, now.month, now.day);
    _loadData();
  }

  void _loadData() {
    _monthData = generateMonthData(_viewYear, _viewMonth);
    _history = generateHistory();
  }

  void _changeMonth(int dir) {
    setState(() {
      _viewMonth += dir;
      if (_viewMonth > 12) {
        _viewMonth = 1;
        _viewYear++;
      }
      if (_viewMonth < 1) {
        _viewMonth = 12;
        _viewYear--;
      }
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: _CalendarCard(
              viewYear: _viewYear,
              viewMonth: _viewMonth,
              monthData: _monthData,
              selectedDate: _selectedDate,
              isDark: isDark,
              onMonthChanged: _changeMonth,
              onDaySelected: (date) => setState(() => _selectedDate = date),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            child: _HistoryCard(records: _history, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

// ─── Calendar Card ────────────────────────────────────────────────────────────

class _CalendarCard extends StatelessWidget {
  final int viewYear, viewMonth;
  final Map<DateTime, AttendanceStatus> monthData;
  final DateTime? selectedDate;
  final bool isDark;
  final void Function(int) onMonthChanged;
  final void Function(DateTime) onDaySelected;

  const _CalendarCard({
    required this.viewYear,
    required this.viewMonth,
    required this.monthData,
    required this.selectedDate,
    required this.isDark,
    required this.onMonthChanged,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    // Stats
    int present = 0, late = 0, absent = 0, workdays = 0;
    for (final s in monthData.values) {
      if (s == AttendanceStatus.present) {
        present++;
        workdays++;
      } else if (s == AttendanceStatus.late) {
        late++;
        workdays++;
      } else if (s == AttendanceStatus.absent) {
        absent++;
        workdays++;
      }
    }
    final rate = workdays > 0 ? ((present + late) / workdays * 100).round() : 0;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.black,
                    ),
                  ),
                  Text(
                    '${monthNames[viewMonth - 1]} $viewYear',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkSecText : AppColors.grey,
                    ),
                  ),
                ],
              ),
              // Nav buttons
              Row(
                children: [
                  _NavButton(
                    icon: Icons.chevron_left,
                    isDark: isDark,
                    onTap: () => onMonthChanged(-1),
                  ),
                  const SizedBox(width: 6),
                  _NavButton(
                    icon: Icons.chevron_right,
                    isDark: isDark,
                    onTap: () => onMonthChanged(1),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats
          Row(
            children: [
              _StatBox(
                label: 'Present',
                value: '$present',
                color: AppColors.success,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _StatBox(
                label: 'Late',
                value: '$late',
                color: AppColors.warning,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _StatBox(
                label: 'Absent',
                value: '$absent',
                color: AppColors.error,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _StatBox(
                label: 'Rate',
                value: '$rate%',
                color: AppColors.primary,
                isDark: isDark,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Day headers
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkSecText
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 8),

          // Calendar grid
          _CalendarGrid(
            viewYear: viewYear,
            viewMonth: viewMonth,
            monthData: monthData,
            selectedDate: selectedDate,
            isDark: isDark,
            onDaySelected: onDaySelected,
          ),

          const SizedBox(height: 12),

          // Legend
          Row(
            children: [
              _LegendItem(
                label: 'Present',
                color: AppColors.success,
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _LegendItem(
                label: 'Late',
                color: AppColors.warning,
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _LegendItem(
                label: 'Absent',
                color: AppColors.error,
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _LegendItem(
                label: 'Weekend',
                color: isDark ? AppColors.darkDivider : AppColors.lightGrey,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Calendar Grid ────────────────────────────────────────────────────────────

class _CalendarGrid extends StatelessWidget {
  final int viewYear, viewMonth;
  final Map<DateTime, AttendanceStatus> monthData;
  final DateTime? selectedDate;
  final bool isDark;
  final void Function(DateTime) onDaySelected;

  const _CalendarGrid({
    required this.viewYear,
    required this.viewMonth,
    required this.monthData,
    required this.selectedDate,
    required this.isDark,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(viewYear, viewMonth, 1);
    final daysInMonth = DateUtils.getDaysInMonth(viewYear, viewMonth);
    final startOffset = firstDay.weekday % 7; // Sunday = 0

    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: List.generate(7, (col) {
              final cellIndex = row * 7 + col;
              final day = cellIndex - startOffset + 1;

              if (day < 1 || day > daysInMonth) {
                return const Expanded(child: SizedBox());
              }

              final date = DateTime(viewYear, viewMonth, day);
              final status = monthData[date];
              final isToday = DateUtils.isSameDay(date, now);
              final isSelected =
                  selectedDate != null &&
                  DateUtils.isSameDay(date, selectedDate!);
              final isFuture = date.isAfter(now);

              return Expanded(
                child: GestureDetector(
                  onTap: isFuture ? null : () => onDaySelected(date),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.all(2),
                    height: 36,
                    decoration: BoxDecoration(
                      color: _cellColor(status, isDark),
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : isToday
                          ? Border.all(color: AppColors.primary, width: 1.5)
                          : Border.all(color: Colors.transparent),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isToday
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: _cellTextColor(status, isFuture, isDark),
                          ),
                        ),
                        if (status != null &&
                            status != AttendanceStatus.weekend &&
                            status != AttendanceStatus.future)
                          Positioned(
                            bottom: 3,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: _dotColor(status),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Color _cellColor(AttendanceStatus? status, bool dark) {
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.successBg(dark);
      case AttendanceStatus.late:
        return AppColors.warningBg(dark);
      case AttendanceStatus.absent:
        return AppColors.errorBg(dark);
      case AttendanceStatus.weekend:
        return dark
            ? AppColors.darkDivider.withOpacity(0.4)
            : const Color(0xFFF5F5F5);
      default:
        return Colors.transparent;
    }
  }

  Color _cellTextColor(AttendanceStatus? status, bool future, bool dark) {
    if (future) return dark ? Colors.white24 : Colors.black26;
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.success;
      case AttendanceStatus.late:
        return AppColors.warning;
      case AttendanceStatus.absent:
        return AppColors.error;
      case AttendanceStatus.weekend:
        return dark ? AppColors.darkSecText : AppColors.grey;
      default:
        return dark ? Colors.white54 : AppColors.black.withOpacity(0.6);
    }
  }

  Color _dotColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.success;
      case AttendanceStatus.late:
        return AppColors.warning;
      case AttendanceStatus.absent:
        return AppColors.error;
      default:
        return Colors.transparent;
    }
  }
}

// ─── History Card ─────────────────────────────────────────────────────────────

class _HistoryCard extends StatelessWidget {
  final List<AttendanceRecord> records;
  final bool isDark;

  const _HistoryCard({required this.records, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance history',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Recent activity log',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkSecText : AppColors.grey,
            ),
          ),
          const SizedBox(height: 12),
          ...records.asMap().entries.map((entry) {
            return FadeInLeft(
              delay: Duration(milliseconds: 60 * entry.key),
              duration: const Duration(milliseconds: 400),
              child: _HistoryItem(record: entry.value, isDark: isDark),
            );
          }),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final AttendanceRecord record;
  final bool isDark;

  const _HistoryItem({required this.record, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(record.status);
    final bgColor = _statusBg(record.status, isDark);
    final label = _statusLabel(record.status);
    final dateStr = _formatDate(record.date);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Status dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  record.note,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkSecText : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Badge + time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              if (record.checkInTime != null) ...[
                const SizedBox(height: 3),
                Text(
                  record.checkInTime!,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.darkSecText : AppColors.grey,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present:
        return AppColors.success;
      case AttendanceStatus.late:
        return AppColors.warning;
      case AttendanceStatus.absent:
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  Color _statusBg(AttendanceStatus s, bool dark) {
    switch (s) {
      case AttendanceStatus.present:
        return AppColors.successBg(dark);
      case AttendanceStatus.late:
        return AppColors.warningBg(dark);
      case AttendanceStatus.absent:
        return AppColors.errorBg(dark);
      default:
        return Colors.transparent;
    }
  }

  String _statusLabel(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.absent:
        return 'Absent';
      default:
        return '';
    }
  }

  String _formatDate(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }
}

// ─── Small Reusable Widgets ───────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkDivider : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.darkDivider : const Color(0xFFEEEEEE),
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDark ? Colors.white70 : AppColors.black,
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  final bool isDark;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkDivider.withOpacity(0.5)
              : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.darkSecText : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const _LegendItem({
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? AppColors.darkSecText : AppColors.grey,
          ),
        ),
      ],
    );
  }
}

// ─── Entry point ──────────────────────────────────────────────────────────────

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: SafeArea(child: AttendanceCalendarScreen()),
      ),
    ),
  );
}
