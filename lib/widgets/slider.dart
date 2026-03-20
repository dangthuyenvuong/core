import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SSlider extends StatelessWidget {
  const SSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.onChangeEnd,
    this.onChangeStart,
    this.disabled = false,
    this.max = 100,
    this.min = 0,
    this.leading,
    this.trailing,
    this.divisions,
    this.padding = EdgeInsets.zero,
  });
  final double value;
  final Function(double)? onChanged;
  final Function(int)? onChangeEnd;
  final Function(int)? onChangeStart;
  final bool disabled;

  final double max;
  final double min;
  final int? divisions;

  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      child: Row(
        // spacing: Spacing.small,
        children: [
          if (leading != null) leading!,
          Expanded(
            // child: Slider(
            //   padding: padding,
            //   max: max.toDouble(),
            //   min: min.toDouble(),
            //   divisions: divisions,
            //   thumbColor: Colors.red,
            //   activeColor: Colors.red,
            //   value: math.min(math.max(value, min), max).toDouble(),
            //   onChanged: disabled
            //       ? null
            //       : (value) {
            //           if (value.toInt() == value) {
            //             HapticFeedback.lightImpact();
            //           }
            //           onChanged?.call(value);
            //         },
            //   onChangeEnd: disabled
            //       ? null
            //       : (value) {
            //           onChangeEnd?.call(value.toInt());
            //         },
            //   onChangeStart: disabled
            //       ? null
            //       : (value) {
            //           onChangeStart?.call(value.toInt());
            //         },
            // ),
            child: CupertinoSlider(
              // padding: padding,
              max: max.toDouble(),
              min: min.toDouble(),
              divisions: divisions,
              // thumbColor: Colors.red,
              // activeColor: Colors.red,
              value: math.min(math.max(value, min), max).toDouble(),
              onChanged: disabled
                  ? null
                  : (value) {
                      if (value.toInt() == value) {
                        HapticFeedback.lightImpact();
                      }
                      onChanged?.call(value);
                    },
              onChangeEnd: disabled
                  ? null
                  : (value) {
                      onChangeEnd?.call(value.toInt());
                    },
              onChangeStart: disabled
                  ? null
                  : (value) {
                      onChangeStart?.call(value.toInt());
                    },
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
