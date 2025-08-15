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
  });
  final List<T> values;
  final Function(T)? onChanged;
  final Widget Function(T) builder;
  final T? init;
  final double? width;
  final T? value;

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

    return AnimatedToggleSwitch<T>.size(
      current: _value,
      values: widget.values,
      iconOpacity: 0.5,
      selectedIconScale: 1,
      animationDuration: kThemeAnimationDuration,
      height: 35,
      indicatorSize: Size.fromWidth(widget.width ?? 90),
      onChanged: (i) {
        setState(() => _value = i);
        widget.onChanged?.call(i);
      },
      styleBuilder: (i) => ToggleStyle(),
      iconBuilder: (item) {
        return widget.builder(item);
        // return Text(
        //   '$item',
        //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        // );
      },
      style: ToggleStyle(
        // backgroundColor: Colors.black,
        indicatorColor: isDarkMode ? Colors.black : Colors.white,
        borderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
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
