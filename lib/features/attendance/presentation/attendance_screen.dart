// ─────────────────────────────────────────────────────────────
//  ATTENDANCE SCREEN  —  Face ID / Fingerprint Check-In/Out
// ─────────────────────────────────────────────────────────────
//
//  REQUIRED PACKAGES (add to pubspec.yaml):
//  ─────────────────────────────────────────
//  dependencies:
//    local_auth: ^2.3.0
//    get: ^4.6.6
//    animate_do: ^3.3.4
//
//  ANDROID SETUP (android/app/src/main/AndroidManifest.xml):
//  ─────────────────────────────────────────────────────────
//  <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
//  <uses-permission android:name="android.permission.USE_FINGERPRINT"/>
//
//  Also in android/app/src/main/AndroidManifest.xml inside <activity>:
//  android:launchMode="singleTop"
//
//  In android/app/build.gradle set:
//  minSdkVersion 23
//
//  iOS SETUP (ios/Runner/Info.plist):
//  ───────────────────────────────────
//  <key>NSFaceIDUsageDescription</key>
//  <string>We use Face ID to verify your identity for attendance.</string>
//
// ─────────────────────────────────────────────────────────────
import 'dart:async';
import 'dart:math';
import 'package:Panda/core/theme/app_colors.dart';
import 'package:Panda/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

// ─── App Colors ───────────────────────────────────────────────

// ─── Attendance Status Enum ────────────────────────────────────
enum AttendanceStatus { present, late, absent, weekend }

// ─── Demo Attendance Model ─────────────────────────────────────
class DemoAttendance {
  DateTime? loginTime;
  DateTime? logoutTime;
  DemoAttendance({this.loginTime, this.logoutTime});
}

// ─── Controller ───────────────────────────────────────────────
class AttendanceController extends GetxController {
  final LocalAuthentication _auth = LocalAuthentication();

  DemoAttendance? attendance;

  var spent = '00:00:00'.obs;
  var remainingTime = '08:00:00'.obs;
  var progress = 0.0.obs;
  var lateProgress = 0.0.obs;
  var isLoading = false.obs;
  var scanState = 'idle'.obs; // idle | scanning | checkedin | done
  var feedbackMsg = ''.obs;
  var feedbackType = ''.obs; // '' | 'success' | 'error'
  var biometricAvailable = false.obs;
  var supportedBiometrics = <BiometricType>[].obs;

  // ── Calendar state ──
  var viewYear = DateTime.now().year.obs;
  var viewMonth = DateTime.now().month.obs;
  var monthData = <DateTime, AttendanceStatus>{}.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _checkBiometrics();
    _loadMonthData();
  }

  void _loadMonthData() {
    final year = viewYear.value;
    final month = viewMonth.value;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final data = <DateTime, AttendanceStatus>{};
    final now = DateTime.now();
    final random = Random(year * 100 + month);

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(year, month, i);
      if (date.isAfter(now)) {
        // Future dates don't have status
        continue;
      }
      if (date.weekday == DateTime.friday ||
          date.weekday == DateTime.saturday) {
        data[date] = AttendanceStatus.weekend;
        continue;
      }

      final r = random.nextInt(100);
      if (r < 70) {
        data[date] = AttendanceStatus.present;
      } else if (r < 85) {
        data[date] = AttendanceStatus.late;
      } else {
        data[date] = AttendanceStatus.absent;
      }
    }
    monthData.value = data;
  }

  void changeMonth(int offset) {
    var newMonth = viewMonth.value + offset;
    var newYear = viewYear.value;
    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }
    viewYear.value = newYear;
    viewMonth.value = newMonth;
    _loadMonthData();
  }

  // ── Check device biometric capabilities ──
  Future<void> _checkBiometrics() async {
    try {
      final bool canAuth = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      biometricAvailable.value = canAuth && isDeviceSupported;

      if (biometricAvailable.value) {
        final List<BiometricType> types = await _auth.getAvailableBiometrics();
        supportedBiometrics.value = types;
      }
    } on PlatformException catch (e) {
      biometricAvailable.value = false;
      debugPrint('Biometric check error: $e');
    }
  }

  // ── Determine if device has Face ID ──
  bool get hasFaceId =>
      supportedBiometrics.contains(BiometricType.face) ||
      supportedBiometrics.contains(BiometricType.strong);

  // ── Biometric label for UI ──
  String biometricLabel(AppLocalizations l10n) {
    if (supportedBiometrics.contains(BiometricType.face)) return l10n.faceId;
    if (supportedBiometrics.contains(BiometricType.fingerprint)) {
      return l10n.fingerprint;
    }
    return l10n.biometric;
  }

  // ── Authenticate with Face ID / Fingerprint ──
  Future<bool> _authenticate(String reason) async {
    try {
      scanState.value = 'scanning';
      feedbackMsg.value =
          ''; // Will be set by UI or localized elsewhere if needed
      feedbackType.value = '';

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      return didAuthenticate;
    } on LocalAuthException catch (e) {
      scanState.value = 'idle';
      if (e.code == LocalAuthExceptionCode.noBiometricHardware ||
          e.code == LocalAuthExceptionCode.uiUnavailable) {
        feedbackMsg.value = 'Biometric not available';
      } else if (e.code == LocalAuthExceptionCode.noBiometricsEnrolled) {
        feedbackMsg.value = 'No biometrics enrolled';
      } else if (e.code == LocalAuthExceptionCode.temporaryLockout ||
          e.code == LocalAuthExceptionCode.biometricLockout) {
        feedbackMsg.value =
            'Too many attempts. Try later'; // Will be handled by UI l10n if needed
      } else {
        feedbackMsg.value = 'Authentication cancelled';
      }
      feedbackType.value = 'error';
      update();
      return false;
    }
  }

  // ── Check-In ──
  Future<void> checkIn(AppLocalizations l10n) async {
    if (isLoading.value) return;
    isLoading.value = true;

    final bool success = await _authenticate(l10n.biometricReason);

    if (success) {
      attendance = DemoAttendance(loginTime: DateTime.now());
      scanState.value = 'checkedin';
      feedbackMsg.value = '✓ ${l10n.checkInSuccess}';
      feedbackType.value = 'success';
      _startTimer();
      Get.snackbar(
        l10n.checkInSuccessful,
        l10n.welcomeDayMessage,
        backgroundColor: AppColors.successLight,
        colorText: AppColors.success,
        icon: const Icon(Icons.check_circle, color: AppColors.success),
        duration: const Duration(seconds: 3),
      );
    } else {
      scanState.value = 'idle';
    }

    isLoading.value = false;
    update();
  }

  // ── Check-Out ──
  Future<void> checkOut(AppLocalizations l10n) async {
    if (isLoading.value) return;
    isLoading.value = true;

    final bool success = await _authenticate(l10n.biometricReason);

    if (success) {
      attendance?.logoutTime = DateTime.now();
      scanState.value = 'done';
      feedbackMsg.value = '✓ Check-out recorded successfully';
      feedbackType.value = 'success';
      _stopTimer();

      // Final hours calculation
      if (attendance?.loginTime != null) {
        final diff = attendance!.logoutTime!.difference(attendance!.loginTime!);
        spent.value = _formatDuration(diff);
      }

      remainingTime.value = '00:00:00';
      progress.value = 1.0;

      Get.snackbar(
        'Check-Out Successful',
        'Great work today! See you tomorrow.',
        backgroundColor: AppColors.primaryLight,
        colorText: AppColors.primary,
        icon: const Icon(Icons.logout, color: AppColors.primary),
        duration: const Duration(seconds: 3),
      );
    } else {
      scanState.value = 'checkedin';
    }

    isLoading.value = false;
    update();
  }

  // ── Live Timer ──
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (attendance?.loginTime == null) return;

      final now = DateTime.now();
      final login = attendance!.loginTime!;
      final spentDur = now.difference(login);
      spent.value = _formatDuration(spentDur);

      // Late progress (red) — minutes after 9:00 AM
      final nineAm = DateTime(now.year, now.month, now.day, 9, 0);
      const totalWorkSec = 8 * 3600;

      if (login.isAfter(nineAm)) {
        final lateDur = login.difference(nineAm);
        lateProgress.value = (lateDur.inSeconds / totalWorkSec).clamp(0.0, 1.0);
      } else {
        lateProgress.value = 0.0;
      }

      // Work progress (green)
      final workProg = (spentDur.inSeconds / totalWorkSec).clamp(0.0, 1.0);
      progress.value = (lateProgress.value + workProg).clamp(0.0, 1.0);

      // Remaining time until 5 PM
      final fivePM = DateTime(now.year, now.month, now.day, 17, 0);
      if (now.isBefore(fivePM)) {
        remainingTime.value = _formatDuration(fivePM.difference(now));
      } else {
        remainingTime.value = '00:00:00';
      }
    });
  }

  void _stopTimer() => _timer?.cancel();

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String get checkInTimeStr {
    if (attendance?.loginTime == null) return '--:--';
    final t = attendance!.loginTime!;
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  String get checkOutTimeStr {
    if (attendance?.logoutTime == null) return '--:--';
    final t = attendance!.logoutTime!;
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}

// ─── Mock History Data ─────────────────────────────────────────
final List<Map<String, dynamic>> _mockHistory = [
  {
    'date': 'Saturday, Apr 25',
    'in': '08:02',
    'out': '17:05',
    'hours': '9h 03m',
    'status': 'present',
  },
  {
    'date': 'Thursday, Apr 24',
    'in': '09:22',
    'out': '17:00',
    'hours': '7h 38m',
    'status': 'late',
  },
  {
    'date': 'Wednesday, Apr 23',
    'in': '07:55',
    'out': '16:58',
    'hours': '9h 03m',
    'status': 'present',
  },
  {
    'date': 'Tuesday, Apr 22',
    'in': '--:--',
    'out': '--:--',
    'hours': '0h 00m',
    'status': 'absent',
  },
  {
    'date': 'Monday, Apr 21',
    'in': '08:10',
    'out': '17:15',
    'hours': '9h 05m',
    'status': 'present',
  },
];

// ─── Main Attendance Screen ────────────────────────────────────
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AttendanceController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.attendance,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDark ? AppColors.darkText : AppColors.darkBg,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkText : AppColors.darkBg,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 0.5,
            color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _HeaderCard(isDark: isDark),
            const SizedBox(height: 12),
            _TimeCard(isDark: isDark, controller: controller),
            const SizedBox(height: 12),
            RepaintBoundary(
              child: _ProgressCard(isDark: isDark, controller: controller),
            ),
            const SizedBox(height: 20),
            RepaintBoundary(
              child: _BiometricSection(isDark: isDark, controller: controller),
            ),
            const SizedBox(height: 20),
            _StatsRow(isDark: isDark),
            const SizedBox(height: 20),
            RepaintBoundary(
              child: _CalendarSection(isDark: isDark, controller: controller),
            ),
            const SizedBox(height: 20),
            _HistorySection(isDark: isDark),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─── Header Card ──────────────────────────────────────────────
class _HeaderCard extends StatelessWidget {
  final bool isDark;
  const _HeaderCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
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
    final dateStr =
        '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(23),
            ),
            child: const Center(
              child: Text(
                'AH',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
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
                  'Ahmed Hassan',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isDark ? AppColors.darkText : AppColors.darkBg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Software Engineer',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkMuted : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              dateStr,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Time Card ────────────────────────────────────────────────
class _TimeCard extends StatelessWidget {
  final bool isDark;
  final AttendanceController controller;
  const _TimeCard({required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
          width: 0.5,
        ),
      ),
      child: GetBuilder<AttendanceController>(
        builder: (c) {
          return Row(
            children: [
              Expanded(
                child: _TimeBox(
                  isDark: isDark,
                  label: AppLocalizations.of(context)!.checkIn.toUpperCase(),
                  value: c.checkInTimeStr,
                  statusText: c.attendance?.loginTime != null
                      ? '✓ ${AppLocalizations.of(context)!.recorded}'
                      : AppLocalizations.of(context)!.waiting,
                  statusColor: c.attendance?.loginTime != null
                      ? AppColors.success
                      : AppColors.grey,
                ),
              ),
              Container(
                width: 0.5,
                height: 50,
                color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
              ),
              Expanded(
                child: _TimeBox(
                  isDark: isDark,
                  label: AppLocalizations.of(context)!.checkOut.toUpperCase(),
                  value: c.checkOutTimeStr,
                  statusText: c.attendance?.logoutTime != null
                      ? '✓ ${AppLocalizations.of(context)!.recorded}'
                      : AppLocalizations.of(context)!.waiting,
                  statusColor: c.attendance?.logoutTime != null
                      ? AppColors.success
                      : AppColors.grey,
                ),
              ),
              Container(
                width: 0.5,
                height: 50,
                color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
              ),
              Expanded(
                child: Obx(
                  () => _TimeBox(
                    isDark: isDark,
                    label: AppLocalizations.of(context)!.hours.toUpperCase(),
                    value: c.spent.value.substring(0, 5),
                    statusText: AppLocalizations.of(context)!.today,
                    statusColor: AppColors.grey,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;
  final String statusText;
  final Color statusColor;

  const _TimeBox({
    required this.isDark,
    required this.label,
    required this.value,
    required this.statusText,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: isDark ? AppColors.darkMuted : AppColors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkText : AppColors.darkBg,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Progress Card ────────────────────────────────────────────
class _ProgressCard extends StatelessWidget {
  final bool isDark;
  final AttendanceController controller;
  const _ProgressCard({required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.workProgress,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkMuted : AppColors.grey,
                ),
              ),
              Obx(
                () => Text(
                  '${(controller.progress.value * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkText : AppColors.darkBg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 7,
              color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
              child: Obx(() {
                final done = controller.scanState.value == 'done';
                final p = controller.progress.value.clamp(0.0, 1.0);
                final lp = controller.lateProgress.value.clamp(0.0, 1.0);

                return Stack(
                  children: [
                    // Main Progress
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: p,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        decoration: BoxDecoration(
                          color: done ? AppColors.success : AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // Late Progress (Red)
                    if (lp > 0)
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: lp.clamp(0.0, p),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 13,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  '${AppLocalizations.of(context)!.remaining}: ${controller.remainingTime.value}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Biometric Section ────────────────────────────────────────
class _BiometricSection extends StatefulWidget {
  final bool isDark;
  final AttendanceController controller;
  const _BiometricSection({required this.isDark, required this.controller});

  @override
  State<_BiometricSection> createState() => _BiometricSectionState();
}

class _BiometricSectionState extends State<_BiometricSection>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  late AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    final state = widget.controller.scanState.value;
    if (state == 'idle') {
      _scanController.forward(from: 0);
      widget.controller.checkIn(l10n);
    } else if (state == 'checkedin') {
      _scanController.forward(from: 0);
      widget.controller.checkOut(l10n);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = widget.controller.scanState.value;
      final feedbackMsg = widget.controller.feedbackMsg.value;
      final feedbackType = widget.controller.feedbackType.value;
      final isDark = widget.isDark;
      final l10n = AppLocalizations.of(context)!;

      Color ringColor;
      Color innerBg;
      Color iconColor;
      String label;

      switch (state) {
        case 'checkedin':
          ringColor = AppColors.success;
          innerBg = AppColors.successLight;
          iconColor = AppColors.success;
          label = l10n.tapToCheckOut;
          break;
        case 'done':
          ringColor = AppColors.success;
          innerBg = AppColors.successLight;
          iconColor = AppColors.success;
          label = l10n.workDayComplete;
          break;
        case 'scanning':
          ringColor = AppColors.primary;
          innerBg = AppColors.primaryLight;
          iconColor = AppColors.primary;
          label = l10n.scanning;
          break;
        default:
          ringColor = AppColors.primary;
          innerBg = isDark ? AppColors.darkBorder : AppColors.lightGrey;
          iconColor = isDark ? AppColors.darkMuted : AppColors.grey;
          label = l10n.tapToCheckIn;
      }

      return Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkMuted : AppColors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // ── Face ID Ring Button ──
          GestureDetector(
            onTap: state == 'done' || state == 'scanning' ? null : _handleTap,
            child: ScaleTransition(
              scale: state == 'idle' || state == 'checkedin'
                  ? _pulseAnim
                  : const AlwaysStoppedAnimation(1.0),
              child: SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer animated ring
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: state == 'scanning'
                          ? _ScanningRing(color: ringColor)
                          : CustomPaint(
                              painter: _StaticRingPainter(
                                color: ringColor,
                                filled: state == 'checkedin' || state == 'done',
                              ),
                            ),
                    ),
                    // Inner circle with icon
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: innerBg,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ringColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: state == 'done'
                            ? const Icon(
                                Icons.check_circle_rounded,
                                size: 44,
                                color: AppColors.success,
                              )
                            : state == 'scanning'
                            ? const SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.primary,
                                ),
                              )
                            : _FaceIdIcon(
                                color: iconColor,
                                isCheckedIn: state == 'checkedin',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Feedback Message ──
          if (feedbackMsg.isNotEmpty)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                feedbackMsg,
                key: ValueKey(feedbackMsg),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: feedbackType == 'success'
                      ? AppColors.success
                      : feedbackType == 'error'
                      ? AppColors.danger
                      : AppColors.primary,
                ),
              ),
            )
          else
            const SizedBox(height: 16),

          const SizedBox(height: 16),

          // ── Action Button ──
          if (state != 'done')
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _ActionButton(
                  key: ValueKey(state),
                  isDark: isDark,
                  state: state,
                  isLoading: widget.controller.isLoading.value,
                  biometricLabel: widget.controller.biometricLabel(l10n),
                  onTap: _handleTap,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.workDayComplete,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}

// ─── Scanning Ring Animation ───────────────────────────────────
class _ScanningRing extends StatefulWidget {
  final Color color;
  const _ScanningRing({required this.color});

  @override
  State<_ScanningRing> createState() => _ScanningRingState();
}

class _ScanningRingState extends State<_ScanningRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _anim = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => CustomPaint(
        painter: _SpinningRingPainter(
          progress: _anim.value,
          color: widget.color,
        ),
      ),
    );
  }
}

class _SpinningRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _SpinningRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, paint);

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      (progress * 2 - 0.5) * 3.14159,
      0.8 * 3.14159,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_SpinningRingPainter old) => old.progress != progress;
}

class _StaticRingPainter extends CustomPainter {
  final Color color;
  final bool filled;
  _StaticRingPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;
    final paint = Paint()
      ..color = filled ? color : color.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    if (filled) {
      canvas.drawCircle(center, radius, paint);
    } else {
      // Dashed ring for idle
      for (int i = 0; i < 12; i++) {
        if (i % 2 == 0) {
          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius),
            i * 0.5236 - 1.5708,
            0.4,
            false,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_StaticRingPainter old) =>
      old.filled != filled || old.color != color;
}

// ─── Face ID Icon ─────────────────────────────────────────────
class _FaceIdIcon extends StatelessWidget {
  final Color color;
  final bool isCheckedIn;
  const _FaceIdIcon({required this.color, this.isCheckedIn = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(48, 48),
      painter: _FaceIdPainter(color: color, isCheckedIn: isCheckedIn),
    );
  }
}

class _FaceIdPainter extends CustomPainter {
  final Color color;
  final bool isCheckedIn;
  _FaceIdPainter({required this.color, required this.isCheckedIn});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Face outline
    canvas.drawCircle(Offset(cx, cy - 2), 14, paint);

    // Eyes
    canvas.drawCircle(
      Offset(cx - 5, cy - 5),
      1.8,
      paint..style = PaintingStyle.fill,
    );
    canvas.drawCircle(Offset(cx + 5, cy - 5), 1.8, paint);
    paint.style = PaintingStyle.stroke;

    // Smile
    final smilePath = Path()
      ..moveTo(cx - 6, cy + 1)
      ..quadraticBezierTo(cx, cy + 7, cx + 6, cy + 1);
    canvas.drawPath(smilePath, paint);

    // Corner brackets (Face ID style)
    final b = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    const bSize = 6.0;
    const bR = 2.0;

    // Top-left
    canvas.drawLine(Offset(2, 2 + bSize), Offset(2, 2 + bR), b);
    canvas.drawLine(Offset(2, 2), Offset(2 + bSize, 2), b);

    // Top-right
    canvas.drawLine(
      Offset(size.width - 2, 2 + bSize),
      Offset(size.width - 2, 2 + bR),
      b,
    );
    canvas.drawLine(
      Offset(size.width - 2, 2),
      Offset(size.width - 2 - bSize, 2),
      b,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(2, size.height - 2 - bSize),
      Offset(2, size.height - 2 - bR),
      b,
    );
    canvas.drawLine(
      Offset(2, size.height - 2),
      Offset(2 + bSize, size.height - 2),
      b,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - 2, size.height - 2 - bSize),
      Offset(size.width - 2, size.height - 2 - bR),
      b,
    );
    canvas.drawLine(
      Offset(size.width - 2, size.height - 2),
      Offset(size.width - 2 - bSize, size.height - 2),
      b,
    );
  }

  @override
  bool shouldRepaint(_FaceIdPainter old) =>
      old.color != color || old.isCheckedIn != isCheckedIn;
}

// ─── Action Button ────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final bool isDark;
  final String state;
  final bool isLoading;
  final String biometricLabel;
  final VoidCallback onTap;

  const _ActionButton({
    super.key,
    required this.isDark,
    required this.state,
    required this.isLoading,
    required this.biometricLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCheckout = state == 'checkedin';

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isCheckout ? AppColors.dangerLight : AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          border: isCheckout
              ? Border.all(color: AppColors.danger.withOpacity(0.3), width: 0.5)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isCheckout ? AppColors.danger : AppColors.white,
                ),
              )
            else
              Icon(
                isCheckout
                    ? Icons.logout_rounded
                    : Icons.face_retouching_natural,
                color: isCheckout ? AppColors.danger : AppColors.white,
                size: 20,
              ),
            const SizedBox(width: 10),
            Text(
              isCheckout
                  ? '${l10n.checkOutWith} $biometricLabel'
                  : '${l10n.checkInWith} $biometricLabel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isCheckout ? AppColors.danger : AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final bool isDark;
  const _StatsRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            isDark: isDark,
            value: '18',
            label: 'Present',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            isDark: isDark,
            value: '3',
            label: 'Late',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            isDark: isDark,
            value: '142h',
            label: 'This month',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final bool isDark;
  final String value;
  final String label;
  final Color color;

  const _StatBox({
    required this.isDark,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkMuted : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── History Section ──────────────────────────────────────────
class _HistorySection extends StatelessWidget {
  final bool isDark;
  const _HistorySection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.attendanceOverview,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkText : AppColors.darkBg,
              ),
            ),
            Text(
              l10n.viewAll,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
              width: 0.5,
            ),
          ),
          child: Column(
            children: _mockHistory.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == _mockHistory.length - 1;

              Color dotColor;
              Color badgeBg;
              Color badgeText;
              String badgeLabel;

              final l10n = AppLocalizations.of(context)!;
              switch (item['status']) {
                case 'present':
                  dotColor = AppColors.success;
                  badgeBg = AppColors.successLight;
                  badgeText = const Color(0xFF065F46);
                  badgeLabel = l10n.onTime;
                  break;
                case 'late':
                  dotColor = AppColors.warning;
                  badgeBg = AppColors.warningLight;
                  badgeText = const Color(0xFF92400E);
                  badgeLabel = l10n.late;
                  break;
                default:
                  dotColor = AppColors.danger;
                  badgeBg = AppColors.dangerLight;
                  badgeText = const Color(0xFF991B1B);
                  badgeLabel = l10n.absent;
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['date'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.darkBg,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${l10n.checkInShort} ${item['in']} · ${l10n.checkOutShort} ${item['out']} · ${item['hours']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppColors.darkMuted
                                      : AppColors.grey,
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
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: badgeText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightGrey,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
} // ─────────────────────────────────────────────────────────────

// ─── Calendar Section ──────────────────────────────────────────
class _CalendarSection extends StatelessWidget {
  final bool isDark;
  final AttendanceController controller;
  const _CalendarSection({required this.isDark, required this.controller});

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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  '${monthNames[controller.viewMonth.value - 1]} ${controller.viewYear.value}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isDark ? AppColors.darkText : AppColors.darkBg,
                  ),
                ),
              ),
              Row(
                children: [
                  _MonthNavBtn(
                    icon: Icons.chevron_left,
                    isDark: isDark,
                    onTap: () => controller.changeMonth(-1),
                  ),
                  const SizedBox(width: 8),
                  _MonthNavBtn(
                    icon: Icons.chevron_right,
                    isDark: isDark,
                    onTap: () => controller.changeMonth(1),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Day Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return Text(
                day,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Obx(
            () => _CalendarGrid(
              year: controller.viewYear.value,
              month: controller.viewMonth.value,
              data: controller.monthData,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 15),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(label: 'Present', color: AppColors.success),
              const SizedBox(width: 15),
              _LegendItem(label: 'Late', color: AppColors.warning),
              const SizedBox(width: 15),
              _LegendItem(label: 'Absent', color: AppColors.danger),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthNavBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;
  const _MonthNavBtn({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDark ? AppColors.darkText : AppColors.darkBg,
        ),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final int year;
  final int month;
  final Map<DateTime, AttendanceStatus> data;
  final bool isDark;

  const _CalendarGrid({
    required this.year,
    required this.month,
    required this.data,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final offset = firstDay.weekday % 7; // Sunday start
    final totalCells = ((daysInMonth + offset) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final day = index - offset + 1;
        if (day < 1 || day > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(year, month, day);
        final status = data[date];

        Color bgColor = Colors.transparent;
        Color textColor = isDark ? AppColors.darkText : AppColors.darkBg;

        if (status == AttendanceStatus.present) {
          bgColor = isDark
              ? AppColors.success.withOpacity(0.2)
              : AppColors.successLight;
          textColor = AppColors.success;
        } else if (status == AttendanceStatus.late) {
          bgColor = isDark
              ? AppColors.warning.withOpacity(0.2)
              : AppColors.warningLight;
          textColor = AppColors.warning;
        } else if (status == AttendanceStatus.absent) {
          bgColor = isDark
              ? AppColors.danger.withOpacity(0.2)
              : AppColors.dangerLight;
          textColor = AppColors.danger;
        } else if (status == AttendanceStatus.weekend) {
          textColor = AppColors.grey.withOpacity(0.5);
        }

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: DateUtils.isSameDay(date, DateTime.now())
                ? Border.all(color: AppColors.primary, width: 1.5)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        );
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
