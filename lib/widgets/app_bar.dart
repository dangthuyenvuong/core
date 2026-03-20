import 'package:core/widgets/icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.onLeadingTap,
    this.spacing = 8,
    this.leftPadding = 12,
    this.rightPadding = 8,
    this.bottomPadding = 0,
    this.bottom,
    this.height = 48,
    this.padding,
    this.borderBottom = false,
    this.titleCenter = false,
    this.subtitle,
  });

  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final Function? onLeadingTap;
  final double spacing;
  final double leftPadding;
  final double rightPadding;
  final double bottomPadding;
  final Widget? bottom;
  final double height;
  final EdgeInsets? padding;
  final bool borderBottom;
  final bool? titleCenter;
  final Widget? subtitle;

  @override
  Size get preferredSize => Size.fromHeight(height + (borderBottom ? 1 : 0));

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: borderBottom
            ? Border(
                bottom: BorderSide(
                    color: isDarkMode
                        ? Colors.white.withAlpha(15)
                        : Colors.black.withAlpha(15)))
            : null,
      ),
      // color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: padding?.left ?? (leading != null ? 0 : leftPadding),
                right: padding?.right ?? rightPadding,
                bottom: padding?.bottom ?? bottomPadding,
                top: padding?.top ?? 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      // spacing: spacing,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (leading != null) leading!,
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: titleCenter == true
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              DefaultTextStyle(
                                textAlign: titleCenter == true
                                    ? TextAlign.center
                                    : TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: onSurface,
                                  letterSpacing: -0.5,
                                ),
                                child: title ?? Container(),
                              ),
                              if (subtitle != null)
                                DefaultTextStyle(
                                  textAlign: titleCenter == true
                                      ? TextAlign.center
                                      : TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: onSurface.withAlpha(150),
                                    letterSpacing: -0.5,
                                  ),
                                  child: subtitle ?? Container(),
                                ),
                            ],
                          ),
                        ),

                        // Text(
                        //   title!,
                        //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        // )
                      ],
                    ),
                    // child: GradientTextDemo(),
                  ),
                  ...actions ?? [],
                ],
              ),
            ),
            if (bottom != null) bottom!,
          ],
        ),
      ),
    );
  }
}

class GradientTextDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.yellow.shade900,
          Colors.red.shade900,
          Colors.blue,
          Colors.green,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        'SpaceEnglish',
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SIconBack extends StatelessWidget {
  const SIconBack({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onTap: () {
    //     Navigator.pop(context);
    //   },
    //   child: SvgPicture.asset(
    //     'assets/images/svg/chevron-left.svg',
    //     width: 24,
    //     height: 24,
    //     colorFilter: ColorFilter.mode(
    //         Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
    //   ),
    // );
    return SIconButton(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Navigator.pop(context);
        }
      },
      child: Icon(CupertinoIcons.chevron_left),
      // package: 'core',
      // svgPath: 'assets/images/svg/chevron-left.svg',
    );
  }
}
