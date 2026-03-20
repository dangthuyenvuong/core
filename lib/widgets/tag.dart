import 'package:core/core.dart';
import 'package:flutter/material.dart';

class STag extends StatelessWidget {
  const STag({super.key, required this.text, this.color = Colors.blue});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Spacing.mediumSmall, vertical: Spacing.xSmall),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text,
          style: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
