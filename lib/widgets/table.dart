import 'package:core/core.dart';
import 'package:flutter/material.dart';

class STable<T> extends StatelessWidget {
  const STable(
      {super.key,
      required this.items,
      required this.buildItem,
      this.header,
      this.footer});
  final List<T> items;
  final Widget Function(T item, int index) buildItem;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Container(
              height: 40,
              // padding: const EdgeInsets.symmetric(
              //   horizontal: Spacing.medium,
              //   // vertical: Spacing.small,
              // ),
              decoration: BoxDecoration(color: onSurface.withAlpha(30)),
              child: DefaultTextStyle(
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    // color: onSurface.withAlpha(100),
                  ),
                  child: header!),
            ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              var bg = index % 2 != 0 ? onSurface.withAlpha(10) : null;
              return Container(
                height: 40,
                // padding: const EdgeInsets.symmetric(
                //   horizontal: Spacing.medium,
                // ),
                decoration: BoxDecoration(color: bg),
                child: buildItem(items[index], index),
              );
            },
          ),
          if (footer != null)
            Container(
              height: 40,
              // padding: const EdgeInsets.symmetric(
              //   horizontal: Spacing.medium,
              // ),
              decoration: BoxDecoration(color: onSurface.withAlpha(30)),
              child: DefaultTextStyle(
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    color: onSurface.withAlpha(100),
                  ),
                  child: footer!),
            ),
        ],
      ),
    );
  }
}
