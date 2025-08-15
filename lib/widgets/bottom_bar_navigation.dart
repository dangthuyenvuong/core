import 'package:core/core.dart';
// import 'package:english_mobile/src/constants/data.dart';
// import 'package:english_mobile/src/controllers/word.controller.dart';
// import 'package:english_mobile/src/core/widgets/animation/bounce_effect.dart';
// import 'package:english_mobile/src/screens/main/add/add.screen.dart';
// import 'package:english_mobile/src/screens/main/add/add.screen_v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class _MyContext extends InheritedWidget {
  final int length;
  final String selected;
  final Function(String name) onTap;
  const _MyContext(
      {super.key,
      required super.child,
      required this.length,
      required this.selected,
      required this.onTap});

  static _MyContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_MyContext>();
  }

  @override
  bool updateShouldNotify(covariant _MyContext oldWidget) {
    return true;
  }
}

class BottomMenuItem {
  final String? text;
  final String? icon;
  final Widget? iconWidget;
  final String? iconFill;
  final int? badgeCount;
  final Text? badge;
  final Function()? onTap;
  final String? id;
  final double? alpha;

  BottomMenuItem({
    this.text,
    this.icon,
    this.iconWidget,
    this.iconFill,
    this.badgeCount,
    this.badge,
    this.onTap,
    this.id,
    this.alpha,
  });
}

class SBottomBarNavigation extends StatefulWidget {
  const SBottomBarNavigation(
      {super.key,
      required this.pageController,
      // required this.menuItems,
      required this.children});

  final PageController pageController;
  // final List<BottomMenuItem> menuItems;
  final List<SBottomMenuItem> children;

  @override
  State<SBottomBarNavigation> createState() => _SBottomBarNavigationState();
}

class _SBottomBarNavigationState extends State<SBottomBarNavigation> {
  late String currentKey;
  bool isBouncing = true;
  final List<String> _keys = [];

  @override
  void initState() {
    super.initState();
    _keys.addAll(widget.children.where((e) => e.id != null).map((e) => e.id!));
    // print(_keys);
    currentKey = _keys.first;
  }

  void _onItemTapped(String router) {
    setState(() {
      final index = _keys.indexOf(router);
      HapticFeedback.mediumImpact();
      if (currentKey == router) {
        Get.find<SystemController>()
            .getNavigatorKey(index)
            .currentState
            ?.popUntil((route) => route.isFirst);
      } else {
        currentKey = router;
        widget.pageController.jumpToPage(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final List<BottomMenuItem> menuItems = widget.menuItems;

    return _MyContext(
        length: widget.children.length,
        selected: currentKey,
        onTap: _onItemTapped,
        child: Container(
          // height: 88,
          decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.children,
              // children: List.generate(menuItems.length, (index) {
              //   final menuItem = menuItems[index];
              //   if (menuItem.badge != null) {
              //     return Expanded(
              //       child: SBottomMenu(
              //         menuItem: menuItem,
              //         isSelected: currentKey == menuItems[index].id,
              //         onPressed: () {
              //           _onItemTapped(menuItems[index].id!);
              //         },
              //         length: menuItems.length,
              //       ),
              //     );
              //   }

              //   return Expanded(
              //     child: SBottomMenu(
              //       menuItem: menuItems[index],
              //       isSelected: currentKey == menuItems[index].id,
              //       onPressed: () {
              //         _onItemTapped(menuItems[index].id!);
              //       },
              //       length: menuItems.length,
              //       alpha: menuItems[index].alpha,
              //     ),
              //   );
              // }),
            ),
          ),
        ));
  }
}

class SBottomMenu extends StatelessWidget {
  const SBottomMenu({
    // this.icon,
    required this.onPressed,
    this.isSelected = false,
    // this.text,
    // this.iconWidget,
    required this.length,
    // this.badgeCount = 0,
    required this.menuItem,
    this.alpha,
  });

  final double? alpha;

  final BottomMenuItem menuItem;

  final bool isSelected;

  // final String? icon;
  final VoidCallback onPressed;
  // final String? text;
  // final Widget? iconWidget;
  final int length;
  // final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final borderColor =
        Theme.of(context).colorScheme.brightness == Brightness.dark
            ? onSurface.withAlpha(10)
            : Colors.transparent;

    final badgeCount = menuItem.badgeCount ?? 0;
    return Container(
      height: 53,
      // color: Colors.red,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          if (menuItem.onTap != null) {
            menuItem.onTap?.call();
            return;
          }
          onPressed.call();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width / length,
              decoration: BoxDecoration(
                color:
                    isSelected ? Theme.of(context).primaryColor : borderColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Badge(
                    label: Text('${badgeCount > 9 ? '9+' : badgeCount}'),
                    isLabelVisible: badgeCount > 0,

                    // badgeContent: Text(badgeCount.toString()),
                    // showBadge: badgeCount != null,
                    child: Opacity(
                      opacity: isSelected ? 1 : (alpha ?? 0.5),
                      child: Builder(
                        builder: (context) {
                          if (menuItem.icon != null)
                            return SvgPicture.asset(
                              isSelected
                                  ? menuItem.iconFill ?? menuItem.icon!
                                  : menuItem.icon!,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                        context,
                                      ).colorScheme.surface.withAlpha(100),
                                BlendMode.srcIn,
                              ),
                            );
                          if (menuItem.iconWidget != null)
                            return menuItem.iconWidget!;

                          return SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  if (menuItem.text != null)
                    FittedBox(
                      child: Text(
                        menuItem.text!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          // letterSpacing: -0.25,
                          wordSpacing: -1,
                          fontSize: 12,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.surface.withAlpha(100),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SBottomMenuItem extends StatelessWidget {
  const SBottomMenuItem({
    super.key,
    this.badgeCount,
    this.id,
    this.alpha,
    this.icon,
    this.iconActive,
    this.text,
    this.onTap,
  });

  final int? badgeCount;
  final String? id;
  final double? alpha;
  final Widget? icon;
  final Widget? iconActive;
  final String? text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final borderColor = onSurface.withAlpha(30);

    final primaryColor = Theme.of(context).colorScheme.primary;

    final _context = _MyContext.of(context);
    final length = _context?.length ?? 0;
    final selected = _context?.selected ?? '';
    final _contextOnTap = _context?.onTap ?? (name) {};

    final isSelected = selected == id;
    return SizedBox(
      height: 53,
      child: InkWell(
        onTap: () {
          // HapticFeedback.mediumImpact();
          if (id != null) {
            _contextOnTap(id!);
          }
          onTap?.call();
          // if (menuItem.onTap != null) {
          //   menuItem.onTap?.call();
          //   return;
          // }
          // onPressed.call();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width / length,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : borderColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Badge(
                    label: Text('${(badgeCount ?? 0) > 9 ? '9+' : badgeCount}'),
                    isLabelVisible: (badgeCount ?? 0) > 0,

                    // badgeContent: Text(badgeCount.toString()),
                    // showBadge: badgeCount != null,
                    child: Opacity(
                      opacity: isSelected ? 1 : (alpha ?? 0.5),
                      child: Builder(
                        builder: (context) {
                          if (isSelected && iconActive != null)
                            return iconActive!;

                          if (icon != null) return icon!;

                          // if (icon != null)
                          //   return SvgPicture.asset(
                          //     isSelected
                          //         ? menuItem.iconFill ?? icon!
                          //         : menuItem.icon!,
                          //     width: 24,
                          //     height: 24,
                          //     colorFilter: ColorFilter.mode(
                          //       isSelected
                          //           ? Theme.of(context).colorScheme.primary
                          //           : Theme.of(
                          //               context,
                          //             ).colorScheme.surface.withAlpha(100),
                          //       BlendMode.srcIn,
                          //     ),
                          //   );
                          // if (menuItem.iconWidget != null)
                          //   return menuItem.iconWidget!;

                          return SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  if (text != null)
                    FittedBox(
                      child: Text(
                        text!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          // letterSpacing: -0.25,
                          wordSpacing: -1,
                          fontSize: 12,
                          color: isSelected
                              ? primaryColor
                              : Theme.of(
                                  context,
                                ).colorScheme.surface.withAlpha(100),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
