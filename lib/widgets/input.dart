import 'package:core/core.dart';
import 'package:core/input_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DecimalFormatter extends TextInputFormatter {
  // Regex hợp lệ cho input cuối cùng
  // - 0 hoặc 0.xxxxx
  // - hoặc số bắt đầu bằng 1-9, theo sau tùy ý số, có thể có [.,] và tối đa 5 chữ số sau
  late RegExp validRegex;

  // Regex phát hiện string bắt đầu bằng nhiều '0' rồi theo sau 1 digit (không phải dấu thập phân)
  late RegExp leadingZerosThenDigit;

  DecimalFormatter({int maxDecimal = 2, int? min}) {
    if (min != null) {
      validRegex = RegExp(
        r'^(0([.,]\d{0,' +
            maxDecimal.toString() +
            r'})?|[1-9]\d*([.,]\d{0,' +
            maxDecimal.toString() +
            r'})?)$',
      );
    } else {
      validRegex = RegExp(
        r'^(0([.,]\d{0,' +
            maxDecimal.toString() +
            r'})?|[1-9]\d*([.,]\d{0,' +
            maxDecimal.toString() +
            r'})?)$',
      );
    }

    leadingZerosThenDigit = RegExp(
      r'^0+([1-9]\d*(?:[.,]\d{0,' + maxDecimal.toString() + r'})?)$',
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newText = newValue.text;

    // Cho phép empty (user xóa hết)
    if (newText.isEmpty) return newValue;

    // Nếu hợp lệ theo regex thì accept luôn
    if (validRegex.hasMatch(newText)) {
      return newValue;
    }

    // Nếu newText là dạng "0" + tiếp digit (ví dụ "05" hoặc "0005" hoặc "00 5")
    // thì chuyển thành bỏ các zero đầu, giữ phần sau (ví dụ "05" -> "5", "00012" -> "12")
    final m = leadingZerosThenDigit.firstMatch(newText);
    if (m != null) {
      final String fixed = m.group(1)!; // phần sau các zero
      // build TextEditingValue mới và đặt caret ở cuối
      return TextEditingValue(
        text: fixed,
        selection: TextSelection.collapsed(offset: fixed.length),
      );
    }

    // Nếu user chỉ gõ dấu '.' hoặc ',' ở đầu -> tự prepend '0' => "0." (tùy muốn)
    if (newText == '.' || newText == ',') {
      const fixed = '0.';
      return TextEditingValue(
        text: fixed,
        selection: const TextSelection.collapsed(offset: fixed.length),
      );
    }

    // Các trường hợp khác (không hợp lệ) -> giữ nguyên oldValue (không xoá toàn bộ)
    return oldValue;
  }
}

class IntFormatter extends TextInputFormatter {
  // Regex hợp lệ cho input cuối cùng
  // - 0 hoặc 0.xxxxx
  // - hoặc số bắt đầu bằng 1-9, theo sau tùy ý số, có thể có [.,] và tối đa 5 chữ số sau
  late RegExp validRegex;

  // Regex phát hiện string bắt đầu bằng nhiều '0' rồi theo sau 1 digit (không phải dấu thập phân)
  late RegExp leadingZerosThenDigit;

  IntFormatter() {
    validRegex = RegExp(
      r'^([1-9]\d*)$',
    );

    leadingZerosThenDigit = RegExp(
      r'^0+([1-9]\d*)$',
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newText = newValue.text;

    // Cho phép empty (user xóa hết)
    if (newText.isEmpty) return newValue;

    // Nếu hợp lệ theo regex thì accept luôn
    if (validRegex.hasMatch(newText)) {
      return newValue;
    }

    // Nếu newText là dạng "0" + tiếp digit (ví dụ "05" hoặc "0005" hoặc "00 5")
    // thì chuyển thành bỏ các zero đầu, giữ phần sau (ví dụ "05" -> "5", "00012" -> "12")
    final m = leadingZerosThenDigit.firstMatch(newText);
    if (m != null) {
      final String fixed = m.group(1)!; // phần sau các zero
      // build TextEditingValue mới và đặt caret ở cuối
      return TextEditingValue(
        text: fixed,
        selection: TextSelection.collapsed(offset: fixed.length),
      );
    }

    // Nếu user chỉ gõ dấu '.' hoặc ',' ở đầu -> tự prepend '0' => "0." (tùy muốn)
    // if (newText == '.' || newText == ',') {
    //   const fixed = '0.';
    //   return TextEditingValue(
    //     text: fixed,
    //     selection: const TextSelection.collapsed(offset: fixed.length),
    //   );
    // }

    // Các trường hợp khác (không hợp lệ) -> giữ nguyên oldValue (không xoá toàn bộ)
    return oldValue;
  }
}

class SInputFormat {
  static TextInputFormatter doubleFormatter({int maxDecimal = 2, int? min}) {
    return DecimalFormatter(maxDecimal: maxDecimal, min: min);
  }

  static TextInputFormatter intFormatter() {
    return IntFormatter();
  }
}

class SInputKeyboarType {
  static TextInputType double() {
    return TextInputType.numberWithOptions(
      decimal: true,
    );
  }

  static TextInputType int() {
    return TextInputType.number;
  }
}

class SInput extends StatefulWidget {
  const SInput({
    super.key,
    this.hintText,
    this.labelText,
    this.validator,
    // this.controller,
    this.isRequired = false,
    this.multiline = false,
    this.minLine,
    this.maxLine,
    this.onChanged,
    this.controller,
    this.autofocus = false,
    this.labelStyle,
    this.maxLength,
    this.suffix,
    this.icon,
    this.keyboardType,
    this.contentPadding = const EdgeInsets.only(bottom: 10, top: 10),
    this.bgColor,
    this.hideBorder = false,
    this.radius,
    this.helperText,
    this.clearable = false,
    this.style,
    this.isTextEditable = false,
    this.enabled = true,
    this.showError,
    this.initialValue,
    this.onTap,
    this.inputFormatters,
    this.focusNode,
    this.suffixText,
    this.enableInteractiveSelection,
    this.textInputAction,
    this.textAlign,
    this.onSubmitted,
  });

  final String? helperText;
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
  final int? minLine;
  final int? maxLine;
  final Function(String)? onChanged;
  final Widget? suffix;
  final Widget? icon;
  final TextInputType? keyboardType;
  final EdgeInsets contentPadding;
  final Color? bgColor;
  final bool hideBorder;
  final double? radius;
  final bool clearable;
  final TextStyle? style;
  final bool isTextEditable;
  final bool enabled;
  final bool? showError;
  final String? initialValue;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final String? suffixText;
  final bool? enableInteractiveSelection;
  final TextInputAction? textInputAction;
  final TextAlign? textAlign;
  final Function(String)? onSubmitted;

  @override
  State<SInput> createState() => _SInputState();
}

class _SInputState extends State<SInput> {
  late InputController _controller;
  late FocusNode _focusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });

    _controller = widget.controller ??
        InputController(
            value: widget.initialValue, suffixText: widget.suffixText);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(SInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller &&
        widget.controller != null) {
      _controller = widget.controller!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;

    final hideBorder = widget.hideBorder == true || widget.isTextEditable;

    return ValueListenableBuilder(
        valueListenable: _controller.error,
        builder: (context, error, child) {
          final isError = error != null && error.isNotEmpty;

          return GestureDetector(
            onTap: widget.onTap,
            child: Column(
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
                    color: widget.bgColor,
                    borderRadius: widget.radius != null
                        ? BorderRadius.circular(widget.radius!)
                        : null,
                    border: hideBorder
                        ? null
                        : Border(
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
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: widget.textAlign ?? TextAlign.start,
                          textInputAction: widget.textInputAction,
                          enableInteractiveSelection:
                              widget.enableInteractiveSelection,
                          enabled: widget.enabled,
                          // scrollPadding: EdgeInsets.zero,
                          maxLines: widget.multiline == true
                              ? widget.maxLine ?? 999
                              : 1,
                          minLines: widget.multiline == true
                              ? widget.minLine ?? 1
                              : 1,
                          cursorColor: primary,
                          controller: _controller.controller,
                          cursorHeight: 16,
                          style: TextStyle(fontSize: 14).merge(widget.style),
                          maxLength: widget.maxLength,
                          keyboardType: widget.keyboardType,
                          inputFormatters: widget.inputFormatters,
                          autofocus: widget.autofocus ?? false,
                          // keyboardAppearance: Brightness.light,
                          focusNode: _focusNode,
                          onChanged: (value) {
                            // widget.controller?.setValue(value);
                            widget.controller?.validate();
                            widget.onChanged?.call(value);
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            label: widget.labelText != null
                                ? Text(widget.labelText!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isError
                                          ? Colors.red
                                          : onSurface.withAlpha(100),
                                      fontWeight: FontWeight.w500,
                                    ).merge(widget.labelStyle))
                                : null,
                            labelStyle: widget.labelStyle,
                            contentPadding: widget.isTextEditable
                                ? EdgeInsets.zero
                                : widget.contentPadding,
                            hintText: widget.hintText,
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: onSurface.withAlpha(100)),
                            suffix: widget.suffix,
                            icon: widget.icon,
                            counterText: '',
                            // counterStyle:
                            //     TextStyle(color: onSurface.withAlpha(150)),
                          ),
                          onSubmitted: widget.onSubmitted,
                        ),
                      ),
                      // if (widget.suffix != null)
                      //   Container(
                      //     margin: EdgeInsets.only(bottom: Spacing.small),
                      //     child: widget.suffix!),
                      if (widget.clearable &&
                          _controller.controller.text.isNotEmpty == true)
                        SIconButton(
                          child: Icon(CupertinoIcons.xmark,
                              size: 20, color: onSurface.withAlpha(100)),
                          // child: SvgPicture.asset(
                          //   'assets/images/svg/x-fill.svg',
                          //   width: 20,
                          //   height: 20,
                          //   colorFilter: ColorFilter.mode(
                          //       Theme.of(context)
                          //           .colorScheme
                          //           .surface
                          //           .withAlpha(200),
                          //       BlendMode.srcIn),
                          // ),
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
                if (widget.showError ?? _controller.rules.isNotEmpty)
                  Text(error ?? '',
                      style: TextStyle(
                        height: 1,
                        fontSize: 12,
                        color: Colors.red,
                      )),
                if (widget.helperText != null)
                  Text(widget.helperText!,
                      style: TextStyle(
                        fontSize: 12,
                        color: onSurface.withAlpha(100),
                      )),
              ],
            ),
          );
        });
  }
}

class InputWrapper extends StatelessWidget {
  const InputWrapper({
    super.key,
    required this.controller,
    required this.child,
    this.helperText,
    this.isFocused = false,
    this.bgColor,
    this.hideBorder = false,
    this.radius,
    this.clearable = false,
    this.showError,
  });
  final InputController controller;
  final Widget child;
  final String? helperText;
  final bool isFocused;
  final Color? bgColor;
  final bool hideBorder;
  final double? radius;
  final bool clearable;
  final bool? showError;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;

    return ValueListenableBuilder(
        valueListenable: controller.error,
        child: child,
        builder: (context, error, child) {
          final isError = error != null && error.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.xSmall,
            key: controller.targetKey,
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
                  color: bgColor,
                  borderRadius:
                      radius != null ? BorderRadius.circular(radius!) : null,
                  border: hideBorder
                      ? null
                      : Border(
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
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: child!,
                    ),
                    // if (widget.suffix != null)
                    //   Container(
                    //     margin: EdgeInsets.only(bottom: Spacing.small),
                    //     child: widget.suffix!),
                    if (clearable &&
                        controller.controller.text.isNotEmpty == true)
                      SIconButton(
                        child: Icon(CupertinoIcons.xmark,
                            size: 20, color: onSurface.withAlpha(100)),
                        // child: SvgPicture.asset(
                        //   'assets/images/svg/x-fill.svg',
                        //   width: 20,
                        //   height: 20,
                        //   colorFilter: ColorFilter.mode(
                        //       Theme.of(context)
                        //           .colorScheme
                        //           .surface
                        //           .withAlpha(200),
                        //       BlendMode.srcIn),
                        // ),
                        onTap: () {
                          // _controller.controller?.clear();
                          // widget.controller?.setValue('');
                          // widget.controller?.validate();
                          // widget.onChanged?.call('');
                        },
                      ),
                  ],
                ),
              ),
              // if (widget.controller != null)
              if (showError == true)
                Text(error ?? '',
                    style: TextStyle(
                      height: 1,
                      fontSize: 12,
                      color: Colors.red,
                    )),
              if (helperText != null)
                Text(helperText!,
                    style: TextStyle(
                      fontSize: 13,
                      color: onSurface.withAlpha(100),
                    )),
            ],
          );
        });
  }
}
