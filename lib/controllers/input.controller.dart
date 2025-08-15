import 'package:flutter/material.dart';

class CustomInputController extends TextEditingController {
  String? suffixText;
  final FocusNode? focusNode;

  CustomInputController({super.text, this.suffixText, this.focusNode});

  bool get _hasFocus {
    return focusNode?.hasFocus ?? false;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(
      style: style,
      children: [
        TextSpan(text: value.text, style: style),
        if (suffixText != null) ...[
          if (_hasFocus || value.text.isNotEmpty)
          TextSpan(text: '$suffixText', style: style),
        ],
      ],
    );
  }
}
