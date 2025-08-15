import 'dart:math';

import 'package:flutter/material.dart';

enum SlideDirection {
  left,
  right,
}

class SDragable extends StatefulWidget {
  const SDragable({
    super.key,
    required this.child,
    this.onSlideOut,
    this.onPressed,
    required this.isEnabledDrag,
    this.velocity = 1000,
    this.outSizeLimit,
    this.outSizeLimitPercent = 0.65,
    this.direction,
  });

  final Widget Function(BuildContext context, SlideDirection? direction) child;
  final ValueChanged<SlideDirection>? onSlideOut;
  final VoidCallback? onPressed;
  final bool isEnabledDrag;
  final double velocity;
  final double? outSizeLimit;
  final double outSizeLimitPercent;
  final SlideDirection? direction;

  @override
  State<SDragable> createState() => _SDragableState();
}

class _SDragableState extends State<SDragable>
    with SingleTickerProviderStateMixin {
  late AnimationController restoreController;

  final _widgetKey = GlobalKey();

  Offset startOffset = Offset.zero;
  Offset panOffset = Offset.zero;
  Size size = Size.zero;
  late Size screenSize;
  double angle = 0;
  SlideDirection? direction;

  bool itWasMadeSlide = false;
  double get outSizeLimit =>
      widget.outSizeLimit ?? widget.outSizeLimitPercent * size.width;

  void onPanStart(DragStartDetails details) {
    if (!restoreController.isAnimating) {
      setState(() {
        startOffset = details.globalPosition;
      });
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (!restoreController.isAnimating) {
      final velocityX = details.delta.dx;
      final positionX = currentPosition.dx;

      final endX = startOffset.dx - details.globalPosition.dx;
      direction = null;
      if (velocityX < -widget.velocity ||
          endX.abs() >= outSizeLimit && endX > 0) {
        direction = SlideDirection.left;
        itWasMadeSlide = widget.onSlideOut != null;
      }
      if (velocityX > widget.velocity ||
          endX.abs() >= outSizeLimit && endX < 0) {
        direction = SlideDirection.right;
        itWasMadeSlide = widget.onSlideOut != null;
      }

      setState(() {
        panOffset = details.globalPosition - startOffset;
        angle = currentAngle;
      });
    }
  }

  void onPanEnd(DragEndDetails details) {
    if (restoreController.isAnimating) {
      return;
    }

    final velocityX = details.velocity.pixelsPerSecond.dx;
    final positionX = currentPosition.dx;

    final endX = startOffset.dx - details.globalPosition.dx;

    direction = null;
    if (velocityX < -widget.velocity ||
        endX.abs() >= outSizeLimit && endX > 0) {
      // widget.onSlideOut?.call(SlideDirection.left);
      // direction = SlideDirection.left;
      // itWasMadeSlide = widget.onSlideOut != null;
      slideOut(SlideDirection.left);
    }
    if (velocityX > widget.velocity || endX.abs() >= outSizeLimit && endX < 0) {
      // widget.onSlideOut?.call(SlideDirection.right);
      // direction = SlideDirection.right;
      // itWasMadeSlide = widget.onSlideOut != null;
      slideOut(SlideDirection.right);
    }

    restoreController.forward();
  }

  void slideOut(SlideDirection direction) {
    widget.onSlideOut?.call(direction);
    this.direction = direction;
    itWasMadeSlide = widget.onSlideOut != null;
  }

  void restoreAnimationListener() {
    if (restoreController.isCompleted) {
      restoreController.reset();
      panOffset = Offset.zero;
      itWasMadeSlide = false;
      angle = 0;
      setState(() {});
    }
  }

  Offset get currentPosition {
    final renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  }

  double get currentAngle {
    return currentPosition.dx < 0
        ? (pi * 0.2) * currentPosition.dx / size.width
        : currentPosition.dx + size.width > screenSize.width
            ? (pi * 0.2) *
                (currentPosition.dx + size.width - screenSize.width) /
                size.width
            : 0;
  }

  void getChildSize() {
    size =
        (_widgetKey.currentContext?.findRenderObject() as RenderBox?)?.size ??
            Size.zero;
  }

  @override
  void initState() {
    super.initState();

    restoreController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..addListener(restoreAnimationListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenSize = MediaQuery.of(context).size;
      getChildSize();
    });
  }

  // @override
  // void didUpdateWidget(SDragable oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.direction != widget.direction) {
  //     if (widget.direction != null) {
  //       if (widget.direction == SlideDirection.left) {
  //         setState(() {
  //           panOffset = Offset(-size.width, 0);
  //           angle = -pi * 0.2;
  //         });
  //       } else {
  //         setState(() {
  //           panOffset = Offset(size.width, 0);
  //           angle = pi * 0.2;
  //         });
  //       }

  //       // slideOut(widget.direction!);
  //     }
  //   }
  // }

  @override
  void dispose() {
    restoreController
      ..removeListener(restoreAnimationListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
        key: _widgetKey,
        child: widget.child(context, itWasMadeSlide ? direction : null));
    if (!widget.isEnabledDrag) {
      return child;
    }

    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: AnimatedBuilder(
        animation: restoreController,
        builder: (context, child) {
          final value = 1 - restoreController.value;
          return Transform.translate(
            offset: panOffset * value,
            child: Transform.rotate(
              angle: angle * (itWasMadeSlide ? 1 : value),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}
