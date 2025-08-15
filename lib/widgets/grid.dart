import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

class SGrid extends StatefulWidget {
  const SGrid({
    super.key,
    this.spacing = Spacing.medium,
    required this.children,
    this.crossAxisCount = 2,
    this.maxItemWidth,
  });
  final double spacing;
  final List<Widget> children;
  final int? crossAxisCount;
  final double? maxItemWidth;

  @override
  State<SGrid> createState() => _SGridState();
}

class _SGridState extends State<SGrid> {
  int crossAxisCount = 1;
  bool isLoaded = false;
  final GlobalKey gridViewKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    crossAxisCount = widget.crossAxisCount ?? 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoaded = true;

      final RenderBox renderBox =
          gridViewKey.currentContext!.findRenderObject() as RenderBox;
      if (widget.maxItemWidth != null) {
        crossAxisCount = renderBox.size.width ~/ widget.maxItemWidth!;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLoaded ? 1 : 0,
      child: GridView.count(
          key: gridViewKey,
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          mainAxisSpacing: widget.spacing,
          crossAxisSpacing: widget.spacing,
          physics: NeverScrollableScrollPhysics(),
          children: widget.children),
    );
  }
}
