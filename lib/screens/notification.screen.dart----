import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: SAppBar(
        padding: EdgeInsets.symmetric(horizontal: Spacing.medium),
        title: Text("Notification"),
        actions: [
          SIconButton(
            bgColor: onSurface.withAlpha(30),
            child: Icon(CupertinoIcons.ellipsis),
            onTap: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.medium,
                  vertical: Spacing.small,
                ),
                child: Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 16,
                    color: onSurface.withAlpha(150),
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return NotificationItem(
                    image: "https://i.pravatar.cc/300",
                    content: Text("Ngô Thanh Thanh"),
                    time: "10:00",
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    this.image,
    this.time,
    required this.content,
  });
  final String? image;
  final String? time;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.medium,
        vertical: Spacing.small,
      ),
      child: Row(
        spacing: Spacing.medium,
        children: [
          if (image != null)
            SAvatar(
              url: image!,
              size: 50,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Spacing.xSmall,
              children: [
                content,
                if (time != null)
                  Text(
                    time!,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )
              ],
            ),
          ),
          SIconButton(
            child: Icon(CupertinoIcons.ellipsis),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
