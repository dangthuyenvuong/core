import 'package:flutter/material.dart';

class HighlightTap extends StatefulWidget {
  const HighlightTap({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.disabled = false,
    this.highlightColor,
    this.highlightAlpha = 50,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool disabled;
  final Color? highlightColor;
  final int? highlightAlpha;
  final BorderRadius? borderRadius;

  @override
  State<HighlightTap> createState() => _HighlightTapState();
}

class _HighlightTapState extends State<HighlightTap> {
  int _alpha = 0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _alpha = widget.highlightAlpha ?? 50; // Giảm opacity khi nhấn
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _alpha = 0; // Khôi phục opacity khi thả tay
    });
  }

  void _onTapCancel() {
    setState(() {
      _alpha = 0; // Khôi phục opacity khi hủy tap
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;
    final highlightColor =
        widget.highlightColor ?? (isDarkMode ? Colors.white : Colors.black);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: widget.onLongPress,
      onTap: widget.disabled ? null : widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: highlightColor.withAlpha(_alpha),
          borderRadius: widget.borderRadius,
        ),
        child: widget.child,
      ),
    );
  }
}
