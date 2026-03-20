import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// class MenuItem {
//   final String title;
//   final String? description;
//   final String svgIcon;
//   final Function()? onTap;

//   MenuItem({
//     required this.title,
//     required this.svgIcon,
//     this.onTap,
//     this.description,
//   });
// }

class Menu {
  static Future show({
    required BuildContext context,
    required List<MenuItem> menus,
    final double offsetX = 100,
    final double width = 150,
  }) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);
    // final Size size = button.size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final bgColor = isDarkMode ? Colors.white : Colors.black;
    // final textColor = isDarkMode ? Colors.black : Colors.white;
    return await showDialog(
      useSafeArea: true,
      context: context,
      barrierColor: Colors.black.withAlpha(150),
      useRootNavigator: true,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              left: position.dx - offsetX,
              top: position.dy - 20,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(20),
                borderRadius: BorderRadius.circular(8),
                // clipBehavior: Clip.hardEdge,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: width,
                    // padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isDarkMode
                          ? Colors.white.withAlpha(30)
                          : Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(menus.length, (index) => menus[index]),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  // static Widget item({
  //   required BuildContext context,
  //   required MenuItem menu,
  //   bool border = true,
  // }) {
  //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //   final textColor = isDarkMode ? Colors.white : Colors.black;

  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: () {
  //         Navigator.pop(context);
  //         menu.onTap?.call();
  //       },
  //       splashColor: Colors.black.withAlpha(50),
  //       child: Container(
  //         padding: EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //             border: border
  //                 ? Border(bottom: BorderSide(color: textColor.withAlpha(20)))
  //                 : null),
  //         child: Row(
  //           children: [
  //             if (menu.svgIcon != null)
  //               SvgPicture.asset(
  //                 menu.svgIcon!,
  //                 width: 20,
  //                 height: 20,
  //                 colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
  //               ),
  //             SizedBox(width: 8),
  //             DefaultTextStyle(
  //               style: TextStyle(color: menu.textColor ?? textColor),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   if (menu.title != null)
  //                     Text(menu.title!, style: TextStyle(color: textColor)),
  //                   if (menu.subtitle != null)
  //                     Text(
  //                       menu.subtitle!,
  //                       style: TextStyle(
  //                         color: textColor.withAlpha(100),
  //                       ),
  //                     )
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class _MenuContext extends InheritedWidget {
  final double? spacing;

  const _MenuContext({super.key, required super.child, this.spacing});
  @override
  static _MenuContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_MenuContext>();
  }

  bool updateShouldNotify(covariant _MenuContext oldWidget) {
    return oldWidget.spacing != spacing;
  }
}

class SMenu extends StatelessWidget {
  const SMenu({
    super.key,
    this.width,
    required this.children,
    this.iconTheme,
    this.textStyle,
    this.spacing = Spacing.small,
    this.backgroundColor,
  });
  // final List<MenuItem> menus;
  final List<Widget> children;
  final double? width;
  final IconThemeData? iconTheme;
  final TextStyle? textStyle;
  final double spacing;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return _MenuContext(
      spacing: spacing,
      child: Material(
        color: Colors.transparent,
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: width,
          // padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: backgroundColor ??
                (isDarkMode
                    ? Colors.white.withAlpha(30)
                    : Colors.white.withAlpha(200)),
          ),
          child: IconTheme(
            data: IconThemeData(
                color: iconTheme?.color ?? textColor,
                size: iconTheme?.size ?? 16),
            child: DefaultTextStyle(
              style: TextStyle(color: textColor.withAlpha(200)).copyWith(
                color: textStyle?.color,
                fontSize: textStyle?.fontSize,
                fontWeight: textStyle?.fontWeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  children.length,
                  (index) => children[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SMenuItem extends StatelessWidget {
  const SMenuItem({
    super.key,
    this.border = true,
    this.icon,
    this.title,
    this.subtitle,
    this.onTap,
    this.checked,
  });

  final bool border;
  final Widget? icon;
  final Widget? title;
  final Widget? subtitle;
  final bool? checked;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return HighlightTap(
      onTap: onTap,
      highlightColor: textColor,
      highlightAlpha: 10,
      child: Container(
        padding: EdgeInsets.all(Spacing.small),
        decoration: BoxDecoration(
            border: border
                ? Border(bottom: BorderSide(color: textColor.withAlpha(20)))
                : null),
        child: Row(
          spacing: _MenuContext.of(context)?.spacing ?? Spacing.medium,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) icon!,
            Expanded(
              child: Row(
                spacing: Spacing.small,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null) title!,
                        if (subtitle != null)
                          DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withAlpha(100),
                            ),
                            child: subtitle!,
                          )
                      ],
                    ),
                  ),
                  if (checked != null)
                    SRadio(
                      checked: checked ?? false,
                      // onChanged: (value) {},
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
