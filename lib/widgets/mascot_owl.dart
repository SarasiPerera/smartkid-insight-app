import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Mirrors the web prototype's OllieEmotion values.
enum OwlEmotion { cheerful, bounce, speaking, encouraging, welcome }

class MascotOwl extends StatefulWidget {
  final OwlEmotion emotion;
  final double size;
  final String? speech;

  const MascotOwl({
    super.key,
    this.emotion = OwlEmotion.cheerful,
    this.size = 110,
    this.speech,
  });

  @override
  State<MascotOwl> createState() => _MascotOwlState();
}

class _MascotOwlState extends State<MascotOwl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final owl = AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_c.value);
        double dy = -3 * t, scale = 1, angle = 0;
        switch (widget.emotion) {
          case OwlEmotion.bounce:
          case OwlEmotion.welcome:
            dy = -12 * t;
            scale = 1 + 0.06 * t;
            break;
          case OwlEmotion.speaking:
            scale = 1 + 0.05 * t;
            break;
          case OwlEmotion.encouraging:
            angle = (t - 0.5) * 0.12;
            break;
          case OwlEmotion.cheerful:
            break;
        }
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.rotate(
            angle: angle,
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _OwlPainter(widget.emotion),
      ),
    );

    if (widget.speech == null) return owl;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primarySoft, width: 2),
          ),
          child: Text(
            widget.speech!,
            textAlign: TextAlign.center,
            style: sinhalaText(15, weight: FontWeight.w800),
          ),
        ),
        owl,
      ],
    );
  }
}

class _OwlPainter extends CustomPainter {
  final OwlEmotion emotion;
  _OwlPainter(this.emotion);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    Offset p(double x, double y) => Offset(x * s, y * s);
    final body = Paint()..color = const Color(0xFF8C6A4E);
    final belly = Paint()..color = const Color(0xFFF4E3C8);
    final white = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF3D2645);
    final beak = Paint()..color = const Color(0xFFFFC145);
    final blush = Paint()..color = const Color(0x55FF8A8A);

    canvas.drawOval(
      Rect.fromCenter(center: p(50, 58), width: 68 * s, height: 64 * s),
      body,
    );
    canvas.drawOval(
      Rect.fromCenter(center: p(50, 60), width: 48 * s, height: 48 * s),
      belly,
    );

    final earL = Path()
      ..moveTo(24 * s, 32 * s)
      ..lineTo(34 * s, 10 * s)
      ..lineTo(42 * s, 34 * s)
      ..close();
    final earR = Path()
      ..moveTo(76 * s, 32 * s)
      ..lineTo(66 * s, 10 * s)
      ..lineTo(58 * s, 34 * s)
      ..close();
    canvas.drawPath(earL, body);
    canvas.drawPath(earR, body);

    canvas.drawCircle(p(39, 52), 11 * s, white);
    canvas.drawCircle(p(61, 52), 11 * s, white);
    canvas.drawCircle(p(39, 53), 5.5 * s, pupil);
    canvas.drawCircle(p(61, 53), 5.5 * s, pupil);
    canvas.drawCircle(p(41, 50), 2 * s, white);
    canvas.drawCircle(p(63, 50), 2 * s, white);

    canvas.drawOval(
      Rect.fromCenter(center: p(28, 66), width: 10 * s, height: 6 * s),
      blush,
    );
    canvas.drawOval(
      Rect.fromCenter(center: p(72, 66), width: 10 * s, height: 6 * s),
      blush,
    );

    final beakPath = Path()
      ..moveTo(47 * s, 63 * s)
      ..lineTo(53 * s, 63 * s)
      ..lineTo(50 * s, 71 * s)
      ..close();
    canvas.drawPath(beakPath, beak);

    if (emotion == OwlEmotion.encouraging) {
      final brow = Paint()
        ..color = const Color(0xFF3D2645)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * s
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(p(31, 38), p(45, 41), brow);
      canvas.drawLine(p(69, 38), p(55, 41), brow);
    }
    if (emotion == OwlEmotion.bounce || emotion == OwlEmotion.welcome) {
      final smile = Paint()
        ..color = const Color(0xFF3D2645)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8 * s
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCenter(center: p(50, 74), width: 14 * s, height: 8 * s),
        0.1,
        math.pi - 0.2,
        false,
        smile,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OwlPainter old) => old.emotion != emotion;
}
