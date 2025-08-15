import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SIconButton extends StatelessWidget {
  const SIconButton({
    super.key,
    this.svgPath,
    this.path,
    this.child,
    this.size = 24,
    this.onTap,
    this.text,
    this.splashColor,
    this.paddingX = 8,
    this.paddingY = 8,
    this.bgColor,
    this.textColor,
    this.package,
    this.disabled = false,
  });

  final String? svgPath;
  final String? path;
  final Widget? child;
  final double? size;
  final String? text;
  final Color? splashColor;
  final double paddingX;
  final double paddingY;
  final Color? bgColor;
  final Color? textColor;
  final void Function()? onTap;
  final String? package;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final _textColor = textColor ?? Theme.of(context).colorScheme.onSurface;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        canRequestFocus: false,
        borderRadius: BorderRadius.circular(100),
        splashColor: splashColor?.withAlpha(100),
        highlightColor: splashColor?.withAlpha(50),
        onTap: disabled ? null : onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (text != null) ...[
              SizedBox(width: 8),
              Text(text!),
            ],
            Container(
              // width: size,
              // height: size,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(100),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: paddingX!, vertical: paddingY!),
              child: Builder(builder: (context) {
                if (svgPath != null) {
                  return SvgPicture.asset(
                    svgPath!,
                    width: size,
                    height: size,
                    package: package,
                    colorFilter: ColorFilter.mode(
                      _textColor,
                      BlendMode.srcIn,
                    ),
                  );
                }
                if (path != null) {
                  return Image.asset(
                    path!,
                    width: size,
                    height: size,
                  );
                }

                return child!;
              }),
              // child: SvgPicture.asset(
              //   'assets/images/svg/plus.svg',
              //   width: 24,
              //   height: 24,
              //   color: Theme.of(context).colorScheme.onSurface,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
