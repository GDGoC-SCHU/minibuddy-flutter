import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaveformWidget extends StatefulWidget {
  const WaveformWidget({super.key});

  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  List<double> barHeights = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {
          barHeights = List.generate(
            barHeights.length,
            (_) => 10.h + _random.nextDouble() * 30.h,
          );
        });
      });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;

        final double barWidth = 3.w;
        final double spacing = 3.w;

        final int barCount = (totalWidth / (barWidth + spacing)).floor();

        if (barHeights.length != barCount) {
          barHeights = List.generate(
            barCount,
            (_) => 10.h + _random.nextDouble() * 30.h,
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: barHeights
              .map(
                (height) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                  child: Container(
                    width: barWidth,
                    height: height,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 208, 106),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
