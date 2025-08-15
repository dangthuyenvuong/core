import 'package:flutter/material.dart';

class ZoomFadeIn extends StatefulWidget {
  const ZoomFadeIn({
    super.key,
    required this.child,
    this.curve = Curves.easeOutBack,
    this.duration = kThemeAnimationDuration,
  });
  final Widget child;
  final Curve curve;
  final Duration duration;

  @override
  State<ZoomFadeIn> createState() => ZoomFadeInState();
}

class ZoomFadeInState extends State<ZoomFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _controller.forward();
  }

  void _initAnimation() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);
    _scale = Tween<double>(begin: 1.2, end: 1.0).animate(curved);
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
  }

  void replay() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _fade,
        child: ScaleTransition(scale: _scale, child: widget.child));
  }
}
