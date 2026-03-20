import 'package:core/constants/icon.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

// class MenuItem extends StatelessWidget {
//   const MenuItem({
//     super.key,
//     this.title,
//     this.subtitle,
//     this.onTap,
//     this.svgIcon,
//     this.textColor,
//     this.leading,
//     this.action,
//     this.isLink = false,
//     this.isSwitch = false,
//     this.isSwitchValue,
//     this.onSwitchChange,
//     this.icon,
//   });
//   final String? title;
//   final String? subtitle;
//   final void Function()? onTap;
//   final String? svgIcon;
//   final Color? textColor;
//   final Widget? leading;
//   final Widget? action;
//   final bool isLink;
//   final bool isSwitch;
//   final bool? isSwitchValue;
//   final void Function(bool value)? onSwitchChange;
//   final Widget? icon;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//               vertical: Spacing.small, horizontal: Spacing.medium),
//           child: Row(
//             spacing: 8,
//             children: [
//               if (leading != null) leading!,
//               if (icon != null) icon!,
//               if (svgIcon != null)
//                 SIconButton(
//                   bgColor:
//                       Theme.of(context).colorScheme.onSurface.withAlpha(20),
//                   onTap: onTap,
//                   // size: 20,
//                   child: SvgPicture.asset(
//                     svgIcon!,
//                     colorFilter: ColorFilter.mode(
//                       textColor ?? Theme.of(context).colorScheme.onSurface,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (title != null)
//                       Text(title!,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: textColor,
//                             letterSpacing: -0.5,
//                           )),
//                     if (subtitle != null)
//                       Opacity(
//                         opacity: 0.5,
//                         child: Text(subtitle!,
//                             style: TextStyle(
//                               fontSize: 12,
//                             )),
//                       )
//                   ],
//                 ),
//               ),
//               if (action != null) action!,
//               if (isLink)
//                 Opacity(
//                   opacity: 0.5,
//                   child: SvgPicture.asset(
//                     "assets/images/svg/chevron-right.svg",
//                     colorFilter: ColorFilter.mode(
//                       textColor ?? Theme.of(context).colorScheme.onSurface,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//               if (isSwitch)
//                 SSwitch(
//                   value: isSwitchValue ?? false,
//                   onChanged: (value) {
//                     onSwitchChange?.call(value);
//                   },
//                 ),
//             ],
//           ),
//         ));
//   }
// }

final _padding = Spacing.medium / 2;

class MenuGroup extends StatelessWidget {
  const MenuGroup({
    super.key,
    required this.items,
    this.title,
    this.helperText,
    this.action,
    this.backgroundColor,
    this.style,
    this.enabled,
    this.onEnabledChange,
    this.padding,
  });
  final List<MenuItem> items;
  final String? title;
  final String? helperText;
  final List<Widget>? action;
  final Color? backgroundColor;
  final TextStyle? style;
  final bool? enabled;
  final Function(bool value)? onEnabledChange;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: _padding,
            // vertical: Spacing.small,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.small,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.only(
                left: Spacing.medium,
                right: Spacing.medium,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: onSurface.withAlpha(100),
                      ),
                    ),
                  ),
                  if (action != null) ...action!,
                  if (enabled != null)
                    Transform.translate(
                      offset: Offset(27, 0),
                      child: Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                              value: enabled!, onChanged: onEnabledChange)),
                    )
                ],
              ),
            ),
          Opacity(
            opacity: enabled != null ? (enabled! ? 1.0 : 0.5) : 1.0,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: backgroundColor ??
                    (isDarkMode ? onSurface.withAlpha(10) : Colors.white),
                borderRadius: BorderRadius.circular(Spacing.small),
              ),
              child: Column(
                children: items.mapV2((e, index) {
                  if (index < items.length - 1) {
                    e.showBorder = true;
                  }
                  e.style = style;
                  return e;
                }).toList(),
              ),
            ),
          ),
          if (helperText != null)
            Padding(
              padding: EdgeInsets.only(
                left: Spacing.medium,
                right: Spacing.medium,
              ),
              child: Text(
                helperText!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: onSurface.withAlpha(100),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MenuItem extends StatefulWidget {
  MenuItem({
    super.key,
    required this.text,
    this.icon,
    this.isSwitch,
    this.onTap,
    this.isDisabled = false,
    this.isShowChevron = false,
    this.isShowCheckmark = false,
    this.showBorder = false,
    this.isShowDropdown = false,
    this.subText,
    this.value,
    this.options,
    this.trailing,
    this.leadingValue,
    this.isDestructive = false,
    this.badge,
    this.onLongPress,
    this.suffixIcon,
    this.isEditable = false,
    this.suffixText,
    this.controller,
    this.isSelected,
    this.style,
    this.child,
    this.focusNode,
    this.onSelected,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly,
    this.onSwitchChange,
    this.errorText,
  });
  final String text;
  final Widget? icon;
  final bool? isSwitch;
  final VoidCallback? onTap;
  final bool isDisabled;
  final bool isShowChevron;
  final bool isShowCheckmark;
  final bool isShowDropdown;
  final bool? isSelected;
  final String? subText;
  final String? value;
  final List<String>? options;
  final Widget? trailing;
  final Widget? leadingValue;
  bool showBorder;
  final bool isDestructive;
  final int? badge;
  final VoidCallback? onLongPress;
  final Widget? suffixIcon;
  final bool? isEditable;
  final String? suffixText;
  final TextEditingController? controller;
  TextStyle? style;
  final Widget? child;
  final FocusNode? focusNode;
  final Function(String)? onSelected;
  final Function(String)? onChanged;
  final bool? readOnly;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(bool value)? onSwitchChange;
  final String? errorText;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      focusNode = widget.focusNode ?? FocusNode();
      focusNode!.addListener(() {
        if (focusNode!.hasFocus) {
          // Khi focus, dời con trỏ về cuối
          widget.controller!.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.controller!.text.length),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      focusNode?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final color = widget.isDestructive ? Colors.red : onSurface;
    final errorText = widget.errorText;

    final content = OpacityTap(
      // padding: EdgeInsets.zero,
      // minimumSize: Size.zero,
      onLongPress: widget.onLongPress,
      onTap: widget.onTap ??
          () {
            if (widget.controller != null) {
              focusNode?.requestFocus();
            }
            if (widget.options != null) {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: Text(widget.text),
                  actions: widget.options!
                      .map((e) => CupertinoActionSheetAction(
                            child: Text(e),
                            onPressed: () {
                              widget.onSelected?.call(e);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                  cancelButton: CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      child: Text("Cancel".tr),
                      onPressed: () {}),
                ),
              );
            }
          },
      child: Row(
        children: [
          if (widget.icon != null)
            Container(
              padding: EdgeInsets.only(
                right: Spacing.medium,
                left: Spacing.medium,
              ),
              child: IconTheme(
                data: IconThemeData(
                  size: 20,
                  color: color,
                ),
                child: widget.icon!,
              ),
            ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: Spacing.xSmall,
                bottom: Spacing.xSmall,
                right: Spacing.mediumSmall,
              ),
              decoration: BoxDecoration(
                color: errorText != null ? Colors.red.withAlpha(50) : null,
                border: widget.showBorder
                    ? Border(bottom: BorderSide(color: onSurface.withAlpha(20)))
                    : null,
              ),
              constraints: BoxConstraints(
                minHeight: 50,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // spacing: Spacing.xSmall,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left:
                                      widget.icon == null ? Spacing.medium : 0,
                                ),
                                child: Text(
                                  widget.text,
                                  style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: color)
                                      .merge(widget.style),
                                ),
                              ),
                            ),
                            if (widget.leadingValue != null)
                              widget.leadingValue!,
                            if (widget.badge != null)
                              Container(
                                width: 25,
                                height: 25,
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${widget.badge! > 99 ? '+99' : widget.badge!.toString()}",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            if (widget.value != null)
                              Padding(
                                padding: EdgeInsets.only(left: Spacing.small),
                                child: Text(
                                  widget.value!,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: onSurface.withAlpha(100),
                                  ),
                                ),
                              ),
                            if (widget.child != null) widget.child!,
                            if (widget.controller != null)
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: Spacing.small),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      _Input(
                                          enabled: widget.readOnly != true,
                                          onChanged: widget.onChanged,
                                          controller: widget.controller,
                                          keyboardType: widget.keyboardType,
                                          inputFormatters:
                                              widget.inputFormatters,
                                          focusNode: focusNode),
                                      if (errorText != null)
                                        Positioned(
                                          right: 0,
                                          bottom: -12,
                                          child: Text(errorText,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red)),
                                        )
                                    ],
                                  ),
                                ),
                              ),

                            // if (widget.options != null)
                            //   Padding(
                            //     padding: EdgeInsets.only(left: Spacing.xSmall),
                            //     child: Icon(
                            //       CupertinoIcons.chevron_up_chevron_down,
                            //       size: 14,
                            //       color: onSurface.withAlpha(100),
                            //     ),
                            //   ),

                            // SvgPicture.asset(
                            //   CoreIcons.chevronUpDown,
                            //   colorFilter: ColorFilter.mode(
                            //     onSurface.withAlpha(100),
                            //     BlendMode.srcIn,
                            //   ),
                            //   package: 'core',
                            // ),
                            SizedBox(width: Spacing.small),
                          ],
                        ),
                        if (widget.subText != null)
                          Container(
                            padding: EdgeInsets.only(
                              left: widget.icon == null ? Spacing.medium : 0,
                            ),
                            child: Text(
                              widget.subText!,
                              style: TextStyle(
                                fontSize: 14,
                                color: onSurface.withAlpha(100),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.isShowChevron)
                    Icon(
                      CupertinoIcons.chevron_right,
                      size: 18,
                      color: onSurface.withAlpha(100),
                    ),
                  if (widget.isShowCheckmark)
                    Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),

                  if (widget.isSelected != null)
                    SRadio(checked: widget.isSelected!, onChanged: (value) {}),
                  if (widget.isShowDropdown || widget.options != null)
                    Core.svgAsset(
                      CoreIcons.chevronUpDown,
                      size: 18,
                      color: onSurface.withAlpha(100),
                      package: 'core',
                    ),
                  if (widget.isSwitch != null)
                    CupertinoSwitch(
                      value: widget.isSwitch!,
                      onChanged: (value) {
                        if (widget.onSwitchChange != null) {
                          widget.onSwitchChange!(value);
                        } else {
                          widget.onTap?.call();
                        }
                      },
                    ),
                  if (widget.suffixIcon != null)
                    IconTheme(
                      data: IconThemeData(
                        size: 16,
                        color: onSurface.withAlpha(100),
                      ),
                      child: widget.suffixIcon!,
                    ),
                  // if (widget.options != null)
                  //   CupertinoPicker(
                  //     itemExtent: 32,
                  //     onSelectedItemChanged: (index) {},
                  //     children: widget.options!.map((e) => Text(e)).toList(),
                  //   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.trailing != null) {
      return Column(
        children: [
          content,
          widget.trailing!,
        ],
      );
    }

    return content;
  }
}

class _Input extends StatefulWidget {
  const _Input(
      {super.key,
      this.controller,
      this.focusNode,
      this.onChanged,
      this.keyboardType,
      this.inputFormatters,
      this.enabled = true});

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;

  @override
  State<_Input> createState() => _InputState();
}

class _InputState extends State<_Input> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return TextField(
      enabled: widget.enabled,
      controller: widget.controller,
      focusNode: widget.focusNode,
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: 14, color: onSurface.withAlpha(100)),
      textInputAction: TextInputAction.next,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(bottom: 0, top: 0),
      ),
    );
  }
}
