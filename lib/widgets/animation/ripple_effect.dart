import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RippleEffect extends StatefulWidget {
  @override
  _RippleEffectState createState() => _RippleEffectState();

  const RippleEffect(
      {super.key,
      required this.svgPath,
      this.color,
      this.size = 24,
      this.onTap});

  final String svgPath;
  final Color? color;
  final double size;
  final Function()? onTap;
}

class _RippleEffectState extends State<RippleEffect>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _rippleAnimations;

  @override
  void initState() {
    super.initState();

    // Số vòng ripple
    const int rippleCount = 3;

    _controllers = List.generate(
      rippleCount,
      (index) => AnimationController(
        duration: kThemeAnimationDuration + Duration(milliseconds: index * 100),
        vsync: this,
      )..addStatusListener((status) {
          // Revert lại sau khi kết thúc
          if (status == AnimationStatus.completed) {
            Future.delayed(Duration(milliseconds: 200), () {
              _controllers[index].reverse();
            });
          }
        }),
    );

    _rippleAnimations = _controllers.asMap().entries.map((entites) {
      final index = entites.key;
      final controller = entites.value;
      return Tween<double>(begin: 1, end: 1.2 + index * 0.4).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startRipple() {
    widget.onTap?.call();
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        _controllers[i].forward(from: 0.0); // Khởi động từng ripple theo thứ tự
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startRipple,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Hiệu ứng ripple
          ..._rippleAnimations.map((animation) {
            final index = _rippleAnimations.indexOf(animation);
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: animation.value,
                  child: Opacity(
                    opacity: 0.3,
                    child: child,
                  ),
                );
              },
              child: SvgPicture.asset(
                widget.svgPath,
                width: widget.size,
                height: widget.size,
                colorFilter: widget.color != null
                    ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                    : null,
              ),
            );
          }).toList(),
          // Nút Like
          SvgPicture.asset(
            widget.svgPath,
            width: widget.size,
            height: widget.size,
            colorFilter: widget.color != null
                ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                : null,
          ),
        ],
      ),
    );
  }
}

class RippleEffect2 extends StatefulWidget {
  @override
  _RippleEffect2State createState() => _RippleEffect2State();

  const RippleEffect2(
      {super.key,
      // this.onTap,
      required this.activeIcon,
      required this.inactiveIcon,
      this.isActive = false});

  // final Function()? onTap;
  final Widget activeIcon;
  final Widget inactiveIcon;
  final bool isActive;
}

class _RippleEffect2State extends State<RippleEffect2>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _rippleAnimations;

  @override
  void initState() {
    super.initState();

    // Số vòng ripple
    const int rippleCount = 3;

    _controllers = List.generate(
      rippleCount,
      (index) => AnimationController(
        duration: kThemeAnimationDuration + Duration(milliseconds: index * 100),
        vsync: this,
      )..addStatusListener((status) {
          // Revert lại sau khi kết thúc
          if (status == AnimationStatus.completed) {
            Future.delayed(Duration(milliseconds: 200), () {
              _controllers[index].reverse();
            });
          }
        }),
    );

    _rippleAnimations = _controllers.asMap().entries.map((entites) {
      final index = entites.key;
      final controller = entites.value;
      return Tween<double>(begin: 1, end: 1.2 + index * 0.4).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(RippleEffect2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      _startRipple();
    }
  }

  void _startRipple() {
    // widget.onTap?.call();
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].reset();

      Future.delayed(Duration(milliseconds: i * 50), () {
        _controllers[i].forward(from: 0.0); // Khởi động từng ripple theo thứ tự
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startRipple,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          widget.inactiveIcon,
          // Hiệu ứng ripple
          ..._rippleAnimations.map((animation) {
            final index = _rippleAnimations.indexOf(animation);
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: animation.value,
                  child: child,
                );
              },
              child: Opacity(
                opacity: widget.isActive ? 1 : 0,
                child: widget.activeIcon,
              ),
            );
          }).toList(),
          // Nút Like
        ],
      ),
    );
  }
}
