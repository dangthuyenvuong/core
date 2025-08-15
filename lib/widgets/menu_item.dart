import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    this.title,
    this.subtitle,
    this.onTap,
    this.svgIcon,
    this.textColor,
    this.leading,
    this.action,
    this.isLink = false,
    this.isSwitch = false,
    this.isSwitchValue,
    this.onSwitchChange,
    this.icon,
  });
  final String? title;
  final String? subtitle;
  final void Function()? onTap;
  final String? svgIcon;
  final Color? textColor;
  final Widget? leading;
  final Widget? action;
  final bool isLink;
  final bool isSwitch;
  final bool? isSwitchValue;
  final void Function(bool value)? onSwitchChange;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Spacing.small, horizontal: Spacing.medium),
          child: Row(
            spacing: 8,
            children: [
              if (leading != null) leading!,
              if (icon != null) icon!,
              if (svgIcon != null)
                SIconButton(
                  bgColor:
                      Theme.of(context).colorScheme.onSurface.withAlpha(20),
                  onTap: onTap,
                  // size: 20,
                  child: SvgPicture.asset(
                    svgIcon!,
                    colorFilter: ColorFilter.mode(
                      textColor ?? Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(title!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: -0.5,
                          )),
                    if (subtitle != null)
                      Opacity(
                        opacity: 0.5,
                        child: Text(subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                            )),
                      )
                  ],
                ),
              ),
              if (action != null) action!,
              if (isLink)
                Opacity(
                  opacity: 0.5,
                  child: SvgPicture.asset(
                    "assets/images/svg/chevron-right.svg",
                    colorFilter: ColorFilter.mode(
                      textColor ?? Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              if (isSwitch)
                SSwitch(
                  value: isSwitchValue ?? false,
                  onChanged: (value) {
                    onSwitchChange?.call(value);
                  },
                ),
            ],
          ),
        ));
  }
}
