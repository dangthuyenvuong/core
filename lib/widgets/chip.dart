import 'package:core/core.dart';
import 'package:flutter/material.dart';

class SChips extends StatefulWidget {
  const SChips({
    super.key,
    required this.chips,
    this.onChange,
    this.allowToggle = false,
    this.padding = const EdgeInsets.symmetric(),
    this.fontSize = 14,
    this.multiple = false,
    this.selected = const [],
    this.activeBgColor = Colors.blue,
  });
  final List<String> chips;
  final Function(int)? onChange;
  final bool allowToggle;
  final EdgeInsets padding;
  final double fontSize;
  final bool multiple;
  final List<int> selected;
  final Color activeBgColor;

  @override
  State<SChips> createState() => _SChipsState();
}

class _SChipsState extends State<SChips> {
  int selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: widget.padding,
        child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            spacing: Spacing.small,
            children: List.generate(widget.chips.length, (index) {
              return SChip(
                activeBgColor: widget.activeBgColor,
                child: Text(
                  widget.chips[index],
                  style: TextStyle(fontSize: widget.fontSize),
                ),
                isSelected: selectedIndex == index,
                onTap: () {
                  if (widget.allowToggle && index == selectedIndex) {
                    _onTap(-1);
                    widget.onChange?.call(-1);
                  } else if (index != selectedIndex) {
                    _onTap(index);
                    widget.onChange?.call(index);
                  }
                },
              );
            })),
      ),
    );
  }
}

class SChip extends StatelessWidget {
  const SChip({
    super.key,
    this.child,
    this.isSelected = false,
    this.onTap,
    this.bgColor,
    this.textColor,
    this.padding =
        const EdgeInsets.symmetric(vertical: 6, horizontal: Spacing.medium),
    this.radius = 999,
    this.action,
    this.leading,
    this.activeBgColor = Colors.blueAccent,
  });
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? child;
  final Color? bgColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final double radius;
  final Widget? action;
  final Widget? leading;
  final Color activeBgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color:
            isSelected ? activeBgColor : bgColor ?? Colors.grey.withAlpha(40),
      ),
      // color: Colors.red.withAlpha(100),
      // height: 30,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Container(
          padding: padding,
          child: DefaultTextStyle(
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: isSelected
                  ? Colors.white
                  : textColor ??
                      Theme.of(context).colorScheme.onSurface.withAlpha(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: Spacing.xSmall,
              children: [
                if (leading != null) leading!,
                if (child != null) child!,
                if (action != null) action!
              ],
            ),
          ),
        ),
      ),
    );
  }
}
