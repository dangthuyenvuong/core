import 'package:flutter/material.dart';

class BorderGradient extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final double borderWidth;
  final bool enabled;
  final List<Color> colors;

  const BorderGradient(
      {super.key,
      required this.child,
      required this.color,
      required this.borderRadius,
      required this.borderWidth,
      this.enabled = true,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      // width: 200,
      // height: 200,
      child: Stack(
        children: [
          // Viền gradient
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: enabled ? colors : [],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white,
                    width: borderWidth), // Màu trắng sẽ bị thay bằng gradient
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          // Nội dung bên trong
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(
                  borderWidth), // Để viền gradient có hiệu ứng đẹp
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
