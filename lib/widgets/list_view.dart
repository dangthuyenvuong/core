import 'package:flutter/material.dart';

class SListViewBuilder extends StatelessWidget {
  Widget? Function(BuildContext, int) itemBuilder;
  final int itemCount;
  double spacing;

  SListViewBuilder({
    required this.itemBuilder,
    this.itemCount = 1,
    this.spacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemBuilder: (context, index) {
        return Column(
          children: [
            itemBuilder(context, index) ?? SizedBox.shrink(),
            SizedBox(height: index < itemCount - 1 ? spacing : 0),
          ],
        );
      },
      itemCount: itemCount,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}

class SList extends StatelessWidget {
  const SList(
      {super.key,
      this.rowCount = 1,
      this.columnCount,
      required this.itemBuilder,
      this.children});
  final int rowCount;
  final int? columnCount;
  final Widget Function(BuildContext, int)? itemBuilder;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Column(
        // children: rowCount > 1
        //     ? List.generate(children, (index) => SizedBox(height: spacing))
        //     : [],
        );
  }
}
