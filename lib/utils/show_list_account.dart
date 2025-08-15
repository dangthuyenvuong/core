import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showListAccount({
  required BuildContext context,
  required List<AccountItem> accounts,
  required Function() onLogout,
}) {
  Modal.showBottomSheet(
    context: context,
    builder: (context, scrollController) => _ListAccount(
      accounts: accounts,
      onLogout: onLogout,
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

class _ListAccount extends StatelessWidget {
  final List<AccountItem> accounts;
  final Function() onLogout;
  _ListAccount({required this.accounts, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;
    return Column(
      children: [
        ...accounts.map((account) => Container(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.medium,
                vertical: Spacing.small,
              ),
              child: Row(
                spacing: Spacing.small,
                children: [
                  SAvatar(
                    url: account.avatar,
                    size: 40,
                  ),
                  Expanded(
                    child: Text(
                      account.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (account.isSelected)
                    SRadio(
                      checked: true,
                      color: Colors.white,
                    )
                ],
              ),
            )),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.medium,
            vertical: Spacing.small,
          ),
          child: Row(
            spacing: Spacing.small,
            children: [
              SIconButton(
                bgColor: isDarkMode
                    ? Colors.white.withAlpha(50)
                    : Colors.black.withAlpha(50),
                svgPath: 'assets/images/svg/plus.svg',
                onTap: () {},
              ),
              Expanded(
                child: Text(
                  "Thêm tài khoản",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Spacing.medium),
          child: SButton(
            width: double.infinity,
            rounded: true,
            color: ButtonColor.red,
            child: Text('Đăng xuất khỏi tất cả tài khoản'),
            onTap: () {
              Navigator.of(context).pop();
              Get.find<AuthController>().logout();
              onLogout();
            },
          ),
        )
      ],
    );
  }
}
