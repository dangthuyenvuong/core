import 'package:flutter/material.dart';

class SReorderableListView extends StatelessWidget {
  const SReorderableListView(
      {super.key,
      this.enabled = true,
      this.padding,
      required this.onReorder,
      this.proxyDecorator,
      this.physics,
      this.shrinkWrap = false,
      required this.itemCount,
      required this.itemBuilder});
  final EdgeInsets? padding;
  final void Function(int, int) onReorder;
  final Widget Function(Widget, int, Animation<double>)? proxyDecorator;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return ListView.builder(
        padding: padding,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        shrinkWrap: shrinkWrap,
        physics: physics,
      );
    }

    return ReorderableListView.builder(
      padding: padding,
      onReorder: onReorder,
      proxyDecorator: proxyDecorator,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
