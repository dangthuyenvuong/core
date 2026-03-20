import 'package:core/core.dart';
import 'package:core/extensions/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInputField extends StatefulWidget {
  final int length;
  final void Function(String)? onChanged;

  const OTPInputField({
    super.key,
    this.length = 6,
    this.onChanged,
  });

  @override
  State<OTPInputField> createState() => OTPInputFieldState();
}

class OTPInputFieldState extends State<OTPInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleTextChanged(String value, int index) {
    if (value.isEmpty) return;

    // Nếu paste nhiều ký tự
    if (value.length > 1) {
      if (value.length >= widget.length) {
        _handlePaste(value.lastN(widget.length),
            value.length >= widget.length ? 0 : index);
      } else {
        _handlePaste(value, value.length >= widget.length ? 0 : index);
      }
      return;
    }

    // 🔥 Luôn force replace
    final newChar = value.characters.last;

    _controllers[index]
      ..text = newChar
      ..selection = const TextSelection.collapsed(offset: 1);

    // 🔥 Auto jump next
    if (index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    onChange();
  }

  void onChange() {
    String otp = _controllers.map((e) => e.text).join();
    widget.onChanged?.call(otp);
  }

  void _handleKeyEvent(KeyEvent event, int index) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      // Nếu ô hiện tại có giá trị → xóa nó
      if (_controllers[index].text.isNotEmpty) {
        _controllers[index].clear();
        return;
      }

      // Nếu ô trống → xóa ô trước và focus về đó
      if (index > 0) {
        _controllers[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _handlePaste(String value, int index) {
    final chars = value.characters.toList();

    for (int i = 0; i < chars.length; i++) {
      final target = index + i;
      if (target >= widget.length) break;

      _controllers[target].text = chars[i];
    }

    final last = (index + chars.length - 1).clamp(0, widget.length - 1);

    _focusNodes[last].requestFocus();
    onChange();
  }

  void focus() {
    _focusNodes.first.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      children: List.generate(widget.length, (index) {
        return Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: () {
                _focusNodes[index].requestFocus();
              },
              child: Container(
                margin: EdgeInsets.only(
                    right: index == widget.length - 1 ? 0 : Spacing.small),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: onSurface.withAlpha(30)),
                ),
                alignment: Alignment.center,
                child: Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.backspace) {
                      _handleKeyEvent(event, index);
                      onChange();
                      return KeyEventResult.handled;
                    }

                    return KeyEventResult.ignored; // ✅ cho TextField xử lý
                  },
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    // keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      // FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(1),
                    ],
                    // maxLength: 1,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      isDense: true,
                      counterText: "",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => _handleTextChanged(value, index),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
