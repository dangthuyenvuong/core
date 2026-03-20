import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpacityTap extends StatefulWidget {
  const OpacityTap({
    super.key,
    required this.child,
    required this.onTap,
    this.disabled = false,
    this.onLongPress,
  });

  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool disabled;

  @override
  State<OpacityTap> createState() => _OpacityTapState();
}

class _OpacityTapState extends State<OpacityTap> {
  double _opacity = 1.0;
  DateTime? _tapDownTime;

  void _onTapDown(TapDownDetails details) {
    _tapDownTime = DateTime.now();
    setState(() {
      _opacity = 0.6; // Giảm opacity khi nhấn
    });
  }

  void _onTapUp(TapUpDetails details) {
    _onReset();
  }

  void _onTapCancel() {
    _onReset();
  }

  void _onReset() async {
    final now = DateTime.now();
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      _opacity = 1.0; // Khôi phục opacity khi hủy tap
    });
  }

  @override
  Widget build(BuildContext context) {
    // return CupertinoButton(
    //   padding: EdgeInsets.zero,
    //   minimumSize: Size(0, 0),
    //   child: widget.child,
    //   onPressed: widget.disabled ? null : widget.onTap,
    //   sizeStyle: CupertinoButtonSize.small,
    // );
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onLongPress: widget.onLongPress,
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
