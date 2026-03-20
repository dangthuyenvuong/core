import 'package:core/core.dart';
import 'package:flutter/material.dart';

enum ButtonSize {
  small,
  medium,
  large,
}

class _BtnStyle {
  EdgeInsets padding;
  double radius;
  double fontSize;
  double height;
  double spacing;

  _BtnStyle({
    required this.padding,
    required this.radius,
    required this.fontSize,
    required this.height,
    required this.spacing,
  });
}

var _btnSize = {
  SSize.small: _BtnStyle(
    padding: EdgeInsets.symmetric(
        horizontal: Spacing.small, vertical: Spacing.xSmall),
    radius: 4,
    fontSize: 12,
    height: 32,
    spacing: Spacing.small,
  ),
  SSize.medium: _BtnStyle(
    padding: EdgeInsets.symmetric(
        horizontal: Spacing.small, vertical: Spacing.small),
    radius: 8,
    fontSize: 14,
    height: 40,
    spacing: Spacing.small,
  ),
  SSize.large: _BtnStyle(
    padding: EdgeInsets.symmetric(
        horizontal: Spacing.medium, vertical: Spacing.small),
    radius: 10,
    fontSize: 16,
    height: 48,
    spacing: Spacing.small,
  ),
};

enum ButtonColor {
  primary,
  secondary,
  tertiary,
  red,
  grey,
  green,
  orange,
  blue,
  yellow,
  white,
  transparent
}

// final Map<SSize, EdgeInsets> _sizePadding = {
//   SSize.small:
//       EdgeInsets.symmetric(horizontal: Spacing.small, vertical: Spacing.xSmall),
//   SSize.medium:
//       EdgeInsets.symmetric(horizontal: Spacing.small, vertical: Spacing.small),
//   SSize.large: EdgeInsets.symmetric(
//       horizontal: Spacing.medium, vertical: Spacing.medium),
// };

// final Map<SSize, double> _sizeRadius = {
//   SSize.small: 4,
//   SSize.medium: 8,
//   SSize.large: 10,
// };

// final Map<SSize, double> _sizeFontSize = {
//   SSize.small: 12,
//   SSize.medium: 14,
//   SSize.large: 16,
// };
// final Map<SSize, double> _btnHeight = {
//   SSize.small: 32,
//   SSize.medium: 40,
//   SSize.large: 48,
// };

class SButton extends StatelessWidget {
  const SButton({
    super.key,
    this.rounded = false,
    required this.child,
    this.size = SSize.medium,
    this.onTap,
    this.color = ButtonColor.primary,
    this.bgColor,
    this.bgGradient,
    this.minWidth,
    this.width,
    this.padding,
    this.disabled = false,
    this.loading = false,
    this.icon,
    this.textColor,
    this.radius,
    this.height,
  });
  final bool rounded;
  final Widget child;
  final SSize size;
  final VoidCallback? onTap;
  final ButtonColor color;
  final Color? bgColor;
  final Gradient? bgGradient;
  final double? minWidth;
  final double? width;
  final EdgeInsets? padding;
  final bool disabled;
  final bool loading;
  final IconData? icon;
  final Color? textColor;
  final double? radius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final _disabled = disabled || loading;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final buttonColor = {
      ButtonColor.primary: Theme.of(context).primaryColor,
      ButtonColor.secondary: Theme.of(context).colorScheme.surface,
      ButtonColor.tertiary: Theme.of(context).colorScheme.surface,
      ButtonColor.red: Theme.of(context).colorScheme.error,
      ButtonColor.grey: Colors.grey.shade500.withAlpha(50),
      ButtonColor.green: Colors.greenAccent.shade700,
      ButtonColor.orange: Colors.orangeAccent.shade700,
      ButtonColor.blue: Colors.blueAccent.shade700,
      ButtonColor.yellow: Colors.yellowAccent.shade700,
      ButtonColor.transparent: Colors.transparent,
      ButtonColor.white: Colors.white,
    };

    final textColorMap = {
      ButtonColor.grey: onSurface,
      ButtonColor.transparent: onSurface,
    };

    final disabledTextColorMap = {
      ButtonColor.primary: onSurface.withAlpha(150),
    };

    final _size = _btnSize[size]!;

    final bgDisabled =
        isDarkMode ? Colors.white.withAlpha(10) : Colors.black.withAlpha(10);

    final _radius =
        BorderRadius.circular(radius ?? (rounded ? 999 : _size.radius));

    var _textColor = textColor ??
        (textColorMap[color] ?? Colors.white)?.withAlpha(_disabled ? 100 : 255);

    if (_disabled) {
      _textColor = disabledTextColorMap[color] ?? onSurface.withAlpha(150);
    }

    return IntrinsicWidth(
      child: Container(
        width: width,
        height: height ?? _size.height,
        // width: double.infinity,
        // padding: EdgeInsets.symmetric(horizontal: Spacing.medium),
        constraints: BoxConstraints(minWidth: minWidth ?? 0),
        decoration: BoxDecoration(
          borderRadius: _radius,
          color: _disabled ? bgDisabled : bgColor ?? buttonColor[color],
          gradient: _disabled ? null : bgGradient,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            canRequestFocus: false,
            borderRadius: _radius,
            onTap: _disabled ? null : onTap,
            child: Padding(
              padding: padding ?? _size.padding,
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: _size.fontSize,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
                textAlign: TextAlign.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: _size.spacing,
                  children: [
                    if (loading)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: _textColor,
                          strokeWidth: 2,
                        ),
                      ),
                    if (icon != null && !loading)
                      Icon(icon!, size: _size.fontSize, color: _textColor),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
