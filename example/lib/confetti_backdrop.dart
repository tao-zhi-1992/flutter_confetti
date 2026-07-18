import 'dart:math';

import 'package:example/demo_theme.dart';
import 'package:flutter/material.dart';

/// Soft confetti shapes scattered behind the page header only.
class ConfettiBackdrop extends StatelessWidget {
  const ConfettiBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: CustomPaint(
        painter: _ConfettiScatterPainter(),
        child: SizedBox.expand(),
      ),
    );
  }
}

class _ConfettiScatterPainter extends CustomPainter {
  const _ConfettiScatterPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rng = Random(42);

    final wash = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.7, -1.0),
        radius: 1.15,
        colors: [
          DemoColors.rose.withValues(alpha: 0.10),
          DemoColors.cyan.withValues(alpha: 0.06),
          DemoColors.canvas.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, wash);

    final secondWash = Paint()
      ..shader = RadialGradient(
        center: const Alignment(1.0, -0.2),
        radius: 0.9,
        colors: [
          DemoColors.violet.withValues(alpha: 0.08),
          DemoColors.canvas.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, secondWash);

    for (var i = 0; i < 18; i++) {
      paint.color = DemoColors.accents[i % DemoColors.accents.length]
          .withValues(alpha: 0.22 + rng.nextDouble() * 0.18);

      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final s = 3.0 + rng.nextDouble() * 7.0;
      final rot = rng.nextDouble() * pi;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);

      switch (i % 4) {
        case 0:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: s * 1.6, height: s),
              const Radius.circular(1.5),
            ),
            paint,
          );
        case 1:
          canvas.drawCircle(Offset.zero, s * 0.55, paint);
        case 2:
          final path = Path()
            ..moveTo(0, -s)
            ..lineTo(s * 0.7, s * 0.5)
            ..lineTo(-s * 0.7, s * 0.5)
            ..close();
          canvas.drawPath(path, paint);
        default:
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: s, height: s * 0.55),
            paint,
          );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
