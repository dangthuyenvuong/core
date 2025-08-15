import 'package:flutter/material.dart';

class OpacityTap extends StatefulWidget {
  const OpacityTap({
    super.key,
    required this.child,
    required this.onTap,
    this.disabled = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  State<OpacityTap> createState() => _OpacityTapState();
}

class _OpacityTapState extends State<OpacityTap> {
  double _opacity = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _opacity = 0.6; // Giảm opacity khi nhấn
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _opacity = 1.0; // Khôi phục opacity khi thả tay
    });
  }

  void _onTapCancel() {
    setState(() {
      _opacity = 1.0; // Khôi phục opacity khi hủy tap
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.disabled ? null : widget.onTap,
      child: Opacity(
        opacity: widget.disabled ? 0.5 : _opacity,
        child: widget.child,
      ),
    );
  }
}
