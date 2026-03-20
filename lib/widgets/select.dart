import 'package:core/constants/icon.dart';
import 'package:core/core.dart';
import 'package:core/widgets/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SSelect extends StatefulWidget {
  const SSelect({
    super.key,
    this.labelText,
    this.controller,
    this.contentPadding = const EdgeInsets.only(bottom: 10, top: 10),
    this.hideBorder = false,
    this.helperText,
    required this.items,
    this.onChanged,
    this.useBottomSheet = false,
  });
  final String? helperText;
  final String? labelText;
  final InputController? controller;
  final EdgeInsets contentPadding;
  final bool hideBorder;
  final List<String> items;
  final Function(int index)? onChanged;
  final bool useBottomSheet;

  @override
  State<SSelect> createState() => _SSelectState();
}

class _SSelectState extends State<SSelect> {
  late InputController _controller;
  bool isFocused = false;
  FocusNode _focusNode = FocusNode();
  final GlobalKey _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? InputController();

    _focusNode.addListener(() async {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
      // if (_focusNode.hasFocus) {
      //   showMenu(context: context, items: [
      //     PopupMenuItem(
      //       child: Text("Item 1"),
      //     ),
      //     PopupMenuItem(
      //       child: Text("Item 2"),
      //     ),
      //   ]);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        if (widget.useBottomSheet) {
          Modal.showSelectBottomSheet(
            context: context,
            items: widget.items,
            value: widget.controller?.text,
            onSelected: (v, i) {
              widget.controller?.text = v;
              widget.onChanged?.call(i);
            },
            buildOption: (v) {
              return ActionSheet(title: Text(v));
            },
            // onSelected: (value) {
            //   widget.ingredient.unit = value;
            //   widget.onChanged(widget.ingredient);
            // },
          );
          return;
        }
        final RenderBox renderBox =
            _key.currentContext!.findRenderObject() as RenderBox;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;
        showMenu(
            context: context,
            menuPadding: EdgeInsets.zero,
            position: RelativeRect.fromLTRB(
              offset.dx,
              offset.dy + renderBox.size.height - 20, // 👈 dưới button
              offset.dx + renderBox.size.width,
              0,
            ),
            constraints: BoxConstraints(
              maxWidth: size.width,
              minWidth: size.width,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            items: widget.items
                .mapV2((e, index) => PopupMenuItem(
                      // padding: EdgeInsets.only(),
                      child: Text(e),
                      onTap: () {
                        widget.onChanged?.call(index);
                        _controller.text = e;
                      },
                    ))
                .toList());
      },
      child: InputWrapper(
        key: _key,
        helperText: widget.helperText,
        controller: _controller,
        isFocused: isFocused,
        hideBorder: widget.hideBorder,
        showError: _controller.rules.isNotEmpty,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                enabled: false,
                controller: _controller.controller,
                focusNode: _focusNode,
                style: TextStyle(fontSize: 14, color: onSurface),
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
                  contentPadding: widget.contentPadding,
                  border: InputBorder.none,
                ),
              ),
            ),
            Core.svgAsset(
              CoreIcons.chevronUpDown,
              size: 20,
              color: onSurface.withAlpha(100),
              package: 'core',
            ),
          ],
        ),
      ),
    );
  }
}

class SSelectWraper<T> extends StatefulWidget {
  const SSelectWraper(
      {super.key,
      this.items = const [],
      required this.onChanged,
      required this.child,
      this.dropdownWidth,
      this.enabled = true,
      this.buildItem})
      : assert(!(buildItem == null && items.length == 0),
            "buildItem or items must be provided");
  final List<T> items;
  final Function(int index)? onChanged;
  final Widget child;
  final bool enabled;
  final double? dropdownWidth;
  final Widget Function(T item)? buildItem;

  @override
  State<SSelectWraper> createState() => _SSelectWraperState<T>();
}

class _SSelectWraperState<T> extends State<SSelectWraper<T>> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.enabled) return;
        final RenderBox renderBox =
            _key.currentContext!.findRenderObject() as RenderBox;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        showMenu(
            context: context,
            menuPadding: EdgeInsets.zero,
            position: RelativeRect.fromLTRB(
              offset.dx,
              offset.dy + renderBox.size.height, // 👈 dưới button
              offset.dx + renderBox.size.width,
              0,
            ),
            constraints: BoxConstraints(
              maxWidth: widget.dropdownWidth ?? size.width,
              minWidth: widget.dropdownWidth ?? size.width,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            useRootNavigator: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.small),
            ),
            clipBehavior: Clip.hardEdge,
            items: widget.items
                .mapV2((e, index) => PopupMenuItem(
                      child: widget.buildItem?.call(e) ??
                          Text(e is String ? e : ""),
                      onTap: () {
                        widget.onChanged?.call(index);
                      },
                    ))
                .toList());
      },
      behavior: HitTestBehavior.opaque,
      child: KeyedSubtree(
        key: _key,
        child: widget.child,
      ),
    );
  }
}
