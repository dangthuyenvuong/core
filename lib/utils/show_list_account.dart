import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showListAccount<T>({
  required BuildContext context,
  // required List<AccountItem> accounts,
  required List<T> items,
  // required Function() onLogout,
  required Function() onAddAccount,
  required Widget Function(T account) buildItem,
}) {
  Modal.showBottomSheet(
    context: context,
    initialSize: 0.5,
    draggableScrollable: true,
    builder: (context, scrollController) => _ListAccount<T>(
      // accounts: accounts,
      items: items,
      onAddAccount: onAddAccount,
      buildItem: buildItem,
    ),
  );
}

class AccountItem {
  final String name;
  final String avatar;
  final bool isSelected;
  AccountItem({
    required this.name,
    required this.avatar,
    this.isSelected = false,
  });
}

class _ListAccount<T> extends StatelessWidget {
  _ListAccount(
      {required this.onAddAccount,
      required this.buildItem,
      required this.items});
  final Function() onAddAccount;
  final List<T> items;
  final Widget Function(T account) buildItem;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      spacing: Spacing.small,
      children: [
        ...items.map((e) => buildItem(e)),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            onAddAccount();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.medium,
              vertical: Spacing.small,
            ),
            child: Row(
              spacing: Spacing.mediumSmall,
              children: [
                SIconButton(
                  bgColor: onSurface.withAlpha(30),
                  // svgPath: 'assets/images/svg/plus.svg',
                  child: Icon(
                    CupertinoIcons.plus,
                    color: onSurface.withAlpha(100),
                  ),
                  // onTap: () {},
                ),
                Expanded(
                  child: Text(
                    "Add account".tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(Spacing.medium),
        //   child: SButton(
        //     width: double.infinity,
        //     rounded: true,
        //     color: ButtonColor.red,
        //     child: Text('Đăng xuất khỏi tất cả tài khoản'),
        //     onTap: () {
        //       Navigator.of(context).pop();
        //       Get.find<AuthController>().logout();
        //       onLogout();
        //     },
        //   ),
        // )
      ],
    );
  }
}
