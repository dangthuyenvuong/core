import 'package:core/constants.dart';
import 'package:core/utils/modal/modal.dart';
import 'package:core/widgets/icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
void changeEmoji({
  required BuildContext context,
}) {
  Modal.showBottomSheet(
    context: context,
    size: 0.8,
    builder: (context, scrollController) => _ChangeEmojiModal(),
  );
}

class _ChangeEmojiModal extends StatelessWidget {
  const _ChangeEmojiModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SIconButton(
                child: Icon(CupertinoIcons.xmark),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                  child: Text(
                "Bạn đang cảm thấy thế nào?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    "Xong",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: Spacing.small),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: Spacing.medium, vertical: Spacing.medium),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.withAlpha(50)),
                top: BorderSide(color: Colors.grey.withAlpha(50)),
              ),
            ),
            child: Text.rich(TextSpan(children: [
              TextSpan(text: "Bạn đang cảm thấy..."),
              TextSpan(
                  text: "sung sướng 😀",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ])),
          ),
          ListView.builder(
            itemCount: 10,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => Row(
              children: [
                _EmojiItem(borderRight: true),
                _EmojiItem(borderLeft: true),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _EmojiItem extends StatelessWidget {
  const _EmojiItem({
    super.key,
    this.borderRight = false,
    this.borderLeft = false,
  });
  final bool borderRight;
  final bool borderLeft;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(Spacing.small),
        decoration: BoxDecoration(
          border: Border(
            right: borderRight
                ? BorderSide(color: Colors.grey.withAlpha(50), width: 0.5)
                : BorderSide.none,
            left: borderLeft
                ? BorderSide(color: Colors.grey.withAlpha(50), width: 0.5)
                : BorderSide.none,
            bottom: BorderSide(
              color: Colors.grey.withAlpha(50),
              width: 1,
            ),
          ),
        ),
        child: Text.rich(TextSpan(children: [
          TextSpan(text: "💕", style: TextStyle(fontSize: 30)),
          TextSpan(
            text: " sung sướng",
          ),
        ])),
      ),
    );
  }
}
