import 'package:core/core.dart';
import 'package:flutter/material.dart';

class DialogAction extends StatelessWidget {
  const DialogAction(
      {super.key,
      required this.title,
      this.content,
      this.decorate,
      required this.icon,
      this.child,
      this.actions,
      this.barrierDismissible = true});
  final Widget title;
  final Widget? content;
  final Widget? child;
  final Widget? decorate;
  final Widget icon;
  final List<Widget>? actions;
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return DialogWraper(
      barrierDismissible: barrierDismissible,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Spacing.medium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -2,
                    color: onSurface,
                  ),
                  child: title,
                ),
                SizedBox(height: Spacing.small),
                if (content != null)
                  DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: onSurface.withAlpha(150),
                    ),
                    child: content!,
                  ),
                if (child != null) child!,
                SizedBox(height: Spacing.medium),
                if (actions != null)
                  Padding(
                    padding: const EdgeInsets.only(top: Spacing.large),
                    child: Column(
                      spacing: Spacing.small,
                      children: actions!,
                    ),
                  ),
                // SizedBox(
                //   width: double.infinity,
                //   child: SButton(
                //     rounded: true,
                //     color: ButtonColor.grey,
                //     child: Text("Back to list".tr),
                //     onTap: () {
                //       Modal.pop(context);
                //     },
                //   ),
                // ),
                // SizedBox(height: Spacing.small),
                // SizedBox(
                //   width: double.infinity,
                //   child: SButton(
                //     rounded: true,
                //     child: Text("Message with Client".tr),
                //     onTap: () {
                //       Modal.pop(context);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          if (decorate != null)
            Positioned(
              top: 0,
              bottom: 0,
              left: -20,
              right: 0,
              child: IgnorePointer(
                child: decorate,
              ),
            ),
        ],
      ),
    );
  }
}
