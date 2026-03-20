import 'package:core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ETab extends StatefulWidget {
  const ETab({
    super.key,
    this.tabs,
    this.onChangedTab,
    this.initialIndex = 0,
    this.controller,
    this.style = const TextStyle(fontSize: 16),
    this.height = 40,
    this.children,
    this.padding,
    this.borderBottom = true,
    this.isScrollable = true,
    this.insets = Spacing.small,
    this.actions,
    this.leading,
    this.spacing = Spacing.medium,
    // this.unselectedLabelStyle = const TextStyle(fontSize: 14)
  }) : assert(!(tabs != null && children != null),
            "tabs and children can be both valid");
  final List<String>? tabs;
  final List<Widget>? children;
  final Function(int)? onChangedTab;
  final int initialIndex;
  final TabController? controller;
  final TextStyle style;
  final double height;
  final EdgeInsetsGeometry? padding;
  final bool? borderBottom;
  final bool isScrollable;
  final double insets;
  final List<Widget>? actions;
  final Widget? leading;
  final double spacing;
  // final TextStyle unselectedLabelStyle;

  @override
  State<ETab> createState() => _ETabState();
}

class _ETabState extends State<ETab> with TickerProviderStateMixin {
  late TabController tabController;
  // late int itemCount;

  @override
  void initState() {
    super.initState();
    final itemCount = widget.tabs?.length ?? widget.children?.length ?? 0;
    tabController = widget.controller ??
        TabController(
            length: itemCount, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  void didUpdateWidget(covariant ETab oldWidget) {
    super.didUpdateWidget(oldWidget);
    final itemCount = widget.tabs?.length ?? widget.children?.length ?? 0;
    if (itemCount != tabController.length) {
      tabController = widget.controller ??
          TabController(
              length: itemCount,
              vsync: this,
              initialIndex: tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final len = widget.tabs?.length ?? widget.children?.length ?? 0;
    return Container(
      // padding: EdgeInsets.symmetric(
      //     horizontal: widget.padding?.horizontal ??
      //         Spacing.medium - (widget.padding?.horizontal ?? 0)),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: widget.borderBottom == true
            ? Border(
                bottom: BorderSide(color: onSurface.withAlpha(30)),
              )
            : null,
      ),
      child: Row(
        children: [
          if (widget.leading != null) widget.leading!,
          Expanded(
            child: TabBar(
              controller: tabController,
              isScrollable: widget.isScrollable,
              // indicatorPadding: EdgeInsets.symmetric(horizontal: 2),

              padding: EdgeInsets.symmetric(
                  horizontal: widget.padding?.horizontal ?? Spacing.medium),
              // physics: BouncingScrollPhysics(),
              tabAlignment: widget.isScrollable ? TabAlignment.start : null,
              dividerColor: Colors.transparent,
              indicatorColor: Color(0xFF4EA771),
              unselectedLabelColor: onSurface.withAlpha(150),
              labelColor: onSurface,
              // padding: EdgeInsets.only(left: 4, right: Spacing.medium),
              // labelPadding: widget.isScrollable
              //     ? EdgeInsets.symmetric(
              //         horizontal:
              //             widget.padding?.horizontal ?? Spacing.mediumSmall,
              //       )
              //     : null,
              labelPadding: EdgeInsets.only(
                right: widget.spacing,
                // left: widget.spacing,
              ),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.deepOrange, width: 3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                insets: EdgeInsets.symmetric(horizontal: widget.insets),
              ),
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                // letterSpacing: -,
                // color: onSurface,
              ).copyWith(
                color: widget.style.color,
                fontSize: widget.style.fontSize,
                fontWeight: widget.style.fontWeight,
                letterSpacing: widget.style.letterSpacing,
              ),
              // padding: tabBarOption?.padding,
              // indicatorPadding: EdgeInsets.only(bottom: 10),

              // unselectedLabelStyle: TextStyle(
              //   fontSize: 16,
              //   fontWeight: FontWeight.w600,
              //   color: onSurface,
              //   // color: Colors.white.withAlpha(150),
              // ).copyWith(
              //   // color: widget.unselectedLabelStyle.color,
              //   // fontSize: widget.unselectedLabelStyle.fontSize,
              //   // fontWeight: widget.unselectedLabelStyle.fontWeight,
              //   // letterSpacing: widget.unselectedLabelStyle.letterSpacing,
              // ),

              onTap: (index) {
                HapticFeedback.mediumImpact();
                widget.onChangedTab?.call(index);
              },
              // onTap: widget.onTabChanged,
              tabs: List.generate(
                len,
                (index) {
                  return Tab(
                    height: widget.height,
                    // iconMargin: EdgeInsets.only(right: Spacing.small),
                    // text: e,
                    child: widget.children?[index] ??
                        Text(widget.tabs?[index] ?? "",
                            style: TextStyle(letterSpacing: -0.5)),
                    // child: Text(
                    //   e,
                    //   style: TextStyle(
                    //     color: onSurface,
                    //   ).copyWith(
                    //     color: widget.style.color,
                    //   ),
                    // ),
                  );
                },
              ),
            ),
          ),
          if (widget.actions != null) ...widget.actions!,
        ],
      ),
    );
  }
}
