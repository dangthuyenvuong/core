import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.medium,
        children: [
          SButton(
            color: ButtonColor.secondary,
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.small,
              vertical: Spacing.xSmall,
            ),
            size: SSize.small,
            onTap: () {},
            child: Row(
              spacing: Spacing.small,
              children: [
                Text(
                  "Phù hợp nhất",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: onSurface),
                ),
                Icon(
                  CupertinoIcons.chevron_down,
                  size: 12,
                ),
              ],
            ),
          ),
          _CommentItem(),
          _CommentItem(),
          _CommentItem(),
          _CommentItem(),
          _CommentItem(),
          _CommentItem(),
          _CommentItem(),
          _CommentItem(),
          _CommentItem(),
          _CommentItem(),
          _CommentItem(),
          _CommentItem(),
        ],
      ),
    );
  }
}

class _CommentItem extends StatefulWidget {
  const _CommentItem({
    super.key,
  });

  @override
  State<_CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<_CommentItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Spacing.small,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SAvatar(
          url: 'https://i.pravatar.cc/150?img=1',
          size: 30,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: Spacing.small,
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      "Nguyễn Văn A",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      "10 giờ",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              Text(
                "Nội dung comment",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: Spacing.xSmall),
              Row(
                children: [
                  Transform.translate(
                    offset: Offset(-Spacing.small, 0),
                    child: SButton(
                      size: SSize.small,
                      color: ButtonColor.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.small,
                        vertical: Spacing.xSmall,
                      ),
                      onTap: () {},
                      child: Opacity(
                        opacity: 0.5,
                        child: Text(
                          "Thích",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-Spacing.small, 0),
                    child: SButton(
                      size: SSize.small,
                      color: ButtonColor.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.small,
                        vertical: Spacing.xSmall,
                      ),
                      onTap: () {},
                      child: Opacity(
                        opacity: 0.5,
                        child: Text(
                          "Trả lời",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    "assets/images/svg/hand-thumb-up-fill.svg",
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                  ),
                  // Icon(
                  //   CupertinoIcons.hand_thumbsup,
                  //   size: 16,
                  //   color: Colors.blue,
                    
                  // ),
                ],
              ),
              if (isExpanded)
                Container(
                  padding: EdgeInsets.symmetric(
                    // horizontal: Spacing.small,
                    vertical: Spacing.medium,
                  ),
                  child: Column(
                    spacing: Spacing.medium,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CommentItem(),
                      _CommentItem(),
                      _CommentItem(),
                      _CommentItem(),
                    ],
                  ),
                ),
              if (!isExpanded)
                Transform.translate(
                  offset: Offset(-Spacing.medium, 0),
                  child: SButton(
                    size: SSize.small,
                    color: ButtonColor.transparent,
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Opacity(
                      opacity: 0.5,
                      child: Text(
                        "Xem 4 phản hồi...",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
