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

    // Adjusting the graph size and position
    double graphHeight =
        size.height * 0.7; // Graph height: 70% of available height
    double graphTopPosition =
        size.height * 0.2; // Graph starts 20% from the top

    for (int i = 0; i < flow.length; i++) {
      final data = flow[i]; // Accessing each EmotionFlowModel instance
      final x = (i + 1) *
          (size.width / (flow.length + 1)); // Distribute the points evenly

      // Adjusting Y values according to new graph height
      final depY = graphTopPosition + (data.depScore * (graphHeight / 10));
      final anxY = graphTopPosition + (data.anxScore * (graphHeight / 10));
      final strY = graphTopPosition + (data.strScore * (graphHeight / 10));

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

    // Draw the paths for each emotion category
    canvas.drawPath(depPath, depPaint); // Draw depression path
    canvas.drawPath(anxPath, anxPaint); // Draw anxiety path
    canvas.drawPath(strPath, strPaint); // Draw stress path

    // Add category labels for each graph (Legend)
    final textStyle = TextStyle(
        color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);

    final depLabel = TextSpan(text: 'Depression', style: textStyle);
    final anxLabel = TextSpan(text: 'Anxiety', style: textStyle);
    final strLabel = TextSpan(text: 'Stress', style: textStyle);

    final textPainterDep = TextPainter(
        text: depLabel,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: size.width);
    final textPainterAnx = TextPainter(
        text: anxLabel,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: size.width);
    final textPainterStr = TextPainter(
        text: strLabel,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: size.width);

    // Positioning the labels just above the graph
    textPainterDep.paint(
        canvas,
        Offset(size.width / 4 - textPainterDep.width / 2,
            graphTopPosition - 15)); // Depression label
    textPainterAnx.paint(
        canvas,
        Offset(size.width / 2 - textPainterAnx.width / 2,
            graphTopPosition - 15)); // Anxiety label
    textPainterStr.paint(
        canvas,
        Offset(3 * size.width / 4 - textPainterStr.width / 2,
            graphTopPosition - 15)); // Stress label
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
