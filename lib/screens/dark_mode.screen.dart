import 'package:core/core.dart';
import 'package:core/widgets/switch.dart';
import 'package:flutter/material.dart';

class ScreenDarkMode extends StatefulWidget {
  const ScreenDarkMode({
    super.key,
    // required this.onChanged,
    // required this.isLight,
    // required this.isAuto,
    // required this.onAutoChanged,
    required this.imgDark,
    required this.imgLight,
  });
  // final bool isAuto;
  // final bool isLight;
  // final Function(ThemeMode) onChanged;
  // final Function(bool) onAutoChanged;
  final Widget imgDark;
  final Widget imgLight;

  @override
  State<ScreenDarkMode> createState() => _ScreenDarkModeState();
}

class _ScreenDarkModeState extends State<ScreenDarkMode> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final systemController = Get.find<SystemController>();
    return Scaffold(
      appBar: SAppBar(
        padding: EdgeInsets.only(right: 40),
        leading: SIconBack(),
        title: Text("Light/Dark Mode".tr, textAlign: TextAlign.center),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Spacing.medium, horizontal: Spacing.medium),
        child: Obx(() {
          final isAuto = systemController.themeMode == ThemeMode.system;
          return Column(
            children: [
              SizedBox(height: Spacing.medium),
              Row(
                spacing: 32,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _OptionItem(
                    title: 'Light'.tr,
                    image: widget.imgLight,
                    isChecked: !isDark,
                    onTap: () {
                      systemController.updateThemeMode(ThemeMode.light);
                    },
                  ),
                  _OptionItem(
                    title: 'Dark'.tr,
                    image: widget.imgDark,
                    isChecked: isDark,
                    onTap: () {
                      systemController.updateThemeMode(ThemeMode.dark);
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
                          "Use device settings".tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SSwitch(
                          value: isAuto,
                          onChanged: (value) {
                            systemController.updateThemeMode(ThemeMode.system);
                          },
                        )
                      ],
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Text(
                          "Set the interface to automatically match the device settings."
                              .tr),
                    )
                  ],
                ),
              ),
              // SRadio(checked: true, text: 'Auto'),
              // SRadio(checked: false, text: 'Light'),
              // SRadio(checked: false, text: 'Dark'),
            ],
          );
        }),
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
  final Widget image;
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
            child: image,
          ),
          Text(title),
          SRadio(checked: isChecked),
        ],
      ),
    );
  }
}
