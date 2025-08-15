import 'package:core/core.dart';
import 'package:core/input_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SInput extends StatefulWidget {
  const SInput({
    this.hintText,
    this.labelText,
    this.validator,
    // this.controller,
    this.isRequired = false,
    this.multiline = false,
    this.minLine = 1,
    this.maxLine = 1,
    this.onChanged,
    this.controller,
    this.autofocus = false,
    this.labelStyle,
    this.maxLength,
  });

  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  // final TextEditingController? controller;
  final InputController? controller;
  final bool? autofocus;
  final TextStyle? labelStyle;
  final int? maxLength;

  final bool? isRequired;
  final bool? multiline;
  final int minLine;
  final int maxLine;
  final Function(String)? onChanged;

  @override
  State<SInput> createState() => _SInputState();
}

class _SInputState extends State<SInput> {
  late InputController _controller;
  FocusNode _focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });

    _controller = widget.controller ?? InputController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;

    return ValueListenableBuilder(
        valueListenable: _controller.error,
        builder: (context, error, child) {
          final isError = error != null && error.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.xSmall,
            key: _controller.targetKey,
            children: [
              // if (labelText != null)
              //   Text(
              //     '$labelText:',
              //     style: TextStyle(
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isError
                          ? Colors.red
                          : isFocused
                              ? primary
                              : onSurface.withAlpha(50),
                    ),
                    // bottom: BorderSide(color: onSurface.withAlpha(15)),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: widget.multiline == true ? widget.maxLine : 1,
                        minLines: widget.multiline == true ? widget.minLine : 1,
                        cursorColor: onSurface,
                        controller: _controller.controller,
                        cursorHeight: 16,
                        style: TextStyle(fontSize: 14),
                        maxLength: widget.maxLength,
                        autofocus: widget.autofocus ?? false,
                        focusNode: _focusNode,
                        onChanged: (value) {
                          widget.controller?.setValue(value);
                          widget.controller?.validate();
                          widget.onChanged?.call(value);
                        },
                        decoration: InputDecoration(
                          label: widget.labelText != null
                              ? Text(widget.labelText!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isError
                                        ? Colors.red
                                        : onSurface.withAlpha(100),
                                    fontWeight: FontWeight.w500,
                                  ))
                              : null,
                          labelStyle: widget.labelStyle,
                          contentPadding: EdgeInsets.only(bottom: 0, top: 0),
                          hintText: widget.hintText,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: onSurface.withAlpha(100)),
                        ),
                      ),
                    ),
                    if (_controller.controller?.text.isNotEmpty == true)
                      SIconButton(
                        child: SvgPicture.asset(
                          'assets/images/svg/x-fill.svg',
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withAlpha(200),
                              BlendMode.srcIn),
                        ),
                        onTap: () {
                          _controller.controller?.clear();
                          widget.controller?.setValue('');
                          widget.controller?.validate();
                          widget.onChanged?.call('');
                        },
                      ),
                  ],
                ),
              ),
              if (widget.controller != null)
                Text(error ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    )),
            ],
          );
        });
  }
}
