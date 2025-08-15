import 'dart:ui';

import 'package:flutter/material.dart';

void showCupertinoPopupWithoutAnimation(BuildContext context, Widget child) {
  Navigator.of(context).push(
    _NoAnimationCupertinoPopupRoute(child: child),
  );
}

class _NoAnimationCupertinoPopupRoute extends PopupRoute<void> {
  final Widget child;

  _NoAnimationCupertinoPopupRoute({required this.child});

  @override
  Duration get transitionDuration => Duration(seconds: 1);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String get barrierLabel => 'Dismiss';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return SafeArea(
        child: Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            // child: Container(color: bg),
          ),
        ),
        child
      ],
    ));
  }
}
