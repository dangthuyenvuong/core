import 'package:flutter/material.dart';

class OpacityEffect extends StatefulWidget {
  const OpacityEffect(
      {super.key,
      required this.child,
      this.duration = const Duration(milliseconds: 1000)});

  final Widget child;
  final Duration duration;
  @override
  State<OpacityEffect> createState() => _OpacityEffectState();
}

class _OpacityEffectState extends State<OpacityEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      },
    );
  }
}
