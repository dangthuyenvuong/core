import 'package:core/constants.dart';
import 'package:core/utils/modal/modal.dart';
import 'package:core/widgets/button.dart';
import 'package:core/widgets/icon_button.dart';
import 'package:core/widgets/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void changePrivacy({
  required BuildContext context,
}) {
  Modal.showBottomSheet(
    size: 0.8,
    context: context,
    builder: (context, scrollController) => _ChangePrivacyModal(),
  );
}

class _ChangePrivacyModal extends StatelessWidget {
  const _ChangePrivacyModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(Spacing.medium),
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
                  child: Padding(
                padding: EdgeInsets.only(right: 40),
                child: Text(
                  "Chọn đối tượng",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(Spacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ai có thể xem bài viết này?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: Spacing.small),
                DefaultTextStyle(
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: Spacing.small,
                      children: [
                        Text(
                          "Bài viết của bạn sẽ hiển thị trên bảng feed, trang cá nhân và trong kết quả tìm kiếm.",
                        ),
                        Text(
                          "Bạn có thể thay đổi đối tượng hiển thị sau khi đăng bài",
                        ),
                      ]),
                ),
                SizedBox(height: Spacing.medium),
                SMenu(
                  backgroundColor: Colors.transparent,
                  textStyle: TextStyle(fontSize: 16),
                  iconTheme: IconThemeData(size: 24),
                  children: [
                    SMenuItem(
                      title: Text(
                        "Công khai",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Bài viết của bạn sẽ hiển thị trên bảng feed, trang cá nhân và trong kết quả tìm kiếm.",
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: Icon(CupertinoIcons.globe),
                      checked: true,
                      onTap: () {},
                    ),
                    SMenuItem(
                      title: Text(
                        "Chỉ mình tôi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Bài viết của bạn sẽ chỉ hiển thị trên trang cá nhân của bạn.",
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: Icon(CupertinoIcons.lock),
                      checked: false,
                      onTap: () {},
                    ),
                    SMenuItem(
                      title: Text(
                        "Lên lịch",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: Spacing.small,
                        children: [
                          Text(
                            "Bài viết của bạn sẽ được hiển thị trên bảng feed, trang cá nhân và trong kết quả tìm kiếm sau một thời gian nhất định.",
                            style: TextStyle(fontSize: 14),
                          ),
                          SButton(
                            // size: SSize.small,
                            color: ButtonColor.grey,
                            child: Text(
                              "12/07/2025 10:00",
                            ),
                            onTap: () {},
                          )
                        ],
                      ),
                      icon: Icon(CupertinoIcons.calendar),
                      checked: false,
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
