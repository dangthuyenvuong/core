import 'dart:ui';

import 'package:flutter/material.dart';

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final BoxShape shape;
  final double radius;

  _DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.dashLength = 5.0,
    this.gapLength = 3.0,
    this.shape = BoxShape.rectangle,
    this.radius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (shape == BoxShape.circle) {
      path.addOval(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width,
          height: size.height,
        ),
      );
    } else {
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
      path.addRRect(rrect);
    }

    final dashPath = _createDashedPath(path, dashLength, gapLength);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashLength, double gapLength) {
    final Path path = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double next = distance + dashLength;
        path.addPath(metric.extractPath(distance, next), Offset.zero);
        distance = next + gapLength;
      }
    }
    return path;
  }

  // @override
  // bool shouldRepaint(CustomPainter oldDelegate) => false;
  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) {
    return color != old.color ||
        strokeWidth != old.strokeWidth ||
        dashLength != old.dashLength ||
        gapLength != old.gapLength ||
        shape != old.shape ||
        radius != old.radius;
  }
}

class DashedBorderPainter extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final BoxShape shape;
  final double radius;
  final Widget child;

  DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.dashLength = 5.0,
    this.gapLength = 3.0,
    this.shape = BoxShape.rectangle,
    this.radius = 0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
        shape: shape,
        radius: radius,
      ),
      child: child,
    );
  }
}
