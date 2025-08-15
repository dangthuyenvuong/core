import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SRating extends StatefulWidget {
  const SRating({
    super.key,
    this.rating = 0,
    this.color,
  });
  final int rating;
  final Color? color;

  @override
  State<SRating> createState() => _SRatingState();
}

class _SRatingState extends State<SRating> {
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final _color = widget.color ?? Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
            });
          },
          child: SvgPicture.asset(
            'assets/images/svg/star${index + 1 <= _rating ? '-fill' : ''}.svg',
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
                _color.withAlpha(widget.rating != _rating ? 255 : 100),
                BlendMode.srcIn),
          ),
        );
      }),
    );
  }
}
