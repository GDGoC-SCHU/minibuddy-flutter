import 'package:flutter/material.dart';
import 'package:minibuddy/models/emotion_distribution_model.dart';
import 'dart:math';

class EmotionDistributionPainter extends CustomPainter {
  final EmotionDistributionModel distribution;

  EmotionDistributionPainter(this.distribution);

  @override
  void paint(Canvas canvas, Size size) {
    const double gapAngle = 2.0; // 섹션 간 간격 각도
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.30; // 반경 10% 축소

    // 색상 정의
    final paints = {
      'normal': Paint()..color = Colors.green,
      'dep': Paint()..color = Colors.blue,
      'anx': Paint()..color = Colors.orange,
      'str': Paint()..color = Colors.red,
    };

    // 데이터 유효성 검사
    final total = (distribution.normal +
            distribution.dep +
            distribution.anx +
            distribution.str)
        .clamp(1, double.maxFinite.toInt()); // 0 division 방지

    // 비율 계산
    final ratios = {
      'normal': distribution.normal / total,
      'dep': distribution.dep / total,
      'anx': distribution.anx / total,
      'str': distribution.str / total,
    };

    double startAngle = -90.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 각 섹션 그리기
    for (final entry in ratios.entries) {
      if (entry.value > 0) {
        final sweepAngle = (entry.value * 360) - gapAngle;
        canvas.drawArc(
          rect,
          startAngle * pi / 180,
          sweepAngle * pi / 180,
          true,
          paints[entry.key]!,
        );
        startAngle += sweepAngle + gapAngle;
      }
    }

    // 경계선 추가 (작은 화면 가시성 향상)
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true; // 업데이트 활성화
}
