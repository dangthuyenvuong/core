import 'package:flutter/material.dart';

class BounceEffect extends StatefulWidget {
  const BounceEffect({
    super.key,
    required this.enabled,
    this.autoEnable = false,
    this.duration = const Duration(milliseconds: 150),
    this.child,
    this.builder,
    this.onChanged,
  });
  final bool enabled;
  final bool autoEnable;
  final Duration? duration;
  final Widget? child;
  final Function(bool enabled)? builder;
  final Function(bool value)? onChanged;

  @override
  State<BounceEffect> createState() => _BounceEffectState();
}

class _BounceEffectState extends State<BounceEffect>
    with SingleTickerProviderStateMixin {
  bool _enabled = false;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _enabled = widget.enabled;
    _animationController = AnimationController(
      reverseDuration: widget.duration,
      duration: widget.duration,
      vsync: this,
      value: _enabled ? 1 : 0,
    );

    _bounceAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.bounceOut,
      reverseCurve: Curves.easeInSine,
    );

    if (widget.autoEnable) {
      forward();
    }
  }

  void forward() {
    _enabled = !_enabled;
    if (_enabled) {
      _animationController?.forward();
    } else {
      _animationController?.reverse();
    }
    widget.onChanged?.call(_enabled);
    setState(() {});
  }


  @override
  void didUpdateWidget(BounceEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      setState(() {
        _enabled = widget.enabled;
      });

      if (widget.enabled) {
        _animationController?.forward();
      }else {
        _animationController?.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation!,
      builder: (context, child) {
        return Transform.scale(
            scale: _enabled
                ? _bounceAnimation!.value
                : (1 - _bounceAnimation!.value),
            child: widget.builder?.call(_enabled) ?? child);
      },
      child: widget.builder?.call(_enabled) ?? widget.child,
    );
  }
}
