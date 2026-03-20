import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputSearch extends StatefulWidget {
  const InputSearch({
    super.key,
    this.focusNode,
    this.hintText,
    this.autofocus = false,
    this.showIcon = true,
    this.onChanged,
    this.controller,
    this.style,
  });
  final String? hintText;
  final bool autofocus;
  final bool showIcon;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;

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
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final bg = Theme.of(context).scaffoldBackgroundColor;

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
                  Icon(
                    CupertinoIcons.search,
                    size: 16,
                  ),
                // SvgPicture.asset(
                //   'assets/images/svg/search.svg',
                //   width: 20,
                //   height: 20,
                //   package: 'core',
                //   colorFilter: ColorFilter.mode(
                //     Theme.of(context).colorScheme.surface.withAlpha(200),
                //     BlendMode.srcIn,
                //   ),
                // ),
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    focusNode: widget.focusNode,
                    onChanged: (value) {
                      widget.onChanged?.call(value);
                      setState(() {});
                    },
                    // inputFormatters: [
                    //   LengthLimitingTextInputFormatter(30)
                    // ],
                    style: widget.style ?? TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                    cursorHeight: 16,
                    autofocus: widget.autofocus,
                    autocorrect: false,
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: widget.hintText,
                        hintStyle:
                            TextStyle(color: hintTextColor.withAlpha(100)),
                        // focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        // errorBorder: InputBorder.none,
                        // disabledBorder: InputBorder.none,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero),
                  ),
                ),
                if (_textEditingController.text.isNotEmpty)
                  SIconButton(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: onSurface,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 14,
                        color: bg,
                      ),
                    ),
                    // child: SvgPicture.asset(
                    //   'assets/images/svg/x-fill.svg',
                    //   width: 20,
                    //   height: 20,
                    //   package: 'core',
                    //   colorFilter: ColorFilter.mode(
                    //       Theme.of(context).colorScheme.surface.withAlpha(200),
                    //       BlendMode.srcIn),
                    // ),
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
