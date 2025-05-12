import 'package:flutter/material.dart';
import 'package:minibuddy/models/emotion_flow_model.dart';

class EmotionFlowPainter extends CustomPainter {
  final List<EmotionFlowModel> flow; // List of EmotionFlowModel objects

  EmotionFlowPainter(this.flow);

  @override
  void paint(Canvas canvas, Size size) {
    final depPaint = Paint()
      ..color = Colors.blue // 우울감(Depression) 색상
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final anxPaint = Paint()
      ..color = Colors.green // 불안감(Anxiety) 색상
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final strPaint = Paint()
      ..color = Colors.red // 스트레스(Stress) 색상
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final depPath = Path();
    final anxPath = Path();
    final strPath = Path();

    for (int i = 0; i < flow.length; i++) {
      final data = flow[i]; // Accessing each EmotionFlowModel instance
      final x = (i + 1) *
          (size.width / (flow.length + 1)); // Distribute the points evenly

      // 우울감(Depression) Y 값 계산
      final depY = size.height - (data.depScore * (size.height / 10));

      // 불안감(Anxiety) Y 값 계산
      final anxY = size.height - (data.anxScore * (size.height / 10));

      // 스트레스(Stress) Y 값 계산
      final strY = size.height - (data.strScore * (size.height / 10));

      if (i == 0) {
        depPath.moveTo(x, depY);
        anxPath.moveTo(x, anxY);
        strPath.moveTo(x, strY);
      } else {
        depPath.lineTo(x, depY);
        anxPath.lineTo(x, anxY);
        strPath.lineTo(x, strY);
      }
    }

    // Draw the paths
    canvas.drawPath(depPath, depPaint); // Draw depression path
    canvas.drawPath(anxPath, anxPaint); // Draw anxiety path
    canvas.drawPath(strPath, strPaint); // Draw stress path
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
