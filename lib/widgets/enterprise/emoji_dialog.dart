import 'package:core/constants.dart';
import 'package:core/widgets/icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmojiDialog extends StatelessWidget {
  const EmojiDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: Spacing.small),
        decoration: BoxDecoration(
          color: onSurface.withAlpha(20),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          spacing: Spacing.small,
          children: [
            _Emoji(emoji: "❤️"),
            _Emoji(emoji: "😆"),
            _Emoji(emoji: "😲"),
            _Emoji(emoji: "😢"),
            _Emoji(emoji: "😡"),
            _Emoji(emoji: "👍"),
            // SIconButton(
            //   bgColor: onSurface.withAlpha(20),
            //   child: Icon(Icons.add, size: 20),
            //   onTap: () {},
            // )
            // Container(
            //   width: 35,
            //   height: 35,
            //   decoration: BoxDecoration(
            //     color: onSurface.withAlpha(20),
            //     borderRadius: BorderRadius.circular(999),
            //   ),
            //   child: Icon(Icons.add, size: 20),
            // )
          ],
        ));
  }
}

class _Emoji extends StatelessWidget {
  const _Emoji({super.key, required this.emoji});
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Text(emoji, style: TextStyle(fontSize: 35));
  }
}
