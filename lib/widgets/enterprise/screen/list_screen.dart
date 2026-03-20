import 'dart:math';
import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListTemplate extends StatelessWidget {
  const ListTemplate({
    super.key,
    this.actions = const [],
    required this.itemBuilder,
    this.itemCount,
    this.crossAxisCount = 1,
    this.mainAxisExtent,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.empty,
    this.isLoading = false,
    // this.leading,
    this.afterAppBar,
    this.expandedHeight = 50,
    this.isShowSearch = true,
    this.padding = const EdgeInsets.all(Spacing.medium),
    this.title,
  });
  final List<Widget> actions;
  final Widget Function(BuildContext, int) itemBuilder;
  final int? itemCount;
  final int crossAxisCount;
  final double? mainAxisExtent;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final Widget? empty;
  final bool isLoading;
  // final Widget? leading;
  final Widget? afterAppBar;
  final double expandedHeight;
  final bool isShowSearch;
  final EdgeInsets padding;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            pinned: true,
            // floating: true,
            // leading: SizedBox(),
            actions: [SizedBox()],
            automaticallyImplyLeading: false,
            toolbarHeight: expandedHeight,
            // expandedHeight: expandedHeight,
            // toolbarHeight: 180,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  color: bg.withAlpha(100),
                  padding: EdgeInsets.only(
                    // left: Spacing.medium,
                    // right: actions.isEmpty ? Spacing.medium : 0,
                    top:
                        max(MediaQuery.of(context).padding.top, Spacing.medium),
                    // bottom: Spacing.small,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconBack(),
                          if (title != null) title!,
                          if (isShowSearch)
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(
                                right: actions.isEmpty ? Spacing.medium : 0,
                              ),
                              child: InputSearch(
                                hintText: "Search",
                              ),
                            )
                                // child: Container(
                                //   padding: EdgeInsets.only(
                                //     left: Spacing.medium,
                                //     right: Spacing.small,
                                //     top: Spacing.xSmall,
                                //     bottom: Spacing.xSmall,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     color: onSurface.withAlpha(20),
                                //     borderRadius: BorderRadius.circular(999),
                                //   ),
                                //   child: Row(
                                //     spacing: Spacing.small,
                                //     children: [
                                //       Expanded(
                                //         child: TextField(
                                //           decoration: InputDecoration(
                                //             // contentPadding: EdgeInsets.only(left: Spacing.medium),
                                //             isDense: true,
                                //             hintText: "Search",
                                //             hintStyle: TextStyle(
                                //               color: onSurface.withAlpha(100),
                                //             ),
                                //             border: InputBorder.none,
                                //             // suffixIcon: Icon(Icons.search, color: onSurface.withAlpha(100)),
                                //           ),
                                //         ),
                                //       ),
                                //       Icon(
                                //         Icons.search,
                                //         color: onSurface.withAlpha(100),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                ),
                          ...actions,
                          // _BtnFilter(),
                          // SIconButton(
                          //   onTap: () {},
                          //   child: Icon(
                          //     CupertinoIcons.plus,
                          //     color: onSurface.withAlpha(100),
                          //   ),
                          // ),
                        ],
                      ),
                      if (afterAppBar != null) afterAppBar!,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // if (leading != null) leading!,
          if (isLoading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (itemCount == 0)
            SliverFillRemaining(
              hasScrollBody: false,
              child: empty,
            ),
          if (itemCount != 0)
            SliverPadding(
              padding: padding,
              sliver: crossAxisCount == 1
                  ? SliverList.separated(
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: crossAxisCount,
                      //   mainAxisSpacing: mainAxisSpacing,
                      //   crossAxisSpacing: crossAxisSpacing,
                      //   // childAspectRatio: 0.5,
                      //   mainAxisExtent: mainAxisExtent,
                      // ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: mainAxisSpacing),
                      itemBuilder: (context, index) =>
                          itemBuilder(context, index),
                      itemCount: itemCount,
                    )
                  : SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: mainAxisSpacing,
                        crossAxisSpacing: crossAxisSpacing,
                        // childAspectRatio: 0.5,
                        mainAxisExtent: mainAxisExtent,
                      ),
                      itemBuilder: (context, index) =>
                          itemBuilder(context, index),
                      itemCount: itemCount,
                    ),
            ),
        ],
      ),
    );
  }
}
