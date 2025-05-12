// import 'package:flutter/material.dart';
// import 'package:minibuddy/models/emotion_flow_model.dart';

// class EmotionFlowPainter extends CustomPainter {
//   final EmotionFlowModel flow;

//   EmotionFlowPainter(this.flow);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     final path = Path();
//     for (int i = 0; i < flow.EmotionFlowModel.length; i++) {
//       final data = flow.flowDEmotionFlowModelata[i];
//       final x = (i + 1) * (size.width / flow.flowDEmotionFlowModelata.length);
//       final y = size.height -
//           (data.depScore * (size.height / 10)); // Adjusting based on scale

//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
