import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconBack extends StatelessWidget {
  const IconBack({
    super.key,
    this.onTap,
    this.navigatorKey,
    this.icon,
    this.text,
    this.bgColor,
    this.size,
    this.iconColor,
  });
  final VoidCallback? onTap;
  final GlobalKey<NavigatorState>? navigatorKey;
  final IconData? icon;
  final Widget? text;
  final Color? bgColor;
  final double? size;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
    return OpacityTap(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Navigator.pop(context);
        }
        // if (navigatorKey != null) {
        //   navigatorKey!.currentState?.pop();
        // } else {
        //   Get.back();
        // }
      },
      child: Row(
        children: [
          SIconButton(
            bgColor: bgColor,
            child: Icon(icon ?? CupertinoIcons.chevron_left,
                color: iconColor ?? (isDarkMode ? Colors.white : Colors.black),
                size: size),
          ),
          if (text != null)
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                // color: Constant.blue,
              ),
              child: text!,
            ),
        ],
      ),
    );
  }
}
