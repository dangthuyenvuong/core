import 'package:core/core.dart';
import 'package:core/utils/modal/modal.dart';
import 'package:core/widgets/button.dart';
import 'package:core/widgets/switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Application {
  String icon;
  String name;
  Function()? onTap;

  Application({required this.icon, required this.name, this.onTap});
}

class SettingItem {
  String title;
  String icon;
  String? selectValue;
  List<String>? values;
  bool? isSwitch;
  bool? isLink;
  VoidCallback? onTap;
  Widget? action;
  Color? color;

  SettingItem({
    required this.title,
    required this.icon,
    this.selectValue,
    this.values,
    this.isSwitch,
    this.isLink,
    this.onTap,
    this.action,
    this.color,
  });
}

class MenuTemplateScreen extends StatefulWidget {
  const MenuTemplateScreen({
    super.key,
    this.applications,
    this.settings,
    this.leading,
    this.trailing,
  });

  final List<Application>? applications;
  final List<SettingItem>? settings;
  final Widget? leading;
  final Widget? trailing;

  @override
  State<MenuTemplateScreen> createState() => _MenuTemplateScreenState();
}

class _MenuTemplateScreenState extends State<MenuTemplateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final descriptionColor = isDarkMode ? onSurface.withAlpha(150) : onSurface;
    final bg = getBgMode(context);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 - animationController.value * 0.05,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child!,
              if (animationController.value > 0)
                Positioned.fill(
                  top: -20,
                  child: Opacity(
                    opacity: animationController.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.primary.withAlpha(50),
                        borderRadius: BorderRadius.circular(Spacing.large),
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            if (widget.leading != null) widget.leading!,
            if (widget.applications != null)
              Column(
                children: [
                  // Row(
                  //   spacing: Spacing.small,
                  //   children: [
                  //     Text('Ứng dụng của bạn',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold,
                  //         )),
                  //     SizedBox(height: Spacing.small),
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: Spacing.small,
                  //     vertical: 2,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).colorScheme.primary,
                  //     borderRadius:
                  //         BorderRadius.circular(Spacing.small),
                  //   ),
                  //   child: Text('Đang phát triển',
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w500,
                  //       )),
                  // ),
                  //   ],
                  // ),
                  STitle(
                      titleWidget: Row(
                        children: [
                          Text(tr('Your applications')),
                          SizedBox(width: Spacing.small),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: Spacing.small,
                          //     vertical: 2,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: Theme.of(context).primaryColor,
                          //     borderRadius: BorderRadius.circular(100),
                          //   ),
                          //   child: Text(tr('Developing'),
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 12,
                          //         fontWeight: FontWeight.w500,
                          //       )),
                          // ),
                        ],
                      ),
                      subTitle: tr(
                          "Click to see detailed information about each application. Each click will be a vote for that application. Based on the number of votes, we will decide which application to prioritize for development.")),
                  // SizedBox(height: Spacing.small),
                  // Text(
                  //   "Nhấn vào để xem thông tin chi tiết về mỗi ứng dụng. Mỗi lượt nhấn sẽ là một lần vote cho ứng dụng đó. Dựa theo số lượng vote của bạn để chúng tôi quyết định ưu tiên phát triển ứng dụng nào.",
                  //   style: TextStyle(
                  //     color: descriptionColor,
                  //   ),
                  // ),
                ],
              ),
            if (widget.applications != null)
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 90,
                    mainAxisSpacing: Spacing.small,
                    crossAxisSpacing: Spacing.small,
                  ),
                  itemCount: widget.applications!.length,
                  itemBuilder: (context, index) {
                    final item = widget.applications![index];
                    return Container(
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius:
                            BorderRadius.all(Radius.circular(Spacing.medium)),
                      ),
                      child: InkWell(
                        borderRadius:
                            BorderRadius.all(Radius.circular(Spacing.medium)),
                        onTap: () {
                          if (item.onTap != null) {
                            item.onTap!();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(Spacing.medium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                item.icon,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onSurface,
                                    BlendMode.srcIn),
                              ),
                              SizedBox(height: Spacing.small),
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            if (widget.applications != null)
              Text(
                tr("If you have any features you want us to develop, please click the button below"),
                style: TextStyle(color: descriptionColor),
              ),
            if (widget.applications != null)
              SButton(
                minWidth: 150,
                color: ButtonColor.grey,
                rounded: true,
                child: Text(tr('Request feature')),
                onTap: () {
                  Get.to(() => ReportScreen(
                        title: tr('Request feature'),
                        leading: Padding(
                          padding: EdgeInsets.only(bottom: Spacing.medium),
                          child: Text(
                              tr('You can request any feature you think is necessary for this application, we will review and develop it as soon as possible.'),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(150),
                              )),
                        ),
                      ));
                },
              ),
            // if (widget.settings != null) ...[
            //   SizedBox(height: Spacing.xSmall),
            //   STitle(title: tr('Setting')),
            //   // Text('Cài đặt',
            //   //     style: TextStyle(
            //   //       fontSize: 16,
            //   //       fontWeight: FontWeight.w500,
            //   //     )),
            // ],
            if (widget.settings != null)
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.settings!.length,
                  itemBuilder: (context, index) {
                    final item = widget.settings![index];
                    return _SettingItem(
                      animationController: animationController,
                      setting: item,
                    );
                  }),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem({
    super.key,
    required this.setting,
    required this.animationController,
  });
  final AnimationController animationController;

  final SettingItem setting;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // animationController.forward();
        // await showCustomBottomSheet(context);
        // animationController.reverse();
        if (setting.onTap != null) {
          setting.onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Spacing.medium),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: Spacing.xSmall,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    setting.icon,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                        setting.color ??
                            Theme.of(context).colorScheme.onSurface,
                        BlendMode.srcIn),
                  ),
                  SizedBox(width: Spacing.small),
                  Text(setting.title,
                      style: TextStyle(
                        color: setting.color ??
                            Theme.of(context).colorScheme.onSurface,
                      )),
                ],
              ),
            ),
            if (setting.selectValue != null)
              Text(setting.selectValue!,
                  style: TextStyle(
                    height: 0.5,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(100),
                  )),
            // if (setting.selectValue != null)
            //   Row(
            //     children: [
            //       Text(setting.selectValue!,
            //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //                 color: Theme.of(context)
            //                     .colorScheme
            //                     .onSurface
            //                     .withAlpha(100),
            //               )),
            //       SizedBox(width: Spacing.small),
            //       SvgPicture.asset(
            //         'assets/images/svg/chevron-right.svg',
            //         width: 24,
            //         height: 24,
            //         colorFilter: ColorFilter.mode(
            //             Theme.of(context).colorScheme.onSurface.withAlpha(100),
            //             BlendMode.srcIn),
            //       ),
            //     ],
            //   ),
            if (setting.action != null) setting.action!,
            if (setting.isSwitch == true)
              SSwitch(
                width: 32,
                height: 18,
                // activeTrackColor: Theme.of(context).colorScheme.primary,
                value: true,
                onChanged: (value) {},
              ),
            if (setting.isLink == true)
              SvgPicture.asset(
                'assets/images/svg/chevron-right.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface.withAlpha(100),
                    BlendMode.srcIn),
              ),
          ],
        ),
      ),
    );
  }
}
