import 'package:core/core.dart';
import 'package:flutter/material.dart';

class Steps extends StatefulWidget {
  const Steps({
    super.key,
    required this.initialChild,
    this.pageController,
  });

  final Widget initialChild;
  final PageViewController? pageController;

  @override
  State<Steps> createState() => _StepStates();

  static Widget Step({
    String? title,
    required Widget child,
    Widget? leading,
    Widget? action,
  }) {
    return Column(
      children: [
        if (title != null) _Title(title, leading: leading, action: action),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            child: child,
          ),
        ),
      ],
    );
  }

  static Widget Title(
    String title, {
    Widget? action,
    Widget? leading,
  }) {
    return _Title(title, leading: leading, action: action);
  }
}

class _StepStates extends State<Steps> {
  late PageViewController pageController;

  @override
  void initState() {
    super.initState();
    pageController = widget.pageController ?? PageViewController();
  }

  @override
  Widget build(BuildContext context) {
    return SPageView(controller: pageController, child: widget.initialChild);
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title, {this.leading, this.action});

  final String title;
  final Widget? leading;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withAlpha(50),
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (leading != null)
          Positioned(
            left: 4,
            child: leading ?? SizedBox(),
          ),
        if (action != null)
          Positioned(
            right: 4,
            child: action ?? SizedBox(),
          ),
      ],
    );
  }
}
