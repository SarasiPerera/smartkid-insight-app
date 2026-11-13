import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Animated Flutter recreation of the React OllieOwl SVG mascot.
enum OwlEmotion { cheerful, bounce, speaking, encouraging, welcome }

class MascotOwl extends StatefulWidget {
  final OwlEmotion emotion;
  final double size;
  final String? speech;
  const MascotOwl({super.key, this.emotion = OwlEmotion.cheerful, this.size = 110, this.speech});

  @override
  State<MascotOwl> createState() => _MascotOwlState();
}

class _MascotOwlState extends State<MascotOwl> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.emotion == OwlEmotion.bounce ? 600 : 1250),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mascot = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_controller.value);
        final isBouncy = widget.emotion == OwlEmotion.bounce || widget.emotion == OwlEmotion.welcome;
        final dy = isBouncy ? -10 * t : -3.5 * t;
        final angle = isBouncy ? math.sin(t * math.pi * 2) * 0.025 : 0.0;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.rotate(
            angle: angle,
            child: CustomPaint(
              size: Size(widget.size, widget.size * 1.1),
              painter: _OwlPainter(widget.emotion, t),
            ),
          ),
        );
      },
    );

    if (widget.speech == null) return mascot;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFB923C), width: 1.5),
          boxShadow: const [BoxShadow(color: Color(0x1A0F172A), blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: Text(widget.speech!, textAlign: TextAlign.center,
            style: sinhalaText(13, weight: FontWeight.w800)),
      ),
      const SizedBox(height: 5),
      mascot,
    ]);
  }
}

class _OwlPainter extends CustomPainter {
  final OwlEmotion emotion;
  final double phase;
  _OwlPainter(this.emotion, this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 200;
    final sy = size.height / 220;
    canvas.save();
    canvas.scale(sx, sy);

    final body = Paint()..shader = const LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    ).createShader(const Rect.fromLTWH(25, 30, 150, 165));
    final belly = Paint()..shader = const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color(0xFFFEF08A), Color(0xFFFDE047)],
    ).createShader(const Rect.fromLTWH(55, 90, 90, 110));
    final wingPaint = Paint()..color = const Color(0xFFC2410C);
    final white = Paint()..color = Colors.white;
    final eyeFrame = Paint()..color = const Color(0xFF1E3A8A)..style = PaintingStyle.stroke..strokeWidth = 5;
    final pupil = Paint()..color = const Color(0xFF0F172A);
    final highlight = Paint()..color = Colors.white;
    final feather = Paint()..color = const Color(0xFFD97706)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;

    // Ear tufts and rounded orange body.
    final tufts = Paint()..color = const Color(0xFFC2410C);
    final leftTuft = Path()..moveTo(48, 53)..quadraticBezierTo(23, 12, 62, 43)..close();
    final rightTuft = Path()..moveTo(152, 53)..quadraticBezierTo(177, 12, 138, 43)..close();
    canvas.drawPath(leftTuft, tufts);
    canvas.drawPath(rightTuft, tufts);
    canvas.drawOval(const Rect.fromLTRB(30, 38, 170, 202), body);

    // Flapping side wings, matching the React mascot's motion.
    final flap = (emotion == OwlEmotion.bounce || emotion == OwlEmotion.speaking)
        ? math.sin(phase * math.pi * 2) * 0.18 : math.sin(phase * math.pi * 2) * 0.045;
    canvas.save();
    canvas.translate(31, 121);
    canvas.rotate(-0.08 - flap);
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 0), width: 36, height: 76), wingPaint);
    canvas.restore();
    canvas.save();
    canvas.translate(169, 121);
    canvas.rotate(0.08 + flap);
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 0), width: 36, height: 76), wingPaint);
    canvas.restore();

    // Yellow belly and feather lines.
    canvas.drawOval(const Rect.fromLTRB(55, 91, 145, 193), belly);
    final feathers = Path()
      ..moveTo(82, 125)..quadraticBezierTo(100, 137, 118, 125)
      ..moveTo(78, 148)..quadraticBezierTo(100, 160, 122, 148)
      ..moveTo(89, 170)..quadraticBezierTo(100, 177, 111, 170);
    canvas.drawPath(feathers, feather);
    final feet = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawOval(const Rect.fromLTRB(72, 190, 100, 207), feet);
    canvas.drawOval(const Rect.fromLTRB(100, 190, 128, 207), feet);

    // Large eyes, blue glasses and bright pupils.
    canvas.drawCircle(const Offset(65, 80), 30, white);
    canvas.drawCircle(const Offset(135, 80), 30, white);
    if (emotion == OwlEmotion.encouraging) {
      final closed = Paint()..color = const Color(0xFF0F172A)..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCenter(center: const Offset(65, 82), width: 30, height: 15), math.pi, math.pi, false, closed);
      canvas.drawArc(Rect.fromCenter(center: const Offset(135, 82), width: 30, height: 15), math.pi, math.pi, false, closed);
    } else {
      canvas.drawCircle(const Offset(65, 80), 14, pupil);
      canvas.drawCircle(const Offset(135, 80), 14, pupil);
      canvas.drawCircle(const Offset(60, 75), 5, highlight);
      canvas.drawCircle(const Offset(130, 75), 5, highlight);
    }
    final glass = Paint()..color = const Color(0x553B82F6)..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(65, 80), 32, glass);
    canvas.drawCircle(const Offset(135, 80), 32, glass);
    canvas.drawCircle(const Offset(65, 80), 32, eyeFrame);
    canvas.drawCircle(const Offset(135, 80), 32, eyeFrame);
    final bridge = Paint()..color = const Color(0xFF1E3A8A)..strokeWidth = 5..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(97, 80), const Offset(103, 80), bridge);

    // Beak, cheeks and small smile.
    final beak = Path()..moveTo(92, 96)..lineTo(108, 96)..lineTo(100, 113)..close();
    canvas.drawPath(beak, Paint()..color = const Color(0xFFF59E0B));
    final cheek = Paint()..color = const Color(0x66F43F5E);
    canvas.drawOval(Rect.fromCenter(center: const Offset(45, 96), width: 17, height: 10), cheek);
    canvas.drawOval(Rect.fromCenter(center: const Offset(155, 96), width: 17, height: 10), cheek);
    final smile = Paint()..color = const Color(0xFFB45309)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: const Offset(100, 139), width: 34, height: 20), 0.2, math.pi - 0.4, false, smile);

    if (emotion == OwlEmotion.bounce) {
      final star = Paint()..color = const Color(0xFFEAB308);
      canvas.drawCircle(const Offset(20, 55), 5, star);
      canvas.drawCircle(const Offset(180, 55), 5, star);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OwlPainter old) => old.emotion != emotion || old.phase != phase;
}
