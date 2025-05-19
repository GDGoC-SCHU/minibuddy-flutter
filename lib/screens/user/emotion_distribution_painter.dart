import 'package:flutter/material.dart';
import 'package:minibuddy/models/emotion_distribution_model.dart';
import 'dart:math';

class EmotionDistributionPainter extends CustomPainter {
  final EmotionDistributionModel distribution;

  EmotionDistributionPainter(this.distribution);

  @override
  void paint(Canvas canvas, Size size) {
    const double gapAngle = 0.5;
    final center = Offset(size.width / 2, size.height / 2.4);
    final radius = size.width * 0.26;

    final paints = {
      'normal': Paint()..color = const Color.fromARGB(149, 207, 234, 227),
      'dep': Paint()..color = const Color.fromARGB(200, 51, 102, 204),
      'anx': Paint()..color = const Color.fromARGB(200, 255, 153, 0),
      'str': Paint()..color = const Color.fromARGB(200, 204, 0, 51),
    };

    // 수정된 total 계산
    final total = distribution.normal +
        distribution.dep +
        distribution.anx +
        distribution.str;

    if (total == 0) {
      // ⬇ 배경 원자국 먼저 그림
      canvas.drawCircle(
        center,
        radius + 4,
        Paint()
          ..color = const Color.fromARGB(255, 51, 51, 51).withOpacity(0.05)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // ⬇ ❓ 텍스트 그리기
      final tp = TextPainter(
        text: const TextSpan(
          text: '❓',
          style: TextStyle(
            fontSize: 64,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
      );
      return;
    }

    final ratios = {
      'normal': distribution.normal / total,
      'dep': distribution.dep / total,
      'anx': distribution.anx / total,
      'str': distribution.str / total,
    };

    double startAngle = -90.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (final entry in ratios.entries) {
      final sweepAngle = entry.value * 360;
      if (sweepAngle > gapAngle) {
        canvas.drawArc(
          rect,
          radians(startAngle + gapAngle / 2),
          radians(sweepAngle - gapAngle),
          true,
          paints[entry.key]!,
        );
        startAngle += sweepAngle;
      }
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color.fromARGB(0, 255, 255, 255)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    final legendItems = {
      'normal': 'GOOD',
      'dep': 'DEP',
      'anx': 'ANX',
      'str': 'STR',
    };

    const double spacing = 16;
    const double circleSize = 10;
    final double totalWidth = legendItems.length * (circleSize + spacing + 35);
    double dx = (size.width - totalWidth) / 2;

    final textStyle = TextStyle(
      fontSize: 12,
      color: Colors.black87,
      fontFamily: 'pretendard',
      fontWeight: FontWeight.w600,
    );

    canvas.drawCircle(
      center,
      radius + 4,
      Paint()
        ..color = const Color.fromARGB(255, 51, 51, 51).withOpacity(0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    for (final entry in legendItems.entries) {
      final paint = paints[entry.key]!;
      final offset = Offset(dx, size.height - 11);
      canvas.drawCircle(offset, circleSize / 2, paint);

      final tp = TextPainter(
        text: TextSpan(text: entry.value, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(dx + circleSize + 4, size.height - 17));
      dx += circleSize + spacing + tp.width + 12;
    }
  }

  double radians(double degree) => degree * pi / 180;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
