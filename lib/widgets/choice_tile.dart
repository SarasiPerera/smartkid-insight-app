import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';

enum TileFeedback { none, correct, incorrect }

Color _hex(String hex) =>
    Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));

/// One tappable answer. Always at least [kMinTap] square (NFR1.1).
/// Feedback is shown with an icon AND a border colour, so it never depends on
/// colour alone (NFR1.3).
class ChoiceTile extends StatelessWidget {
  final ChoiceOption option;
  final double size;
  final TileFeedback feedback;
  final VoidCallback? onTap;

  const ChoiceTile({
    super.key,
    required this.option,
    required this.size,
    this.feedback = TileFeedback.none,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final side = size < kMinTap ? kMinTap : size;
    Widget face;
    if (option.shapeType != null) {
      face = CustomPaint(
        size: Size(side * 0.55, side * 0.55),
        painter: ShapePainter(option.shapeType!, AppColors.primary),
      );
    } else if (option.colorHex != null) {
      face = Container(
        width: side * 0.6,
        height: side * 0.6,
        decoration: BoxDecoration(
          color: _hex(option.colorHex!),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12, width: 2),
        ),
      );
    } else if (option.emoji != null) {
      face = Text(option.emoji!, style: TextStyle(fontSize: side * 0.46));
    } else {
      face = FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            option.text ?? '',
            style: sinhalaText(side * 0.34, weight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    Color border = AppColors.line;
    Color fill = Colors.white;
    IconData? badge;
    if (feedback == TileFeedback.correct) {
      border = AppColors.strong;
      fill = const Color(0xFFDCFCE7);
      badge = Icons.check_circle;
    } else if (feedback == TileFeedback.incorrect) {
      border = AppColors.weak;
      fill = const Color(0xFFFEE2E2);
      badge = Icons.cancel;
    }

    return Semantics(
      button: true,
      label: option.text ?? option.emoji ?? 'answer choice',
      child: Material(
        color: fill,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            width: side,
            height: side,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: border, width: 3),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(child: face),
                if (badge != null)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Icon(badge, color: border, size: 26),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final ShapeType shape;
  final Color color;
  ShapePainter(this.shape, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final w = size.width, h = size.height;
    switch (shape) {
      case ShapeType.circle:
        canvas.drawCircle(Offset(w / 2, h / 2), w / 2, paint);
        break;
      case ShapeType.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.08, h * 0.08, w * 0.84, h * 0.84),
            const Radius.circular(6),
          ),
          paint,
        );
        break;
      case ShapeType.rectangle:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.25, w, h * 0.5),
            const Radius.circular(6),
          ),
          paint,
        );
        break;
      case ShapeType.oval:
        canvas.drawOval(Rect.fromLTWH(0, h * 0.2, w, h * 0.6), paint);
        break;
      case ShapeType.triangle:
        canvas.drawPath(
          Path()
            ..moveTo(w / 2, 0)
            ..lineTo(w, h)
            ..lineTo(0, h)
            ..close(),
          paint,
        );
        break;
      case ShapeType.star:
        final path = Path();
        const pts = [
          [27.0, 2.0],
          [33.0, 19.0],
          [51.0, 19.0],
          [37.0, 30.0],
          [42.0, 48.0],
          [27.0, 37.0],
          [12.0, 48.0],
          [17.0, 30.0],
          [3.0, 19.0],
          [21.0, 19.0],
        ];
        path.moveTo(pts[0][0] * w / 54, pts[0][1] * h / 54);
        for (final p in pts.skip(1)) {
          path.lineTo(p[0] * w / 54, p[1] * h / 54);
        }
        path.close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.heart:
        final path = Path()
          ..moveTo(w / 2, h * 0.95)
          ..cubicTo(-w * 0.15, h * 0.55, w * 0.1, -h * 0.05, w / 2, h * 0.3)
          ..cubicTo(w * 0.9, -h * 0.05, w * 1.15, h * 0.55, w / 2, h * 0.95)
          ..close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant ShapePainter old) =>
      old.shape != shape || old.color != color;
}
