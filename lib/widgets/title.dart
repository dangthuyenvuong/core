import 'package:core/core.dart';
import 'package:flutter/material.dart';

class STitle extends StatelessWidget {
  const STitle({
    this.title,
    this.subTitle,
    this.titleWidget,
    this.action,
    this.fontSize = 24,
    this.textAlign,
  });
  final Widget? titleWidget;
  final String? title;
  final String? subTitle;
  final Widget? action;
  final double? fontSize;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Spacing.xSmall,
      children: [
        Row(
          children: [
            Expanded(
              child: DefaultTextStyle(
                  textAlign: textAlign,
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  child: titleWidget ??
                      Text(title!,
                          style: TextStyle(
                            fontSize: fontSize ?? 24,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.bold,
                          ))),
            ),
            action ?? SizedBox.shrink()
          ],
        ),
        // if (titleWidget != null)
        //   DefaultTextStyle(
        //       style: TextStyle(
        //         fontSize: 24,
        //         letterSpacing: -0.5,
        //         fontWeight: FontWeight.bold,
        //       ),
        //       child: titleWidget!),
        // if (titleWidget == null && title != null)
        //   Text(title!,
        //       style: TextStyle(
        //         fontSize: 24,
        //         letterSpacing: -0.5,
        //         fontWeight: FontWeight.bold,
        //       )
        // ),
        if (subTitle != null)
          Text(subTitle!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                fontSize: 14,
              ))
      ],
    );
  }
}
