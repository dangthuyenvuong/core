import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class STab<T> extends StatefulWidget {
  const STab({
    super.key,
    required this.values,
    this.onChanged,
    required this.builder,
    this.init,
    this.width,
    this.value,
    this.height = 35,
    this.enabled = true,
    this.radius = 999,
    this.indicatorColor,
    this.backgroundColor,
  });
  final List<T> values;
  final Function(T)? onChanged;
  final Widget Function(T) builder;
  final T? init;
  final double? width;
  final T? value;
  final double height;
  final bool? enabled;
  final double radius;
  final Color? indicatorColor;
  final Color? backgroundColor;

  @override
  State<STab<T>> createState() => _STabState<T>();
}

class _STabState<T> extends State<STab<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? widget.init ?? widget.values.first;
  }

  @override
  void didUpdateWidget(STab<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _value) {
      _value = widget.value!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bg = getBgMode(context);
    final enabled = widget.enabled ?? true;
    return AnimatedToggleSwitch<T>.size(
      current: _value,
      values: widget.values,
      iconOpacity: 0.5,
      selectedIconScale: 1,
      borderWidth: 2,
      animationDuration: kThemeAnimationDuration,
      height: widget.height,
      indicatorSize: Size.fromWidth(widget.width ?? 90),
      onChanged: (i) {
        if (!enabled) return;
        setState(() => _value = i);
        widget.onChanged?.call(i);
      },
      styleBuilder: (i) => ToggleStyle(),
      iconBuilder: (item) {
        return FittedBox(fit: BoxFit.scaleDown, child: widget.builder(item));
        // return Text(
        //   '$item',
        //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        // );
      },
      style: ToggleStyle(
        // backgroundColor: Colors.black,
        indicatorColor:
            widget.indicatorColor ?? (isDarkMode ? Colors.black : Colors.white),
        borderColor: Colors.transparent,
        backgroundColor: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.radius),
        indicatorBorderRadius: BorderRadius.circular(widget.radius - 2),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black26,
        //     spreadRadius: 1,
        //     blurRadius: 2,
        //     offset: Offset(0, 1.5),
        //   ),
        // ],
      ),
      // iconList: [...], you can use iconBuilder, customIconBuilder or iconList
      // style: ToggleStyle(...), // optional style settings
    );
  }
}
