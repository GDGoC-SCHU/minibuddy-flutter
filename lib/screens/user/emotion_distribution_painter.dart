import 'package:flutter/material.dart';
import 'package:minibuddy/models/emotion_distribution_model.dart';

class EmotionDistributionPainter extends CustomPainter {
  final EmotionDistributionModel distribution;

  EmotionDistributionPainter(this.distribution);

  @override
  void paint(Canvas canvas, Size size) {
    final paintNormal = Paint()..color = Colors.green;
    final paintDep = Paint()..color = Colors.blue;
    final paintAnx = Paint()..color = Colors.orange;
    final paintStr = Paint()..color = Colors.red;

    int total = distribution.normal +
        distribution.dep +
        distribution.anx +
        distribution.str;

    // Calculate proportions
    double normalRatio = distribution.normal / total;
    double depRatio = distribution.dep / total;
    double anxRatio = distribution.anx / total;
    double strRatio = distribution.str / total;

    double startAngle = -90.0;

    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);

    // Draw pie chart segments
    canvas.drawArc(rect, startAngle * 3.14159 / 180, normalRatio * 2 * 3.14159,
        true, paintNormal);
    startAngle += normalRatio * 360;

    canvas.drawArc(rect, startAngle * 3.14159 / 180, depRatio * 2 * 3.14159,
        true, paintDep);
    startAngle += depRatio * 360;

    canvas.drawArc(rect, startAngle * 3.14159 / 180, anxRatio * 2 * 3.14159,
        true, paintAnx);
    startAngle += anxRatio * 360;

    canvas.drawArc(rect, startAngle * 3.14159 / 180, strRatio * 2 * 3.14159,
        true, paintStr);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
