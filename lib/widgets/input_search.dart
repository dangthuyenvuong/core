import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputSearch extends StatefulWidget {
  const InputSearch({
    super.key,
    this.hintText,
    this.autofocus = false,
    this.showIcon = true,
    this.onChanged,
    this.controller,
  });
  final String? hintText;
  final bool autofocus;
  final bool showIcon;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textEditingController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hintTextColor = isDarkMode ? Colors.white : Colors.black;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            height: 36,
            padding: EdgeInsets.only(left: Spacing.small),
            decoration: BoxDecoration(
              color: bgColor.withAlpha(50),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                if (widget.showIcon)
                  SvgPicture.asset(
                    'assets/images/svg/search.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.surface.withAlpha(200),
                      BlendMode.srcIn,
                    ),
                  ),
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: (value) {
                      widget.onChanged?.call(value);
                      setState(() {});
                    },
                    // inputFormatters: [
                    //   LengthLimitingTextInputFormatter(30)
                    // ],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                    cursorHeight: 16,
                    autofocus: widget.autofocus,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(color: hintTextColor.withAlpha(100)),
                      // focusedBorder: InputBorder.none,
                      // enabledBorder: InputBorder.none,
                      // errorBorder: InputBorder.none,
                      // disabledBorder: InputBorder.none,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.only(left: Spacing.small, right: 0),
                    ),
                  ),
                ),
                if (_textEditingController.text.isNotEmpty)
                  SIconButton(
                    child: SvgPicture.asset(
                      'assets/images/svg/x-fill.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.surface.withAlpha(200),
                          BlendMode.srcIn),
                    ),
                    onTap: () {
                      _textEditingController.clear();
                      widget.onChanged?.call("");
                      setState(() {});
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
