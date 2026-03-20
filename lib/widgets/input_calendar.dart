import 'package:core/core.dart';
import 'package:core/input_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SInputCalendar extends StatefulWidget {
  const SInputCalendar({
    this.hintText,
    this.labelText,
    this.validator,
    // this.controller,
    this.isRequired = false,
    this.multiline = false,
    this.minLine,
    this.maxLine,
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
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.onClear,
    this.onChanged,
    this.value,
    this.format = 'dd/MM/yyyy',
    this.allowClear = false,
    this.showError,
    this.style,
  }) : assert(initialDateTime == null || value == null,
            "Initial date time and value must be provided");

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
  final Widget? suffix;
  final Widget? icon;
  final TextInputType? keyboardType;
  final EdgeInsets contentPadding;
  final Color? bgColor;
  final bool hideBorder;
  final double? radius;
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final Function(DateTime)? onChanged;
  final Function()? onClear;
  final DateTime? value;
  final String format;
  final bool allowClear;
  final bool? showError;
  final TextStyle? style;
  @override
  State<SInputCalendar> createState() => _SInputCalendarState();
}

class _SInputCalendarState extends State<SInputCalendar> {
  late InputController _controller;
  FocusNode _focusNode = FocusNode();
  bool isFocused = false;

  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
    _focusNode.addListener(() async {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });

      if (_focusNode.hasFocus) {
        _focusNode.unfocus();

        await Cupertino.showDatePicker(
          context: context,
          initialDateTime: widget.value ?? DateTime.now(),
          minimumDate: widget.minimumDate,
          maximumDate: widget.maximumDate,
          // onDateTimeChange: (DateTime date) {
          //   _controller.controller.text = date.toLocal().format('dd/MM/yyyy');
          // },
          onDateTimeComplete: (DateTime date) {
            selectedDateTime = date.toLocal();
            _controller.controller.text =
                selectedDateTime!.toLocal().format(widget.format);
            widget.onChanged?.call(selectedDateTime!);
          },
          onClear: widget.onClear,
          allowClear: widget.allowClear,
        );
      }
    });

    _controller = widget.controller ?? InputController();
    _controller.controller.text =
        widget.value?.toLocal().format(widget.format) ?? '';
  }

  @override
  void didUpdateWidget(SInputCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.controller.text =
          widget.value?.toLocal().format(widget.format) ?? '';
    }
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

    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: InputWrapper(
          controller: _controller,
          isFocused: isFocused,
          bgColor: widget.bgColor,
          radius: widget.radius,
          hideBorder: widget.hideBorder,
          helperText: widget.helperText,
          showError: widget.showError ?? _controller.rules.isNotEmpty,
          child: Container(
            // padding: EdgeInsets.symmetric(vertical: Spacing.small),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  focusNode: _focusNode,
                  controller: _controller.controller,
                  style: TextStyle(fontSize: 14).merge(widget.style),
                  decoration: InputDecoration(
                    isDense: true,
                    label: widget.labelText != null
                        ? Text(widget.labelText!,
                            style: TextStyle(
                              fontSize: 16,
                              color: onSurface.withAlpha(100),
                              fontWeight: FontWeight.w500,
                            ))
                        : null,
                    labelStyle: widget.labelStyle,
                    contentPadding: widget.contentPadding,
                    border: InputBorder.none,
                    // decoration: InputDecoration(
                    //   border: InputBorder.none,
                    //   labelText: widget.labelText ?? '',
                    //   hintStyle: TextStyle(
                    //     fontSize: 14,
                    //     color: onSurface.withAlpha(100),
                    //   ),
                    // ),
                  ),
                )),
                Icon(CupertinoIcons.calendar,
                    size: 20, color: onSurface.withAlpha(100)),
              ],
            ),
          )),
    );
  }
}
