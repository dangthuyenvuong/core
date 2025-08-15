import 'package:core/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputField extends StatefulWidget {
  InputField({
    super.key,
    this.hintText = '',
    this.labelText = '',
    this.labelStyle,
    this.trailing,
    this.maxLength,
    this.onChanged,
    this.maxLines,
    this.isMultiline,
    this.autofocus,
    this.controller,
    this.hintStyle,
    this.labelInsideText,
    this.textAlign,
    this.style,
    this.enabled,
  });

  final String hintText;
  final String labelText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final String? labelInsideText;
  final List<Widget>? trailing;
  final int? maxLength;
  final Function(String)? onChanged;
  final int? maxLines;
  final bool? isMultiline;
  final bool? autofocus;
  final TextEditingController? controller;
  final TextAlign? textAlign;
  final TextStyle? style;
  final bool? enabled;
  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController controller;
  int length = 0;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    controller.addListener(() {
      widget.onChanged?.call(controller.text);
      setState(() {
        length = controller.text.length;
      });
    });

    setState(() {
      length = controller.text.length;
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isError =
        widget.maxLength != null ? length > widget.maxLength! : false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(widget.labelText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ))),
            if (widget.maxLength != null)
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: '$length',
                    style: TextStyle(
                      color: isError ? Colors.red : Colors.grey,
                    )),
                TextSpan(
                    text: '/${widget.maxLength}',
                    style: TextStyle(color: Colors.grey)),
              ]))
          ],
        ),
        Container(
          // margin: EdgeInsets.only(bottom: Spacing.small),
          padding: EdgeInsets.only(bottom: Spacing.small),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isError ? Colors.red : Colors.grey.withAlpha(50),
              ),
            ),
          ),
          child: TextField(
            enabled: widget.enabled,
            style: widget.style,
            textAlign: widget.textAlign ?? TextAlign.start,
            maxLines: widget.isMultiline == true ? widget.maxLines : 1,
            autofocus: widget.autofocus == true,
            cursorColor: Constant.red,
            cursorHeight: 16,
            controller: controller,
            autocorrect: false,
            maxLength: widget.maxLength,
            buildCounter: (context,
                {required currentLength,
                required maxLength,
                required isFocused}) {
              // return Text(
              //   '$currentLength/$maxLength',
              //   style: TextStyle(color: Colors.grey),
              // );
              return null;
            },
            // onChanged: (value) {
            //   widget.onChanged?.call(value);
            // },
            decoration: InputDecoration(
              labelText: widget.labelInsideText,
              hintText: widget.hintText,
              labelStyle: widget.labelStyle,
              hintStyle: widget.hintStyle ?? TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                // borderRadius: BorderRadius.circular(Spacing.small),
              ),
            ),
          ),
        ),
        Opacity(
            opacity: isError ? 1 : 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: Spacing.small),
              child: Text.rich(
                  style: TextStyle(color: Colors.red),
                  TextSpan(children: [
                    WidgetSpan(
                      // child: SvgPicture.asset(
                      //   'assets/images/svg/exclamation-triangle-fill.svg',
                      //   width: 16,
                      //   height: 16,
                      //   colorFilter: ColorFilter.mode(
                      //     Colors.red,
                      //     BlendMode.srcIn,
                      //   ),
                      // ),
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                    TextSpan(text: ' ${tr('Exceeded the character limit')}'),
                  ])),
            )),
        if (widget.trailing != null) ...widget.trailing!
      ],
    );
  }
}

void inputBlur(BuildContext context) {
  FocusScope.of(context).unfocus();
}
