import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class Empty extends StatelessWidget {
  const Empty(
      {super.key, this.icon, this.title, this.description, this.action});
  final Widget? icon;
  final String? title;
  final String? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: Spacing.small,
      children: [
        if (icon != null) icon!,
        if (title != null)
          Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        if (description != null)
          Opacity(
            opacity: 0.5,
            child: Text(description!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                )),
          ),
        if (action != null)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.small),
            child: action!,
          )
      ],
    );
  }
}
