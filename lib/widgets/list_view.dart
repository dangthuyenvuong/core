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
