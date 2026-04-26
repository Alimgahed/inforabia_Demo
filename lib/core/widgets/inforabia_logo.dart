import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InforabiaLogo extends StatelessWidget {
  final double width;
  final double height;
  final bool showShadow;

  const InforabiaLogo({
    super.key,
    this.width = 40,
    this.height = 56,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: showShadow
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary,
                  blurRadius: width * 0.3,
                  offset: Offset(0, height * 0.1),
                ),
              ],
            )
          : null,
      child: CustomPaint(
        painter: _InforabiaLogoPainter(),
        size: Size(width, height),
      ),
    );
  }
}

class _InforabiaLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final strokeW = w * 0.12;

    final tealPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.darkTeal, AppColors.primary, AppColors.accent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.square;

    final goldPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFB8782E), AppColors.secondary, Color(0xFFFFD54F)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.square;

    final centerGoldPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFB8782E), AppColors.secondary],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW * 1.5
      ..strokeCap = StrokeCap.round;

    final pathTeal = Path();
    final pathGold = Path();

    final halfStroke = strokeW / 2;

    // Corner Frames:
    // Top-Left Teal Angle
    pathTeal.moveTo(halfStroke, h * 0.4);
    pathTeal.lineTo(halfStroke, halfStroke);
    pathTeal.lineTo(w * 0.6, halfStroke);

    // Bottom-Right Teal Angle
    pathTeal.moveTo(w - halfStroke, h * 0.6);
    pathTeal.lineTo(w - halfStroke, h - halfStroke);
    pathTeal.lineTo(w * 0.4, h - halfStroke);

    // Top-Right Gold Angle
    pathGold.moveTo(w * 0.75, halfStroke);
    pathGold.lineTo(w - halfStroke, halfStroke);
    pathGold.lineTo(w - halfStroke, h * 0.35);

    // Bottom-Left Gold Angle
    pathGold.moveTo(w * 0.25, h - halfStroke);
    pathGold.lineTo(halfStroke, h - halfStroke);
    pathGold.lineTo(halfStroke, h * 0.65);

    // Internal geometry:
    // Diagonal top-left Teal
    pathTeal.moveTo(strokeW * 1.2, strokeW * 1.2);
    pathTeal.lineTo(w * 0.4, h * 0.4);

    // Diagonal bottom-right Teal
    pathTeal.moveTo(w - strokeW * 1.2, h - strokeW * 1.2);
    pathTeal.lineTo(w * 0.6, h * 0.6);

    // Horizontal Teal dash in middle-left
    pathTeal.moveTo(halfStroke, h * 0.5);
    pathTeal.lineTo(w * 0.3, h * 0.5);

    // Draw main structural paths
    canvas.drawPath(pathGold, goldPaint);
    canvas.drawPath(pathTeal, tealPaint);

    // Central 'O' Gold Ring
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.2, centerGoldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
