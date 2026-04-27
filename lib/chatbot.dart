import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_colors.dart';
import 'l10n/app_localizations.dart';

// ─── DESIGN TOKENS ──────────────────────────────────────────────────────────

class _C {
  // Brandff
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
  late List<ChatMessage> _messages;
  late AnimationController _typingAnimController;
  late AppLocalizations l10n;
  bool _initialized = false;
  bool _showQuickActions = true;

  List<QuickAction> _getQuickActions(AppLocalizations l10n) => [
    QuickAction(
      label: l10n.leaveManagement,
      emoji: '📅',
      keyword: l10n.leaveKeyword,
      color: AppColors.primary,
      bg: AppColors.primaryLight,
    ),
    QuickAction(
      label: l10n.payslip,
      emoji: '💰',
      keyword: l10n.salaryKeyword,
      color: AppColors.success,
      bg: AppColors.successLight,
    ),
    QuickAction(
      label: l10n.attendance,
      emoji: '⏱️',
      keyword: l10n.attendanceKeyword,
      color: AppColors.warning,
      bg: AppColors.warningLight,
    ),
    QuickAction(
      label: l10n.approvals,
      emoji: '✅',
      keyword: l10n.approvalKeyword,
      color: AppColors.info,
      bg: AppColors.primaryLight,
    ),
    QuickAction(
      label: l10n.documents,
      emoji: '📄',
      keyword: l10n.documentKeyword,
      color: AppColors.secondary,
      bg: AppColors.warningLight,
    ),
    QuickAction(
      label: l10n.profile,
      emoji: '👤',
      keyword: l10n.dataKeyword,
      color: AppColors.accent,
      bg: AppColors.primaryLight,
    ),
    QuickAction(
      label: l10n.newRequest,
      emoji: '📝',
      keyword: l10n.requestKeyword,
      color: AppColors.danger,
      bg: AppColors.dangerLight,
    ),
    QuickAction(
      label: l10n.performance,
      emoji: '📊',
      keyword: l10n.performanceKeyword,
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
    if (!_initialized) {
      _messages = [
        ChatMessage(
          isUser: false,
          text: l10n.chatbotGreeting,
          type: MessageType.text,
        ),
      ];
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _typingAnimController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── FUZZY INTENT DETECTION ─────────────────────────────────────────────

  /// Levenshtein distance — counts edits needed to turn [a] into [b].
  int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    final List<List<int>> dp = List.generate(
      a.length + 1,
      (i) => List.generate(b.length + 1, (j) => 0),
    );
    for (int i = 0; i <= a.length; i++) dp[i][0] = i;
    for (int j = 0; j <= b.length; j++) dp[0][j] = j;
    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        dp[i][j] = a[i - 1] == b[j - 1]
            ? dp[i - 1][j - 1]
            : 1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce(min);
      }
    }
    return dp[a.length][b.length];
  }

  /// Returns true if [word] is close enough to [target] (typo-tolerant).
  bool _fuzzyMatch(String word, String target) {
    if (word == target) return true;
    if (word.contains(target) || target.contains(word)) return true;
    final maxDist = target.length <= 4
        ? 1
        : target.length <= 7
        ? 2
        : 3;
    return _levenshtein(word, target) <= maxDist;
  }

  /// Checks if any word in [words] fuzzy-matches any keyword in [keywords].
  bool _anyMatch(List<String> words, List<String> keywords) =>
      words.any((w) => keywords.any((k) => _fuzzyMatch(w, k)));

  MessageType _detectType(String text, AppLocalizations l10n) {
    final lower = text.toLowerCase().trim();
    final words = lower.split(RegExp(r'\s+'));

    // ── Arabic keyword lists ────────────────────────────────────────────
    const arLeave = ['إجازة', 'اجازة', 'اجازه', 'إجازه', 'غياب', 'leave'];
    const arSalary = ['راتب', 'مرتب', 'راتبي', 'payslip', 'salary'];
    const arAttendance = ['حضور', 'حضوري', 'بصمة', 'دوام', 'attendance'];
    const arApproval = ['موافقة', 'موافقات', 'اعتماد', 'approval'];
    const arProfile = ['ملف', 'بياناتي', 'profile', 'معلوماتي'];
    const arDocuments = ['وثيقة', 'وثائق', 'مستند', 'مستندات', 'document'];
    const arRequest = ['طلب', 'طلبات', 'request'];

    // ── English keyword lists (with common typo variants) ───────────────
    const enLeave = [
      'leave',
      'leav',
      'leve',
      'leeave',
      'leeve',
      'vacation',
      'absence',
    ];
    const enSalary = [
      'salary',
      'salery',
      'salry',
      'payslip',
      'payslp',
      'paysleep',
      'pay',
      'wage',
      'income',
      'allowance',
    ];
    const enAttendance = [
      'attendance',
      'attencde',
      'attendnce',
      'atendance',
      'attendence',
      'checkin',
      'checkout',
      'timing',
      'clock',
    ];
    const enApproval = [
      'approval',
      'aproval',
      'apporval',
      'approvl',
      'approvel',
      'approve',
      'approvals',
      'pending',
    ];
    const enProfile = [
      'profile',
      'profiel',
      'profil',
      'proifle',
      'mydata',
      'info',
      'information',
      'personal',
    ];
    const enDocuments = [
      'document',
      'documnets',
      'documnet',
      'documment',
      'doc',
      'documents',
      'file',
      'files',
      'certificate',
    ];
    const enRequest = [
      'request',
      'rqeust',
      'requst',
      'requets',
      'rquest',
      'new',
    ];

    // ── Localization keywords ───────────────────────────────────────────
    final locLeave = [l10n.leaveKeyword.toLowerCase()];
    final locSalary = [l10n.salaryKeyword.toLowerCase()];
    final locAttendance = [l10n.attendanceKeyword.toLowerCase()];
    final locApproval = [l10n.approvalKeyword.toLowerCase()];
    final locData = [l10n.dataKeyword.toLowerCase()];
    final locDocument = [l10n.documentKeyword.toLowerCase()];
    final locRequest = [l10n.requestKeyword.toLowerCase()];

    // ── Arabic direct substring check (no fuzzy needed for Arabic) ──────
    if (arLeave.any((k) => lower.contains(k))) return MessageType.leave;
    if (arSalary.any((k) => lower.contains(k))) return MessageType.payslip;
    if (arAttendance.any((k) => lower.contains(k)))
      return MessageType.attendance;
    if (arApproval.any((k) => lower.contains(k))) return MessageType.approvals;
    if (arProfile.any((k) => lower.contains(k))) return MessageType.profile;
    if (arDocuments.any((k) => lower.contains(k))) return MessageType.documents;
    if (arRequest.any((k) => lower.contains(k))) return MessageType.request;

    // ── Fuzzy English + localization matching ───────────────────────────
    if (_anyMatch(words, [...enLeave, ...locLeave])) return MessageType.leave;
    if (_anyMatch(words, [...enSalary, ...locSalary]))
      return MessageType.payslip;
    if (_anyMatch(words, [...enAttendance, ...locAttendance]))
      return MessageType.attendance;
    if (_anyMatch(words, [...enApproval, ...locApproval]))
      return MessageType.approvals;
    if (_anyMatch(words, [...enProfile, ...locData]))
      return MessageType.profile;
    if (_anyMatch(words, [...enDocuments, ...locDocument]))
      return MessageType.documents;
    if (_anyMatch(words, [...enRequest, ...locRequest]))
      return MessageType.request;

    return MessageType.text;
  }

  // ────────────────────────────────────────────────────────────────────────

  String _getReply(MessageType type, AppLocalizations l10n) {
    switch (type) {
      case MessageType.leave:
        return l10n.chatbotLeaveReply;
      case MessageType.payslip:
        return l10n.chatbotSalaryReply;
      case MessageType.attendance:
        return l10n.chatbotAttendanceReply;
      case MessageType.approvals:
        return l10n.chatbotApprovalsReply;
      case MessageType.profile:
        return l10n.chatbotProfileReply;
      case MessageType.documents:
        return l10n.chatbotDocumentsReply;
      case MessageType.request:
        return l10n.chatbotRequestReply;
      default:
        return l10n.chatbotDefaultReply;
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    HapticFeedback.lightImpact();

    final type = _detectType(text, l10n);
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
          ChatMessage(isUser: false, text: _getReply(type, l10n), type: type),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          _buildHeader(l10n),
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
                    return _buildQuickActionsGrid(l10n);
                  return _buildTypingBubble();
                },
              ),
            ),
          ),
          _buildInputBar(l10n),
        ],
      ),
    );
  }

  // ─── HEADER ─────────────────────────────────────────────────────────────

  Widget _buildHeader(AppLocalizations l10n) {
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
                        Text(
                          l10n.availableNow,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
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

  Widget _buildQuickActionsGrid(AppLocalizations l10n) {
    final actions = _getQuickActions(l10n);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 10),
            child: Text(
              l10n.chooseFromQuickOptions,
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
            itemCount: actions.length,
            itemBuilder: (context, i) => _QuickActionChip(
              action: actions[i],
              onTap: () => _sendMessage(actions[i].keyword),
            ),
          ),
        ],
      ),
    );
  }

  // ─── INPUT BAR ──────────────────────────────────────────────────────────

  Widget _buildInputBar(AppLocalizations l10n) {
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
                    decoration: InputDecoration(
                      hintText: l10n.typeYourMessage,
                      hintStyle: const TextStyle(
                        color: _C.textMuted,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
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
      children: [
        _buildBotIntro(),
        const SizedBox(height: 8),
        _buildCard(context),
      ],
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

  Widget _buildCard(BuildContext context) {
    switch (type) {
      case MessageType.leave:
        return _leaveCard(context);
      case MessageType.payslip:
        return _payslipCard(context);
      case MessageType.attendance:
        return _attendanceCard(context);
      case MessageType.approvals:
        return _approvalsCard(context);
      case MessageType.profile:
        return _profileCard(context);
      case MessageType.documents:
        return _documentsCard(context);
      case MessageType.request:
        return _requestCard(context);
      default:
        return const SizedBox();
    }
  }

  // ── Leave Card ──

  Widget _leaveCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.event_available_rounded,
        label: l10n.leaveBalance,
        color: _C.primary,
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              _StatBox(
                label: l10n.annual,
                value: '12',
                unit: l10n.days,
                color: _C.primary,
                bg: _C.primaryLight,
              ),
              const SizedBox(width: 8),
              _StatBox(
                label: l10n.sick,
                value: '6',
                unit: l10n.days,
                color: _C.success,
                bg: _C.successLight,
              ),
              const SizedBox(width: 8),
              _StatBox(
                label: l10n.emergency,
                value: '3',
                unit: l10n.days,
                color: _C.warning,
                bg: _C.warningLight,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ProgressBar(
            label: l10n.used,
            used: 8,
            total: 20,
            color: _C.primary,
            unit: l10n.days,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: l10n.requestAbsence,
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

  Widget _payslipCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.account_balance_wallet_rounded,
        label: l10n.payslip,
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
                    Text(
                      l10n.netSalary,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF065F46),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '12,500 ${l10n.sar}',
                      style: const TextStyle(
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
                  child: Text(
                    l10n.transferred,
                    style: const TextStyle(
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
          _PayRow(label: l10n.basicSalary, value: '10,000 ${l10n.sar}'),
          _PayRow(label: l10n.housingAllowance, value: '1,500 ${l10n.sar}'),
          _PayRow(label: l10n.transportAllowance, value: '1,000 ${l10n.sar}'),
          const Divider(height: 16, color: _C.border),
          _PayRow(
            label: l10n.insurance,
            value: '- 750 ${l10n.sar}',
            isDeduction: true,
          ),
          _PayRow(
            label: l10n.tax,
            value: '- 250 ${l10n.sar}',
            isDeduction: true,
          ),
          const SizedBox(height: 12),
          _ActionButton(
            label: l10n.downloadPdf,
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

  Widget _attendanceCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.access_time_rounded,
        label: l10n.attendanceHistory,
        color: _C.warning,
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              _AttendanceBadge(
                label: l10n.checkIn,
                time: '9:05 ${l10n.am}',
                icon: Icons.login_rounded,
                color: _C.success,
                bg: _C.successLight,
              ),
              const SizedBox(width: 8),
              _AttendanceBadge(
                label: l10n.checkOut,
                time: '5:00 ${l10n.pm}',
                icon: Icons.logout_rounded,
                color: _C.danger,
                bg: _C.dangerLight,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _TimelineRow(label: l10n.totalHours, value: '7:55 ${l10n.hours}'),
          _TimelineRow(label: l10n.late, value: '5 ${l10n.mins}'),
          _TimelineRow(label: l10n.status, value: '${l10n.present} ✓'),
          const SizedBox(height: 12),
          _ActionButton(
            label: l10n.viewMonthlyReport,
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

  Widget _approvalsCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const purple = Color(0xFF8B5CF6);
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.task_alt_rounded,
        label: l10n.pendingRequests,
        color: purple,
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _ApprovalItem(
            title: l10n.annualLeave,
            requestedBy: 'Ahmed Mohamed',
            days: '3 ${l10n.days}',
            urgent: true,
          ),
          _ApprovalItem(
            title: l10n.workFromHome,
            requestedBy: 'Sara Ali',
            days: '2 ${l10n.days}',
            urgent: false,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: l10n.approveAll,
                  icon: Icons.check_circle_outline,
                  color: _C.success,
                  filled: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: l10n.viewAll,
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

  Widget _profileCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.person_rounded,
        label: l10n.profile,
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
                    'AR',
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
                      'Ahmed Al-Rashid',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _C.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.softwareEngineer,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _C.textSecondary,
                      ),
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
                      child: Text(
                        l10n.itDept,
                        style: const TextStyle(
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
          const _ProfileRow(
            icon: Icons.email_outlined,
            label: 'ahmed.m@company.com',
          ),
          const _ProfileRow(
            icon: Icons.phone_outlined,
            label: '+966 55 XXX 4567',
          ),
          const _ProfileRow(icon: Icons.badge_outlined, label: 'EMP-20234'),
          _ProfileRow(
            icon: Icons.calendar_today_outlined,
            label: '${l10n.joinDate}: ${l10n.jan} 2020',
          ),
          const SizedBox(height: 12),
          _ActionButton(
            label: l10n.editProfile,
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

  Widget _documentsCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const pink = Color(0xFFEC4899);
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.folder_rounded,
        label: l10n.documents,
        color: pink,
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          _DocumentItem(
            name: '${l10n.contract}.pdf',
            size: '1.2 MB',
            type: 'PDF',
          ),
          _DocumentItem(
            name: '${l10n.salaryCertificate}.pdf',
            size: '0.8 MB',
            type: 'PDF',
          ),
          _DocumentItem(
            name: '${l10n.recommendationLetter}.docx',
            size: '0.3 MB',
            type: 'DOC',
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: l10n.uploadDocument,
                  icon: Icons.upload_rounded,
                  color: pink,
                  filled: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: l10n.viewAll,
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

  Widget _requestCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const red = Color(0xFFEF4444);
    return _BaseCard(
      header: _CardHeader(
        icon: Icons.note_add_rounded,
        label: l10n.newRequest,
        color: red,
      ),
      child: Column(
        children: [
          _RequestOption(
            icon: '📅',
            title: l10n.leave,
            subtitle: '${l10n.annual} / ${l10n.sick} / ${l10n.emergency}',
          ),
          _RequestOption(
            icon: '🏠',
            title: l10n.workFromHome,
            subtitle: 'Work From Home',
          ),
          _RequestOption(
            icon: '💰',
            title: l10n.loan,
            subtitle: l10n.salaryLoanRequest,
          ),
          _RequestOption(
            icon: '📋',
            title: l10n.salaryCertificate,
            subtitle: l10n.officialEntityRequest,
          ),
          _RequestOption(
            icon: '🔄',
            title: l10n.dataUpdate,
            subtitle: l10n.updatePersonalInfo,
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
  final String label, unit;
  final int used, total;
  final Color color;

  const _ProgressBar({
    required this.label,
    required this.used,
    required this.total,
    required this.color,
    required this.unit,
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
              '$used / $total $unit',
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
