import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class TextSlimmer extends StatelessWidget {
  const TextSlimmer({
    super.key,
    required this.child,
    required this.baseColor,
    required this.highlightColor,
    this.period = const Duration(milliseconds: 2000),
  });
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration period;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: period,
      child: child,
    );
  }
}
