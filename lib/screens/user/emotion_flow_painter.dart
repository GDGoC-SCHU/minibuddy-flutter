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

    // 🔧 회색 박스 높이를 살짝 줄여 날짜 영역 확보
    final graphBox = Rect.fromLTWH(
      0,
      padding,
      size.width - legendWidth - padding,
      size.height - padding * 3,
    );

    // 회색 박스 배경
    final Paint boxPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(graphBox, Radius.circular(12.r)),
      boxPaint,
    );

    // 그래프 선 색상 정의
    final Paint depPaint = Paint()
      ..color = const Color.fromARGB(255, 143, 172, 196)
      ..strokeWidth = 3.w
      ..style = PaintingStyle.stroke;
    final Paint anxPaint = Paint()
      ..color = const Color.fromARGB(255, 206, 136, 222)
      ..strokeWidth = 3.w
      ..style = PaintingStyle.stroke;
    final Paint strPaint = Paint()
      ..color = const Color.fromARGB(255, 250, 210, 78)
      ..strokeWidth = 3.w
      ..style = PaintingStyle.stroke;

    final Path depPath = Path();
    final Path anxPath = Path();
    final Path strPath = Path();

    final double xSpacing = graphBox.width / (flow.length + 1);
    final double graphTop = graphBox.top + 8.h;
    final double graphHeight = graphBox.height - 10.h;

    // 점 좌표 저장용 리스트
    final List<Offset> depPoints = [];
    final List<Offset> anxPoints = [];
    final List<Offset> strPoints = [];

    for (int i = 0; i < flow.length; i++) {
      final data = flow[i];
      final x = graphBox.left + xSpacing * (i + 1);

      final depY = graphTop + (30 - data.depScore) * (graphHeight / 30);
      final anxY = graphTop + (30 - data.anxScore) * (graphHeight / 30);
      final strY = graphTop + (30 - data.strScore) * (graphHeight / 30);

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

      // 날짜 텍스트
      final date = DateTime.parse(data.date);
      final label = DateFormat('MM/dd').format(date);
      final labelSpan = TextSpan(
        text: label,
        style: TextStyle(fontSize: 10.sp, color: Colors.grey[800]),
      );
      final labelPainter = TextPainter(
        text: labelSpan,
        textDirection: ui.TextDirection.ltr,
      )..layout();
      labelPainter.paint(
        canvas,
        Offset(x - labelPainter.width / 2, graphBox.bottom + 12.h),
      );

      // Today 텍스트
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

    // ⬇ 1. 선 먼저 그리기
    canvas.drawPath(depPath, depPaint);
    canvas.drawPath(anxPath, anxPaint);
    canvas.drawPath(strPath, strPaint);

    // ⬇ 2. 흰색 점은 마지막에 (맨 위에)
    final pointPaint = Paint()
      ..color = const Color.fromARGB(197, 255, 255, 255);
    for (final p in depPoints) {
      canvas.drawCircle(p, size.width * 0.008, pointPaint);
    }
    for (final p in anxPoints) {
      canvas.drawCircle(p, size.width * 0.008, pointPaint);
    }
    for (final p in strPoints) {
      canvas.drawCircle(p, size.width * 0.008, pointPaint);
    }

    // ⬇ 3. 지그재그 경고선
    final warningY = graphTop + (30 - 21) * (graphHeight / 30);
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
      ..color = Colors.red.withOpacity(1)
      ..strokeWidth = 4.w
      ..style = PaintingStyle.stroke;
    canvas.drawPath(zigzagPath, zigzagPaint);

    // ⬇ 4. 레전드
    final legends = [
      {'label': 'DEP', 'color': const Color.fromARGB(255, 143, 172, 196)},
      {'label': 'ANX', 'color': const Color.fromARGB(255, 206, 136, 222)},
      {'label': 'STR', 'color': const Color.fromARGB(255, 250, 210, 78)},
    ];

    final legendTextStyle = TextStyle(fontSize: 12.sp, color: Colors.black);
    final double legendStartY =
        graphBox.top + graphBox.height / 2 - legends.length * 10.h;

    for (int i = 0; i < legends.length; i++) {
      final legend = legends[i];
      final y = legendStartY + i * 20.h;

      final paint = Paint()..color = legend['color'] as Color;
      canvas.drawRect(Rect.fromLTWH(size.width - 50.w, y, 10.w, 10.w), paint);

      final textSpan = TextSpan(
        text: legend['label'] as String,
        style: legendTextStyle,
      );
      final tp = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(size.width - 35.w, y - 1.h));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
