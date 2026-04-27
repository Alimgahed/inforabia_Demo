import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_colors.dart';

// ─── DESIGN TOKENS ──────────────────────────────────────────────────────────

class _C {
  // Brand
  static const primary = AppColors.primary;
  static const primaryLight = AppColors.primaryLight;
  static const primaryDark = AppColors.darkTeal;
  static const accent = AppColors.accent;

  // Surfaces
  static const bg = AppColors.background;
  static const surface = AppColors.white;
  static const surfaceAlt = AppColors.lightGrey;

  // Semantic
  static const success = AppColors.success;
  static const successLight = AppColors.successLight;
  static const warning = AppColors.warning;
  static const warningLight = AppColors.warningLight;
  static const danger = AppColors.danger;
  static const dangerLight = AppColors.dangerLight;

  // Text
  static const textPrimary = AppColors.black;
  static const textSecondary = AppColors.grey;
  static const textMuted = AppColors.darkMuted;
  static const textOnDark = AppColors.white;

  // Border
  static const border = AppColors.lightGrey;
  static const borderLight = AppColors.lightGrey;

  // Bot bubble
  static const botBubble = AppColors.white;
  static const userBubble = AppColors.primary;
}

const _kRadius = 20.0;
const _kRadiusSm = 12.0;

// ─── DATA MODELS ────────────────────────────────────────────────────────────

enum MessageType {
  text,
  leave,
  payslip,
  attendance,
  approvals,
  profile,
  documents,
  request,
}

class ChatMessage {
  final bool isUser;
  final String text;
  final MessageType type;
  final DateTime time;

  ChatMessage({
    required this.isUser,
    required this.text,
    required this.type,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

class QuickAction {
  final String label;
  final String emoji;
  final String keyword;
  final Color color;
  final Color bg;

  const QuickAction({
    required this.label,
    required this.emoji,
    required this.keyword,
    required this.color,
    required this.bg,
  });
}

// ─── MAIN SCREEN ────────────────────────────────────────────────────────────

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _showQuickActions = true;
  late AnimationController _typingAnimController;

  final List<ChatMessage> _messages = [
    ChatMessage(
      isUser: false,
      text: 'مرحباً! أنا HCM Assistant.\nكيف يمكنني مساعدتك اليوم؟',
      type: MessageType.text,
    ),
  ];

  static const List<QuickAction> _quickActions = [
    QuickAction(
      label: 'الإجازات',
      emoji: '📅',
      keyword: 'اجازة',
      color: AppColors.primary,
      bg: AppColors.primaryLight,
    ),
    QuickAction(
      label: 'المرتب',
      emoji: '💰',
      keyword: 'مرتب',
      color: AppColors.success,
      bg: AppColors.successLight,
    ),
    QuickAction(
      label: 'الحضور',
      emoji: '⏱️',
      keyword: 'حضور',
      color: AppColors.warning,
      bg: AppColors.warningLight,
    ),
    QuickAction(
      label: 'الموافقات',
      emoji: '✅',
      keyword: 'موافقة',
      color: AppColors.info,
      bg: AppColors.primaryLight,
    ),
    QuickAction(
      label: 'المستندات',
      emoji: '📄',
      keyword: 'مستند',
      color: AppColors.secondary,
      bg: AppColors.warningLight,
    ),
    QuickAction(
      label: 'الملف الشخصي',
      emoji: '👤',
      keyword: 'بيانات',
      color: AppColors.accent,
      bg: AppColors.primaryLight,
    ),
    QuickAction(
      label: 'طلب جديد',
      emoji: '📝',
      keyword: 'طلب',
      color: AppColors.danger,
      bg: AppColors.dangerLight,
    ),
    QuickAction(
      label: 'الأداء',
      emoji: '📊',
      keyword: 'اداء',
      color: AppColors.darkTeal,
      bg: AppColors.primaryLight,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _typingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _typingAnimController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  MessageType _detectType(String text) {
    text = text.toLowerCase();
    if (text.contains('اجاز') || text.contains('leave'))
      return MessageType.leave;
    if (text.contains('مرتب') ||
        text.contains('salary') ||
        text.contains('payslip'))
      return MessageType.payslip;
    if (text.contains('حضور') || text.contains('attendance'))
      return MessageType.attendance;
    if (text.contains('موافق') || text.contains('approval'))
      return MessageType.approvals;
    if (text.contains('بيانات') ||
        text.contains('profile') ||
        text.contains('ملف'))
      return MessageType.profile;
    if (text.contains('مستند') || text.contains('document'))
      return MessageType.documents;
    if (text.contains('طلب') || text.contains('request'))
      return MessageType.request;
    return MessageType.text;
  }

  String _getReply(MessageType type) {
    switch (type) {
      case MessageType.leave:
        return '📅 إليك تفاصيل رصيد الإجازات الخاص بك:';
      case MessageType.payslip:
        return '💰 بيانات المرتب لهذا الشهر:';
      case MessageType.attendance:
        return '⏱️ سجل الحضور والانصراف اليوم:';
      case MessageType.approvals:
        return '✅ الطلبات المعلقة التي تحتاج موافقتك:';
      case MessageType.profile:
        return '👤 بياناتك الشخصية ومعلومات التوظيف:';
      case MessageType.documents:
        return '📄 المستندات والوثائق المتاحة لك:';
      case MessageType.request:
        return '📝 يمكنني مساعدتك في تقديم طلب جديد:';
      default:
        return '🤖 يمكنني مساعدتك في الإجازات، المرتب، الحضور، الموافقات، المستندات، والمزيد.';
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    HapticFeedback.lightImpact();

    final type = _detectType(text);
    setState(() {
      _messages.add(
        ChatMessage(isUser: true, text: text, type: MessageType.text),
      );
      _isTyping = true;
      _showQuickActions = false;
    });
    _controller.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(isUser: false, text: _getReply(type), type: type),
        );
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                itemCount:
                    _messages.length +
                    (_isTyping ? 1 : 0) +
                    (_showQuickActions ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i < _messages.length)
                    return _buildMessageItem(_messages[i]);
                  if (_showQuickActions && i == _messages.length)
                    return _buildQuickActionsGrid();
                  return _buildTypingBubble();
                },
              ),
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  // ─── HEADER ─────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(color: _C.primary),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: _C.textOnDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: _C.textOnDark,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HCM Assistant',
                      style: TextStyle(
                        color: _C.textOnDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF34D399),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'متاح الآن',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
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
  }

  Widget _headerAction(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white.withOpacity(0.85), size: 22),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  // ─── MESSAGES ───────────────────────────────────────────────────────────

  Widget _buildMessageItem(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: msg.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isUser) ...[_botAvatar(), const SizedBox(width: 8)],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (msg.type != MessageType.text && !msg.isUser)
                  _SmartCard(type: msg.type, introText: msg.text)
                else
                  _buildBubble(msg),
                const SizedBox(height: 3),
                Text(
                  _formatTime(msg.time),
                  style: const TextStyle(fontSize: 10, color: _C.textMuted),
                ),
              ],
            ),
          ),
          if (msg.isUser) ...[const SizedBox(width: 8), _userAvatar()],
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: msg.isUser ? _C.userBubble : _C.botBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(_kRadius),
          topRight: const Radius.circular(_kRadius),
          bottomLeft: Radius.circular(msg.isUser ? _kRadius : 4),
          bottomRight: Radius.circular(msg.isUser ? 4 : _kRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        msg.text,
        style: TextStyle(
          color: msg.isUser ? _C.textOnDark : _C.textPrimary,
          fontSize: 14.5,
          height: 1.5,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _botAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: _C.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.support_agent_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _userAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        border: Border.all(color: _C.border, width: 1.5),
      ),
      child: const Icon(Icons.person_rounded, color: Colors.white, size: 18),
    );
  }

  // ─── TYPING INDICATOR ───────────────────────────────────────────────────

  Widget _buildTypingBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _botAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _C.botBubble,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(_kRadius),
                topRight: Radius.circular(_kRadius),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(_kRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _typingAnimController,
              builder: (context, _) {
                return Row(
                  children: List.generate(3, (i) {
                    final delay = i / 3;
                    final t = (_typingAnimController.value + delay) % 1.0;
                    final scale = 0.6 + 0.4 * sin(t * pi);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _C.textMuted.withOpacity(0.6 + 0.4 * scale),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── QUICK ACTIONS GRID ─────────────────────────────────────────────────

  Widget _buildQuickActionsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 10),
            child: Text(
              'اختر من الخيارات السريعة',
              style: TextStyle(
                fontSize: 12,
                color: _C.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _quickActions.length,
            itemBuilder: (context, i) => _QuickActionChip(
              action: _quickActions[i],
              onTap: () => _sendMessage(_quickActions[i].keyword),
            ),
          ),
        ],
      ),
    );
  }

  // ─── INPUT BAR ──────────────────────────────────────────────────────────

  Widget _buildInputBar() {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        border: Border(top: BorderSide(color: _C.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: _C.surfaceAlt,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _C.border),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    textDirection: TextDirection.rtl,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: _C.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      hintStyle: TextStyle(color: _C.textMuted, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(16, 11, 16, 11),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _sendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sendButton() {
    return GestureDetector(
      onTap: () => _sendMessage(_controller.text),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: _C.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
      ),
    );
  }

  // ─── UTILS ──────────────────────────────────────────────────────────────

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ─── QUICK ACTION CHIP ──────────────────────────────────────────────────────

class _QuickActionChip extends StatelessWidget {
  final QuickAction action;
  final VoidCallback onTap;

  const _QuickActionChip({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: action.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(action.emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              action.label,
              style: TextStyle(
                fontSize: 10.5,
                color: _C.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SMART CARD ─────────────────────────────────────────────────────────────

class _SmartCard extends StatelessWidget {
  final MessageType type;
  final String introText;

  const _SmartCard({required this.type, required this.introText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildBotIntro(), const SizedBox(height: 8), _buildCard()],
    );
  }

  Widget _buildBotIntro() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _C.botBubble,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(_kRadius),
          topRight: Radius.circular(_kRadius),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(_kRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        introText,
        style: const TextStyle(
          color: _C.textPrimary,
          fontSize: 14.5,
          height: 1.5,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildCard() {
    switch (type) {
      case MessageType.leave:
        return _leaveCard();
      case MessageType.payslip:
        return _payslipCard();
      case MessageType.attendance:
        return _attendanceCard();
      case MessageType.approvals:
        return _approvalsCard();
      case MessageType.profile:
        return _profileCard();
      case MessageType.documents:
        return _documentsCard();
      case MessageType.request:
        return _requestCard();
      default:
        return const SizedBox();
    }
  }

  // ── Leave Card ──

  Widget _leaveCard() {
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.event_available_rounded,
        label: 'رصيد الإجازات',
        color: _C.primary,
      ),
      child: Column(
        children: [
          SizedBox(height: 16),
          Row(
            children: [
              _StatBox(
                label: 'سنوية',
                value: '12',
                unit: 'يوم',
                color: _C.primary,
                bg: _C.primaryLight,
              ),
              const SizedBox(width: 8),
              _StatBox(
                label: 'مرضية',
                value: '6',
                unit: 'يوم',
                color: _C.success,
                bg: _C.successLight,
              ),
              const SizedBox(width: 8),
              _StatBox(
                label: 'طارئة',
                value: '3',
                unit: 'يوم',
                color: _C.warning,
                bg: _C.warningLight,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ProgressBar(label: 'مستخدم', used: 8, total: 20, color: _C.primary),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'طلب إجازة',
                  icon: Icons.add_circle_outline_rounded,
                  color: _C.primary,
                  filled: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: 'سجل الإجازات',
                  icon: Icons.list_alt_rounded,
                  color: _C.primary,
                  filled: false,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Payslip Card ──

  Widget _payslipCard() {
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.account_balance_wallet_rounded,
        label: 'كشف المرتب',
        color: const Color(0xFF059669),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _C.successLight,
              borderRadius: BorderRadius.circular(_kRadiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'صافي الراتب',
                      style: TextStyle(fontSize: 12, color: Color(0xFF065F46)),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '12,500 ج.م',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _C.success,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'مُحوّل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _PayRow(label: 'الراتب الأساسي', value: '10,000 ج.م'),
          _PayRow(label: 'بدل السكن', value: '1,500 ج.م'),
          _PayRow(label: 'بدل النقل', value: '1,000 ج.م'),
          const Divider(height: 16, color: _C.border),
          _PayRow(label: 'التأمينات', value: '- 750 ج.م', isDeduction: true),
          _PayRow(label: 'ضريبة الدخل', value: '- 250 ج.م', isDeduction: true),
          const SizedBox(height: 12),
          _ActionButton(
            label: 'تحميل PDF',
            icon: Icons.download_rounded,
            color: const Color(0xFF059669),
            filled: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── Attendance Card ──

  Widget _attendanceCard() {
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.access_time_rounded,
        label: 'سجل الحضور',
        color: _C.warning,
      ),
      child: Column(
        children: [
          SizedBox(height: 16),
          Row(
            children: [
              _AttendanceBadge(
                label: 'الحضور',
                time: '9:05 ص',
                icon: Icons.login_rounded,
                color: _C.success,
                bg: _C.successLight,
              ),
              const SizedBox(width: 8),
              _AttendanceBadge(
                label: 'الانصراف',
                time: '5:00 م',
                icon: Icons.logout_rounded,
                color: _C.danger,
                bg: _C.dangerLight,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _TimelineRow(label: 'إجمالي ساعات العمل', value: '7:55 ساعة'),
          _TimelineRow(label: 'التأخير', value: '5 دقائق'),
          _TimelineRow(label: 'الوضع', value: 'حاضر ✓'),
          const SizedBox(height: 12),
          _ActionButton(
            label: 'عرض التقرير الشهري',
            icon: Icons.bar_chart_rounded,
            color: _C.warning,
            filled: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── Approvals Card ──

  Widget _approvalsCard() {
    const purple = Color(0xFF8B5CF6);
    const purpleLight = Color(0xFFEDE9FE);
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.task_alt_rounded,
        label: 'الطلبات المعلقة',
        color: purple,
      ),
      child: Column(
        children: [
          SizedBox(height: 16),
          _ApprovalItem(
            title: 'طلب إجازة سنوية',
            requestedBy: 'أحمد محمد',
            days: '3 أيام',
            urgent: true,
          ),
          _ApprovalItem(
            title: 'طلب عمل من المنزل',
            requestedBy: 'سارة علي',
            days: '2 أيام',
            urgent: false,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'موافقة على الكل',
                  icon: Icons.check_circle_outline,
                  color: _C.success,
                  filled: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: 'عرض الكل',
                  icon: Icons.open_in_new_rounded,
                  color: purple,
                  filled: false,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Profile Card ──

  Widget _profileCard() {
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.person_rounded,
        label: 'الملف الشخصي',
        color: _C.accent,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0EA5E9), Color(0xFF1A56DB)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'أم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أحمد محمد علي',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _C.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'مهندس برمجيات',
                      style: TextStyle(fontSize: 12, color: _C.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _C.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'تقنية المعلومات',
                        style: TextStyle(
                          fontSize: 10,
                          color: _C.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: _C.border),
          _ProfileRow(icon: Icons.email_outlined, label: 'ahmed.m@company.com'),
          _ProfileRow(icon: Icons.phone_outlined, label: '+20 10 1234 5678'),
          _ProfileRow(icon: Icons.badge_outlined, label: 'EMP-20234'),
          _ProfileRow(
            icon: Icons.calendar_today_outlined,
            label: 'تاريخ التعيين: يناير 2020',
          ),
          const SizedBox(height: 12),
          _ActionButton(
            label: 'تعديل البيانات',
            icon: Icons.edit_rounded,
            color: _C.accent,
            filled: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── Documents Card ──

  Widget _documentsCard() {
    const pink = Color(0xFFEC4899);
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.folder_rounded,
        label: 'المستندات',
        color: pink,
      ),
      child: Column(
        children: [
          _DocumentItem(name: 'عقد العمل.pdf', size: '1.2 MB', type: 'PDF'),
          _DocumentItem(name: 'شهادة الراتب.pdf', size: '0.8 MB', type: 'PDF'),
          _DocumentItem(name: 'خطاب توصية.docx', size: '0.3 MB', type: 'DOC'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'رفع مستند',
                  icon: Icons.upload_rounded,
                  color: pink,
                  filled: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: 'عرض الكل',
                  icon: Icons.grid_view_rounded,
                  color: pink,
                  filled: false,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Request Card ──

  Widget _requestCard() {
    const red = Color(0xFFEF4444);
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.note_add_rounded,
        label: 'طلب جديد',
        color: red,
      ),
      child: Column(
        children: [
          _RequestOption(
            icon: '📅',
            title: 'إجازة',
            subtitle: 'سنوية / مرضية / طارئة',
          ),
          _RequestOption(
            icon: '🏠',
            title: 'عمل من المنزل',
            subtitle: 'Work From Home',
          ),
          _RequestOption(
            icon: '💰',
            title: 'سلفة',
            subtitle: 'طلب سلفة على الراتب',
          ),
          _RequestOption(
            icon: '📋',
            title: 'شهادة راتب',
            subtitle: 'للبنك أو الجهات الرسمية',
          ),
          _RequestOption(
            icon: '🔄',
            title: 'تعديل بيانات',
            subtitle: 'تحديث معلوماتك الشخصية',
          ),
        ],
      ),
    );
  }
}

// ─── SHARED WIDGET COMPONENTS ───────────────────────────────────────────────

class _BaseCard extends StatelessWidget {
  final _CardHeader header;
  final Widget child;

  const _BaseCard({required this.header, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CardHeader({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(bottom: BorderSide(color: color.withOpacity(0.15))),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value, unit;
  final Color color, bg;

  const _StatBox({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(_kRadiusSm),
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
            Text(
              unit,
              style: TextStyle(fontSize: 10, color: color.withOpacity(0.7)),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final int used, total;
  final Color color;

  const _ProgressBar({
    required this.label,
    required this.used,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = used / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: _C.textSecondary),
            ),
            Text(
              '$used / $total يوم',
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: _C.surfaceAlt,
            color: color,
            minHeight: 7,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: filled ? Colors.white : color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PayRow extends StatelessWidget {
  final String label, value;
  final bool isDeduction;

  const _PayRow({
    required this.label,
    required this.value,
    this.isDeduction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: _C.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isDeduction ? _C.danger : _C.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceBadge extends StatelessWidget {
  final String label, time;
  final IconData icon;
  final Color color, bg;

  const _AttendanceBadge({
    required this.label,
    required this.time,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(_kRadiusSm),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: color.withOpacity(0.8)),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final String label, value;

  const _TimelineRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: _C.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: _C.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovalItem extends StatelessWidget {
  final String title, requestedBy, days;
  final bool urgent;

  const _ApprovalItem({
    required this.title,
    required this.requestedBy,
    required this.days,
    required this.urgent,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF8B5CF6);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _C.surfaceAlt,
        borderRadius: BorderRadius.circular(_kRadiusSm),
        border: Border.all(color: _C.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: urgent ? _C.dangerLight : _C.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              size: 18,
              color: urgent ? _C.danger : _C.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _C.textPrimary,
                  ),
                ),
                Text(
                  requestedBy,
                  style: const TextStyle(fontSize: 11, color: _C.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: urgent ? _C.dangerLight : const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  urgent ? 'عاجل' : 'عادي',
                  style: TextStyle(
                    fontSize: 10,
                    color: urgent ? _C.danger : purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                days,
                style: const TextStyle(fontSize: 11, color: _C.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ProfileRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 15, color: _C.textMuted),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: _C.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final String name, size, type;

  const _DocumentItem({
    required this.name,
    required this.size,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isDoc = type == 'DOC';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _C.surfaceAlt,
        borderRadius: BorderRadius.circular(_kRadiusSm),
        border: Border.all(color: _C.border),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDoc ? const Color(0xFFEDE9FE) : _C.dangerLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                type,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: isDoc ? const Color(0xFF8B5CF6) : _C.danger,
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
                  name,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: _C.textPrimary,
                  ),
                ),
                Text(
                  size,
                  style: const TextStyle(fontSize: 11, color: _C.textMuted),
                ),
              ],
            ),
          ),
          Icon(Icons.download_rounded, color: _C.textMuted, size: 18),
        ],
      ),
    );
  }
}

class _RequestOption extends StatelessWidget {
  final String icon, title, subtitle;

  const _RequestOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(_kRadiusSm),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _C.surfaceAlt,
            borderRadius: BorderRadius.circular(_kRadiusSm),
            border: Border.all(color: _C.border),
          ),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _C.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _C.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: _C.textMuted,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
