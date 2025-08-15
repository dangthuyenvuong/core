import 'package:core/core.dart';
import 'package:flutter/material.dart';

class SCheckbox extends StatelessWidget {
  const SCheckbox({
    super.key,
    this.child,
    required this.value,
    required this.onChanged,
  });

  final Widget? child;
  final bool value;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          child ?? const SizedBox.shrink(),
          Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide(color: onSurface.withAlpha(50)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.xSmall),
            ),
            activeColor: Constant.red,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
