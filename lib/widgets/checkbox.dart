import 'package:core/core.dart';
import 'package:flutter/material.dart';

class SCheckbox extends StatelessWidget {
  const SCheckbox({
    super.key,
    this.child,
    required this.value,
    required this.onChanged,
    this.reverse = false,
  });

  final Widget? child;
  final bool value;
  final bool reverse;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (reverse && child != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: child!,
            ),
          Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide(color: onSurface.withAlpha(50)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.xSmall),
            ),
            activeColor: Constant.red,
            value: value,
            onChanged: (c) {
              onChanged.call(c ?? !value);
            },
          ),
          if (!reverse && child != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: child!,
              ),
            ),
        ],
      ),
    );
  }
}
