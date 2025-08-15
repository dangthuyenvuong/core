import 'package:core/core.dart';
import 'package:core/widgets/switch.dart';
import 'package:flutter/material.dart';

class ScreenDarkMode extends StatefulWidget {
  const ScreenDarkMode({
    super.key,
    required this.onChanged,
    required this.isLight,
    required this.isAuto,
    required this.onAutoChanged,
  });
  final bool isAuto;
  final bool isLight;
  final Function(ThemeMode) onChanged;
  final Function(bool) onAutoChanged;

  @override
  State<ScreenDarkMode> createState() => _ScreenDarkModeState();
}

class _ScreenDarkModeState extends State<ScreenDarkMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SAppBar(
        padding: EdgeInsets.only(right: 40),
        leading: SIconBack(),
        title: Text('Chế độ sáng/tối', textAlign: TextAlign.center),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Spacing.medium, horizontal: Spacing.medium),
        child: Column(
          children: [
            SizedBox(height: Spacing.medium),
            Row(
              spacing: 32,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _OptionItem(
                  title: 'Sáng',
                  image: 'assets/images/temp/screen-light.png',
                  isChecked: widget.isLight,
                  onTap: () {
                    widget.onChanged(ThemeMode.light);
                  },
                ),
                _OptionItem(
                  title: 'Tối',
                  image: 'assets/images/temp/screen-dark.png',
                  isChecked: !widget.isLight,
                  onTap: () {
                    widget.onChanged(ThemeMode.dark);
                  },
                ),
              ],
            ),
            SizedBox(height: Spacing.large),
            Container(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sử dụng cài đặt của thiết bị",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SSwitch(
                        value: widget.isAuto,
                        onChanged: (value) {
                          widget.onAutoChanged(value);
                        },
                      )
                    ],
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                        "Cài đặt giao diện phù hợp với thiết bị một cách tự động."),
                  )
                ],
              ),
            ),
            // SRadio(checked: true, text: 'Auto'),
            // SRadio(checked: false, text: 'Light'),
            // SRadio(checked: false, text: 'Dark'),
          ],
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  const _OptionItem({
    super.key,
    required this.title,
    required this.image,
    required this.isChecked,
    required this.onTap,
  });

  final String title;
  final String image;
  final bool isChecked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        spacing: 12,
        children: [
          Container(
            // padding: EdgeInsets.all(4),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spacing.small),
              // border: Border.all(
              //   color: Constant.red,
              // ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface,
                  // blurRadius: 10,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: Image.asset(
              image,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Text(title),
          SRadio(checked: isChecked),
        ],
      ),
    );
  }
}
