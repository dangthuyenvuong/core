import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SRadio extends StatelessWidget {
  const SRadio({
    super.key,
    this.checked = false,
    this.borderColor,
    this.color,
    this.unCheckedColor,
    this.icon,
    this.size = 20,
    this.onChanged,
  });
  final bool checked;
  final Color? color;
  final Color? unCheckedColor;
  final Color? borderColor;
  final Widget? icon;
  final double size;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;
    final borderColor = checked
        ? Colors.transparent
        : (this.borderColor ??
            (isDarkMode
                ? Colors.white.withAlpha(100)
                : Colors.black.withAlpha(100)));
    // final color = checked ?? false
    //     ? (this.color ?? Theme.of(context).colorScheme.primary)
    //     : Theme.of(context).scaffoldBackgroundColor;

    // final borderColor = checked ?? false
    //     ? (this.color ?? Theme.of(context).colorScheme.primary)
    //     : Colors.grey.shade500;
    return GestureDetector(
      onTap: () {
        onChanged?.call(!checked);
      },
      child: Container(
        width: size,
        height: size,
        // padding: EdgeInsets.all(3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: checked
              ? color ?? Theme.of(context).primaryColor
              : unCheckedColor ?? Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(100)),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
        ),
        child: checked
            ? icon ?? Icon(Icons.check, color: Colors.white, size: 12)
            // SvgPicture.asset(
            //   'assets/images/svg/check.svg',
            //   fit: BoxFit.contain,
            //   colorFilter: ColorFilter.mode(
            //     Colors.white,
            //     BlendMode.srcIn,
            //   ),
            // )
            : null,
      ),
    );
  }
}
