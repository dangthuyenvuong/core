import 'package:flutter/widgets.dart';

class HorizontalScroll extends StatelessWidget {
  const HorizontalScroll({
    super.key,
    required this.children,
    this.spacing = 0,
    this.padding = const EdgeInsets.symmetric(),
  });
  final List<Widget> children;
  final double spacing;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: padding,
        child: Row(
          spacing: spacing,
          children: children,
        ),
      ),
    );
  }
}
