import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final Widget? child;
  final double? radius;
  final bool? enabled;
  final double? width;
  final double? height;

  const Skeleton(
      {super.key,
      this.child,
      this.radius = 4,
      this.enabled = true,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    if (!enabled!) {
      return child ?? SizedBox.shrink();
    }

    return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.white.withOpacity(0.4),
        child: Container(
          width: width,
          height: height,
          child: Opacity(
            opacity: 0,
            child: child ?? SizedBox.shrink(),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius ?? 0),
          ),
        ));
  }
}

class ListSkeleton extends StatelessWidget {
  final int count;
  final Widget skeleton;
  final double? gap;

  const ListSkeleton(
      {super.key, required this.count, required this.skeleton, this.gap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: gap ?? 0,
      runSpacing: gap ?? 0,
      children: List.generate(count, (index) => skeleton),
    );
  }
}
