import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:minibuddy/models/emotion_flow_model.dart';
import 'dart:ui' as ui;

class EmotionFlowPainter extends CustomPainter {
  final List<EmotionFlowModel> flow;

  EmotionFlowPainter(this.flow);

  @override
  void paint(Canvas canvas, Size size) {
    final padding = 12.w;
    final legendWidth = 50.w;

    final graphBox = Rect.fromLTWH(
      0,
      padding,
      size.width - legendWidth - padding,
      size.height - padding * 3,
    );

    final Paint boxPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(graphBox, Radius.circular(12.r)),
      boxPaint,
    );

    if (flow.isEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'No records from the past 7 days.',
          style: TextStyle(
            fontSize: 14.sp,
            height: 1.6,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
            color: Colors.grey[700],
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      )..layout(maxWidth: graphBox.width - 32.w);

      final offset = Offset(
        graphBox.left + (graphBox.width - textPainter.width) / 2,
        graphBox.top + (graphBox.height - textPainter.height) / 2,
      );

      textPainter.paint(canvas, offset);
      return;
    }

    final Paint depPaint = Paint()
      ..color = const Color.fromARGB(2200, 51, 102, 204)
      ..strokeWidth = 3.w
      ..style = PaintingStyle.stroke;
    final Paint anxPaint = Paint()
      ..color = const Color.fromARGB(200, 255, 153, 0)
      ..strokeWidth = 3.w
      ..style = PaintingStyle.stroke;
    final Paint strPaint = Paint()
      ..color = const Color.fromARGB(200, 204, 0, 51)
      ..strokeWidth = 3.w
      ..style = PaintingStyle.stroke;

    final Path depPath = Path();
    final Path anxPath = Path();
    final Path strPath = Path();

    final double xSpacing = graphBox.width / (flow.length + 1);
    final double graphTop = graphBox.top + 8.h;
    final double graphHeight = graphBox.height - 10.h;

    const double yRange = 34; //여백 확보
    final double unitHeight = graphHeight / yRange;

    final List<Offset> depPoints = [];
    final List<Offset> anxPoints = [];
    final List<Offset> strPoints = [];

    for (int i = 0; i < flow.length; i++) {
      final data = flow[i];
      final x = graphBox.left + xSpacing * (i + 1);

      final depY = graphTop + (31 - data.depScore) * unitHeight;
      final anxY = graphTop + (31 - data.anxScore) * unitHeight;
      final strY = graphTop + (31 - data.strScore) * unitHeight;

      if (i == 0) {
        depPath.moveTo(x, depY);
        anxPath.moveTo(x, anxY);
        strPath.moveTo(x, strY);
      } else {
        depPath.lineTo(x, depY);
        anxPath.lineTo(x, anxY);
        strPath.lineTo(x, strY);
      }

      depPoints.add(Offset(x, depY));
      anxPoints.add(Offset(x, anxY));
      strPoints.add(Offset(x, strY));

      final date = DateTime.parse(data.date);
      final label = DateFormat('M/d').format(date);
      final labelSpan = TextSpan(
        text: label,
        style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey[800],
            fontWeight: FontWeight.w600),
      );
      final labelPainter = TextPainter(
        text: labelSpan,
        textDirection: ui.TextDirection.ltr,
      )..layout();
      labelPainter.paint(
        canvas,
        Offset(x - labelPainter.width / 2, graphBox.bottom + 12.h),
      );

      if (i == flow.length - 1) {
        final highestY = [depY, anxY, strY].reduce((a, b) => a < b ? a : b);
        final todaySpan = TextSpan(
          text: 'Today!',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black,
            fontFamily: 'pretendard',
            fontWeight: FontWeight.w800,
          ),
        );
        final tp = TextPainter(
          text: todaySpan,
          textAlign: TextAlign.center,
          textDirection: ui.TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, highestY - 25.h));
      }
    }

    canvas.drawPath(depPath, depPaint);
    canvas.drawPath(anxPath, anxPaint);
    canvas.drawPath(strPath, strPaint);

    final pointPaint = Paint()..color = const Color.fromARGB(197, 0, 0, 0);
    for (final p in depPoints) {
      canvas.drawCircle(p, size.width * 0.008, pointPaint);
    }
    for (final p in anxPoints) {
      canvas.drawCircle(p, size.width * 0.008, pointPaint);
    }
    for (final p in strPoints) {
      canvas.drawCircle(p, size.width * 0.008, pointPaint);
    }

    final warningY = graphTop + (31 - 21) * unitHeight;
    final zigzagPath = Path()..moveTo(graphBox.left, warningY);
    const double zigzagHeight = 6;
    const double zigzagSpacing = 10;
    for (double x = graphBox.left; x < graphBox.right; x += zigzagSpacing) {
      zigzagPath.lineTo(
        x,
        warningY +
            (x ~/ zigzagSpacing % 2 == 0 ? -zigzagHeight : zigzagHeight).h,
      );
    }
    final Paint zigzagPaint = Paint()
      ..color = const Color.fromARGB(191, 255, 17, 0)
      ..strokeWidth = 4.w
      ..style = PaintingStyle.stroke;
    canvas.drawPath(zigzagPath, zigzagPaint);

    final legends = [
      {'label': 'DEP', 'color': const Color.fromARGB(200, 51, 102, 204)},
      {'label': 'ANX', 'color': const Color.fromARGB(200, 255, 153, 0)},
      {'label': 'STR', 'color': const Color.fromARGB(200, 204, 0, 51)},
      {'label': 'RISK', 'type': 'zigzag'},
    ];

    final legendTextStyle = TextStyle(
        fontSize: 12,
        color: Colors.black87,
        fontFamily: 'pretendard',
        fontWeight: FontWeight.w600);

    final double legendStartY =
        graphBox.top + graphBox.height / 2 - legends.length * 10.h;

    for (int i = 0; i < legends.length; i++) {
      final legend = legends[i];
      final y = legendStartY + i * 20.h;

      if (legend['type'] == 'zigzag') {
        final zigzagLegendPath = Path()..moveTo(size.width - 50.w, y + 5.h);
        for (double x = 0; x <= 12; x += 6) {
          final isUp = (x ~/ 6) % 2 == 0;
          zigzagLegendPath.lineTo(
            size.width - 50.w + x,
            y + 5.h + (isUp ? -3 : 3),
          );
        }
        final Paint zigzagLegendPaint = Paint()
          ..color = const Color.fromARGB(191, 255, 17, 0)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        canvas.drawPath(zigzagLegendPath, zigzagLegendPaint);
      } else {
        final paint = Paint()..color = legend['color'] as Color;
        canvas.drawRect(Rect.fromLTWH(size.width - 50.w, y, 10.w, 10.w), paint);
      }

      final tp = TextPainter(
        text: TextSpan(text: '${legend['label']}', style: legendTextStyle),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(size.width - 35.w, y - 1.h));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
