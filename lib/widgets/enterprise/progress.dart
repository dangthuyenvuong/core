import 'package:flutter/material.dart';

class RangeColor {
  final double start;
  final Color color;
  RangeColor({required this.start, required this.color});
}

class EProgress extends StatefulWidget {
  const EProgress(
      {super.key,
      required this.value,
      this.color = Colors.white,
      required this.backgroundColor,
      this.rangeValues,
      this.height = 8})
      : assert(color != null || rangeValues != null,
            'color or rangeValues must be provided');
  final double value;
  final Color color;
  final Color backgroundColor;
  final List<RangeColor>? rangeValues;
  final double height;

  @override
  State<EProgress> createState() => _EProgressState();
}

class _EProgressState extends State<EProgress> {
  late List<RangeColor> _rangeValues;

  @override
  void initState() {
    super.initState();
    _rangeValues = (widget.rangeValues ?? []).toList();
    _rangeValues.sort((a, b) => a.start.compareTo(b.start));
  }

  Color getColor(double value) {
    if (_rangeValues.isEmpty) {
      return widget.color!;
    }
    for (var i = _rangeValues.length - 1; i >= 0; i--) {
      final range = _rangeValues[i];
      if (value >= range.start) {
        return range.color;
      }
    }
    return widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: FractionallySizedBox(
        widthFactor: widget.value,
        child: Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: getColor(widget.value),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
