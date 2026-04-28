import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inforabia/chatbot.dart';
import 'package:provider/provider.dart';
import 'package:inforabia/l10n/app_localizations.dart';
import '../../../core/providers/app_settings_provider.dart';
import '../../../core/theme/app_colors.dart';

// ─── DESIGN TOKENS ──────────────────────────────────────────────────────────

class _C {
  static const primary = AppColors.primary;
  static const primaryLight = AppColors.primaryLight;
  static const accent = AppColors.accent;
  static const success = AppColors.success;
  static const successLight = AppColors.successLight;
  static const warning = AppColors.warning;
  static const danger = AppColors.danger;
  static const dangerLight = AppColors.dangerLight;
  static const surface = AppColors.white;
  static const bg = AppColors.background;
  static const surfaceAlt = AppColors.lightGrey;
  static const border = AppColors.lightGrey;
  static const textPrimary = AppColors.black;
  static const textSecondary = AppColors.grey;
  static const textMuted = AppColors.darkMuted;

  // Dark mode surfaces
  static const darkBg = AppColors.darkBg;
  static const darkSurface = AppColors.darkSurface;
  static const darkSurfaceAlt = AppColors.darkCard;
  static const darkBorder = AppColors.darkBorder;
  static const darkText = AppColors.darkText;
  static const darkTextSecondary = AppColors.darkMuted;
}

// ─── SETTINGS SCREEN ────────────────────────────────────────────────────────

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = Provider.of<AppSettingsProvider>(context);

    final bg = isDark ? _C.darkBg : _C.bg;
    final surface = isDark ? _C.darkSurface : _C.surface;
    final border = isDark ? _C.darkBorder : _C.border;
    final textPrimary = isDark ? _C.darkText : _C.textPrimary;
    final textSecondary = isDark ? _C.darkTextSecondary : _C.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            expandedHeight: 0,
            pinned: true,
            backgroundColor: isDark ? _C.darkSurface : _C.primary,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'الإعدادات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  icon: const Icon(
                    Icons.help_outline_rounded,
                    color: Colors.white70,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Profile Card ──
                  _ProfileCard(
                    isDark: isDark,
                    surface: surface,
                    border: border,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),

                  const SizedBox(height: 24),

                  // ── AI Assistant Banner ──
                  _AiBanner(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChatBotScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // ── Appearance ──
                  _SectionLabel(label: 'المظهر والعرض', isDark: isDark),
                  const SizedBox(height: 10),
                  _SettingsGroup(
                    isDark: isDark,
                    surface: surface,
                    border: border,
                    children: [
                      _SwitchTile(
                        icon: Icons.dark_mode_rounded,
                        iconBg: AppColors.info,
                        title: l10n.darkMode,
                        subtitle: 'تفعيل الوضع الليلي',
                        value: settings.isDarkMode,
                        onChanged: (_) => settings.toggleTheme(),
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: true,
                        isLast: false,
                      ),
                      _DividerTile(isDark: isDark, border: border),
                      _TapTile(
                        icon: Icons.language_rounded,
                        iconBg: _C.accent,
                        title: l10n.language,
                        subtitle: settings.isArabic ? 'العربية' : 'English',
                        trailing: _LangBadge(
                          isArabic: settings.isArabic,
                          onTap: settings.toggleLocale,
                        ),
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: false,
                        isLast: false,
                        onTap: settings.toggleLocale,
                      ),
                      _DividerTile(isDark: isDark, border: border),
                      _TapTile(
                        icon: Icons.text_fields_rounded,
                        iconBg: AppColors.chartPurple,
                        title: 'حجم الخط',
                        subtitle: 'متوسط',
                        trailing: _Badge(
                          label: 'متوسط',
                          color: _C.primary,
                          bg: _C.primaryLight,
                        ),
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: false,
                        isLast: true,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Notifications ──
                  _SectionLabel(label: 'الإشعارات', isDark: isDark),
                  const SizedBox(height: 10),
                  _SettingsGroup(
                    isDark: isDark,
                    surface: surface,
                    border: border,
                    children: [
                      _SwitchTile(
                        icon: Icons.notifications_active_rounded,
                        iconBg: _C.warning,
                        title: 'إشعارات التطبيق',
                        subtitle: 'استلام جميع الإشعارات',
                        value: true,
                        onChanged: (_) {},
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: true,
                        isLast: false,
                      ),
                      _DividerTile(isDark: isDark, border: border),
                      _SwitchTile(
                        icon: Icons.task_alt_rounded,
                        iconBg: _C.success,
                        title: 'إشعارات الموافقات',
                        subtitle: 'عند وصول طلبات جديدة',
                        value: true,
                        onChanged: (_) {},
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: false,
                        isLast: false,
                      ),
                      _DividerTile(isDark: isDark, border: border),
                      _SwitchTile(
                        icon: Icons.email_rounded,
                        iconBg: _C.primary,
                        title: 'إشعارات البريد الإلكتروني',
                        subtitle: 'ملخص يومي عبر البريد',
                        value: false,
                        onChanged: (_) {},
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: false,
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Security ──
                  _SectionLabel(label: 'الأمان والخصوصية', isDark: isDark),
                  const SizedBox(height: 10),
                  _SettingsGroup(
                    isDark: isDark,
                    surface: surface,
                    border: border,
                    children: [
                      _TapTile(
                        icon: Icons.fingerprint_rounded,
                        iconBg: AppColors.success,
                        title: 'بصمة الإصبع / Face ID',
                        subtitle: 'تسجيل دخول سريع وآمن',
                        trailing: _Badge(
                          label: 'مفعّل',
                          color: _C.success,
                          bg: _C.successLight,
                        ),
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: true,
                        isLast: false,
                        onTap: () {},
                      ),
                      _DividerTile(isDark: isDark, border: border),
                      _TapTile(
                        icon: Icons.lock_reset_rounded,
                        iconBg: _C.warning,
                        title: 'تغيير كلمة المرور',
                        subtitle: 'آخر تغيير منذ 30 يوماً',
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: false,
                        isLast: false,
                        onTap: () {},
                      ),
                      _DividerTile(isDark: isDark, border: border),
                      _TapTile(
                        icon: Icons.shield_rounded,
                        iconBg: AppColors.info,
                        title: 'سياسة الخصوصية',
                        subtitle: 'اقرأ سياسة البيانات',
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: false,
                        isLast: true,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── About / Support ──
                  _SectionLabel(label: 'حول التطبيق والدعم', isDark: isDark),
                  const SizedBox(height: 10),
                  _SettingsGroup(
                    isDark: isDark,
                    surface: surface,
                    border: border,
                    children: [
                      _TapTile(
                        icon: Icons.info_outline_rounded,
                        iconBg: _C.accent,
                        title: '${l10n.version} 1.0.0',
                        subtitle: 'Oracle HCM Fusion · Build 2026',
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: true,
                        isLast: false,
                        onTap: () {},
                      ),
                      _DividerTile(isDark: isDark, border: border),
                      _TapTile(
                        icon: Icons.headset_mic_rounded,
                        iconBg: _C.success,
                        title: 'الدعم الفني',
                        subtitle: 'تواصل مع فريق الدعم',
                        trailing: _Badge(
                          label: 'متاح',
                          color: _C.success,
                          bg: _C.successLight,
                        ),
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: false,
                        isLast: false,
                        onTap: () {},
                      ),
                      _DividerTile(isDark: isDark, border: border),
                      _TapTile(
                        icon: Icons.star_rate_rounded,
                        iconBg: _C.warning,
                        title: 'قيّم التطبيق',
                        subtitle: 'شاركنا رأيك في المتجر',
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isFirst: false,
                        isLast: true,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Logout Button ──
                  _LogoutButton(l10n: l10n, context: context),

                  const SizedBox(height: 28),

                  // ── Footer ──
                  Center(
                    child: Column(
                      children: [
                        // Oracle logo strip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? _C.darkSurface : _C.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.cloud_rounded,
                                size: 14,
                                color: _C.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Powered by Oracle HCM Fusion',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '© 2026 INFORABIA · ${l10n.allRightsReserved}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? _C.darkTextSecondary : _C.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PROFILE CARD ───────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final bool isDark;
  final Color surface, border, textPrimary, textSecondary;

  const _ProfileCard({
    required this.isDark,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'أم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _C.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أحمد محمد علي',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'مهندس برمجيات · تقنية المعلومات',
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _MiniChip(
                      label: 'EMP-20234',
                      color: _C.primary,
                      bg: _C.primaryLight,
                    ),
                    const SizedBox(width: 6),
                    _MiniChip(
                      label: 'نشط',
                      color: _C.success,
                      bg: _C.successLight,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_rounded, size: 18, color: textSecondary),
            style: IconButton.styleFrom(
              backgroundColor: isDark ? _C.darkSurfaceAlt : _C.surfaceAlt,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AI BANNER ──────────────────────────────────────────────────────────────

class _AiBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _AiBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _C.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'HCM AI Assistant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'اسأل عن الإجازات، المرتب، الحضور...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'افتح',
                style: TextStyle(
                  color: _C.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── LOGOUT BUTTON ──────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  final dynamic l10n;
  final BuildContext context;

  const _LogoutButton({required this.l10n, required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _C.dangerLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.danger.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: _C.danger, size: 20),
            const SizedBox(width: 8),
            Text(
              l10n.logout,
              style: const TextStyle(
                color: _C.danger,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'تأكيد تسجيل الخروج',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: _C.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(ctx).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}

// ─── SETTINGS GROUP ─────────────────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  final bool isDark;
  final Color surface, border;
  final List<Widget> children;

  const _SettingsGroup({
    required this.isDark,
    required this.surface,
    required this.border,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(children: children),
      ),
    );
  }
}

// ─── SWITCH TILE ────────────────────────────────────────────────────────────

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDark, isFirst, isLast;
  final Color textPrimary, textSecondary;

  const _SwitchTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isDark,
    required this.isFirst,
    required this.isLast,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _IconBox(icon: icon, bg: iconBg),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11.5, color: textSecondary),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: _C.primary,
          ),
        ],
      ),
    );
  }
}

// ─── TAP TILE ───────────────────────────────────────────────────────────────

class _TapTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title, subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isDark, isFirst, isLast;
  final Color textPrimary, textSecondary;

  const _TapTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
    required this.isDark,
    required this.isFirst,
    required this.isLast,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _IconBox(icon: icon, bg: iconBg),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.5, color: textSecondary),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[trailing!, const SizedBox(width: 6)],
            if (trailing == null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDark ? _C.darkTextSecondary : _C.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}

// ─── SMALL COMPONENTS ───────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark ? _C.darkTextSecondary : _C.textSecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _DividerTile extends StatelessWidget {
  final bool isDark;
  final Color border;

  const _DividerTile({required this.isDark, required this.border});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: border,
      indent: 62,
      endIndent: 0,
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color bg;

  const _IconBox({required this.icon, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color, bg;

  const _Badge({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final Color color, bg;

  const _MiniChip({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LangBadge extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onTap;

  const _LangBadge({required this.isArabic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: _C.primaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _C.primary.withOpacity(0.3)),
        ),
        child: Text(
          isArabic ? 'English' : 'العربية',
          style: const TextStyle(
            fontSize: 12,
            color: _C.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
