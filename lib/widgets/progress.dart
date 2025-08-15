import 'package:flutter/material.dart';

class SProgress extends StatelessWidget {
  final int current;
  final int total;
  final bool rounded;
  final Color? color;
  final Color? backgroundColor;
  final double height;

  SProgress({
    required this.current,
    required this.total,
    this.rounded = false,
    this.color,
    this.backgroundColor,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: height,
          color: backgroundColor,
        ),
        Positioned.fill(
          child: FractionallySizedBox(
            widthFactor: current / total,
            child: Container(
              height: height,
              color: color,
            ),
          ),
        )
      ],
    );
  }
}
