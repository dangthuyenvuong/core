import 'package:core/controllers/user.controller.dart';
import 'package:core/core.dart';
import 'package:core/screens/profile_edit_screen.dart';
import 'package:core/screens/upgrade_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final List<LangOpt> _languages = [
  LangOpt(code: 'vi', title: 'Tiếng Việt'),
  LangOpt(code: 'en', title: 'English'),
  LangOpt(code: 'ja', title: 'Japanese'),
  LangOpt(code: 'ko', title: 'Korean'),
  LangOpt(code: 'th', title: 'Thailand'),
  LangOpt(code: 'zh', title: 'Chinese'),
  LangOpt(code: 'fr', title: 'French'),
  LangOpt(code: 'de', title: 'German'),
  LangOpt(code: 'it', title: 'Italian'),
  LangOpt(code: 'es', title: 'Spanish'),
  LangOpt(code: 'ru', title: 'Russian'),
  LangOpt(code: 'nl', title: 'Dutch'),
  LangOpt(code: 'id', title: 'Indonesian'),
  LangOpt(code: 'ms', title: 'Malay'),
];

final Map<ThemeMode, String> _themeModes = {
  ThemeMode.light: 'Light',
  ThemeMode.dark: 'Dark',
  ThemeMode.system: 'System',
};

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key, this.navigatorKey});
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  late ThemeMode _themeMode;
  final systemController = Get.find<SystemController>();
  final userController = Get.find<UserController>();

  int streakDays = 0;
  // int vocabularyNotebook = 0;
  int superVocabulary = 0;
  int learningTime = 0;
  int highestStreakDays = 0;

  @override
  void initState() {
    super.initState();
    _themeMode = systemController.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    final List<Application> _applications = [
      Application(
        icon: 'assets/images/svg/microphone.svg',
        name: 'Podcast',
        onTap: () {},
      ),
      Application(
        icon: 'assets/images/svg/user-group.svg',
        name: 'Community'.tr,
        onTap: () {},
      ),
      Application(
        icon: 'assets/images/svg/newspaper.svg',
        name: 'News'.tr,
        onTap: () {},
      ),
      Application(
        icon: 'assets/images/svg/device-gamepad.svg',
        name: 'Game'.tr,
        onTap: () {},
      ),
      Application(
        icon: 'assets/images/svg/chat-bubble-oval-left-ellipsis.svg',
        name: 'Chat with stranger'.tr,
        onTap: () {},
      ),
      Application(
        icon: 'assets/images/svg/question-mark-circle.svg',
        name: 'Test IELTS, TOEIC'.tr,
        onTap: () {},
      ),
    ];

    final List<SettingItem> _settings = [
      SettingItem(
        title: 'Application language'.tr,
        icon: 'assets/images/svg/language.svg',
        isLink: true,
        selectValue: 'Tiếng Việt',
        onTap: () {
          // Get.to(
          //   () => ScreenSelectLanguage(),
          //   // fullscreenDialog: true,
          //   transition: Transition.cupertino,
          //   // curve: Curves.easeInOut
          // );
          Get.to(
            () => ScreenSelectLanguage(
              languages: _languages,
              defaultLanguage: 'vi',
            ),
          );
        },
      ),
      SettingItem(
        title: "Light/Dark Mode".tr,
        icon: 'assets/images/svg/moon.svg',
        isLink: true,
        selectValue: _themeModes[_themeMode],
        onTap: () {
          Get.to(
            () => _ScreenDarkMode(
              onChanged: (value) {
                setState(() {
                  _themeMode = value;
                });
              },
            ),
          );
        },
      ),
      // SettingItem(
      //   title: 'Học tập',
      //   icon: 'assets/images/svg/speaker.svg',
      //   isLink: true,
      // ),
      // SettingItem(
      //   title: tr('Notification'),
      //   icon: 'assets/images/svg/bell.svg',
      //   isLink: true,
      //   selectValue: 'Tắt',
      //   onTap: () {
      //     Get.to(() => SettingNotificationScreen());
      //   },
      // ),
      SettingItem(
        title: "Feedback and bug reporting".tr,
        icon: 'assets/images/svg/question-mark-circle.svg',
        isLink: true,
        action: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Center(
            child: Text(
              '3',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        onTap: () {
          Get.to(() => ReportListScreen());
          // Get.to(
          //   () => ReportScreen(
          //     leading: Padding(
          //       padding: EdgeInsets.only(bottom: Spacing.medium),
          //       child: Text(
          //           'Cám ơn bạn đã dành thời gian để góp ý và báo lỗi cho chúng tôi. Chúng tôi sẽ xem xét và chỉnh sửa trong thời gian sớm nhất.',
          //           style: TextStyle(
          //             color: Theme.of(context)
          //                 .colorScheme
          //                 .onSurface
          //                 .withAlpha(150),
          //           )),
          //     ),
          //   ),
          // );
        },
      ),
      SettingItem(
        title: 'Delete account'.tr,
        icon: 'assets/images/svg/x.svg',
        isLink: true,
        color: Colors.red,
        onTap: () {
          Modal.confirm(
            context: context,
            title: 'Delete account'.tr,
            message:
                "Your account will be deleted after 30 days of inactivity. During this period, you can log in again to activate your account."
                    .tr,
          );
        },
      ),
      SettingItem(
        title: "Delete data".tr,
        icon: 'assets/images/svg/x.svg',
        isLink: true,
        color: Colors.red,
        onTap: () {
          Modal.confirm(
            context: context,
            title: 'Delete account'.tr,
            onConfirm: () {
              StorageService.clear();
            },
            message:
                "Your account will be deleted after 30 days of inactivity. During this period, you can log in again to activate your account."
                    .tr,
          );
        },
      ),
      SettingItem(
        title: "Logout".tr,
        icon: 'assets/images/svg/logout.svg',
        isLink: true,
        color: Colors.red,
        onTap: () {
          Cupertino.showAlertDialog(
              context: context,
              title: Text("Logout".tr),
              content: Text("Are you sure you want to logout?".tr),
              actions: [
                CupertinoDialogAction(
                  child: Text("Logout".tr),
                  isDestructiveAction: true,
                  onPressed: () {
                    // Get.find<AuthController>().logout();
                  },
                ),
                CupertinoDialogAction(
                  child: Text("Cancel".tr),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ]);
          // Get.find<AuthController>().logout();
        },
      ),
    ];

    final primaryColor = Theme.of(context).primaryColor;
    final isDarkMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bg = getBgMode(context);
    return Scaffold(
      appBar: SAppBar(
        title: Text('Profile'.tr),
        // actions: [
        //   SIconButton(
        //     onTap: () {
        //       widget.navigatorKey.currentState?.push(
        //           MaterialPageRoute(builder: (context) => MenuScreen()));
        //     },
        //     svgPath: 'assets/images/svg/cog-6-tooth.svg',
        //   ),
        //   // IconPlus(),
        //   // IconSearch()
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Spacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: Spacing.medium,
                  children: [
                    SAvatar(
                      url: 'https://i.pravatar.cc/300',
                      fallback: 'assets/images/default-avatar.png',
                      size: 80,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userController.user?.full_name ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          OpacityTap(
                            onTap: () {
                              Utils.showSnackBar(
                                context: context,
                                message: Text('Account ID copied'.tr),
                                leading: Padding(
                                  padding: EdgeInsets.only(
                                    right: Spacing.small,
                                  ),
                                  child: Icon(
                                    Icons.copy,
                                    color: Constant.green,
                                    size: 16,
                                  ),
                                  // child: SvgPicture.asset(
                                  //   'assets/images/svg/check-circle.svg',
                                  //   width: 20,
                                  //   height: 20,
                                  //   colorFilter: ColorFilter.mode(
                                  //     Constant.green,
                                  //     BlendMode.srcIn,
                                  //   ),
                                  // ),
                                ),
                              );
                            },
                            child: Opacity(
                              opacity: 0.5,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '@${userController.user?.account_id} ',
                                    ),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.copy,
                                        color: onSurface,
                                        size: 16,
                                      ),
                                      // child: SvgPicture.asset(
                                      //   'assets/images/svg/copy.svg',
                                      //   width: 16,
                                      //   height: 16,
                                      //   colorFilter: ColorFilter.mode(
                                      //     onSurface,
                                      //     BlendMode.srcIn,
                                      //   ),
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Spacing.medium),
                          Row(
                            spacing: Spacing.small,
                            children: [
                              Opacity(opacity: 0.5, child: Text('Free'.tr)),
                              SButton(
                                rounded: true,
                                bgGradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.deepPurpleAccent,
                                    Colors.purple,
                                    // Color(0xFF0228B22),
                                    // Constant.green,
                                    // Color(0xFF008080)
                                  ],
                                ),
                                size: SSize.small,
                                child: Row(
                                  spacing: Spacing.xSmall,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/svg/sparkles.svg',
                                      width: 16,
                                      height: 16,
                                      colorFilter: ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Text('Upgrade PRO'.tr),
                                  ],
                                ),
                                onTap: () {
                                  Get.to(
                                    () => UpgradeScreen(),
                                    transition: Transition.upToDown,
                                    fullscreenDialog: true,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Spacing.medium),
              Row(
                spacing: Spacing.small,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SButton(
                    color: ButtonColor.grey,
                    minWidth: 100,
                    child: Text(
                      'Edit profile'.tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      // widget.navigatorKey.currentState?.push(
                      //   MaterialPageRoute(
                      //     builder: (context) => ProfileEditScreen(
                      //       navigatorKey: widget.navigatorKey,
                      //     ),
                      //   ),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(
                            onSave: (data) {},
                            // navigatorKey: widget.navigatorKey,
                          ),
                        ),
                      );
                    },
                  ),
                  // SButton(
                  //   color: ButtonColor.transparent,
                  //   child: Row(
                  //     spacing: Spacing.xSmall,
                  //     children: [
                  //       Text(tr('Logout'),
                  //           style: TextStyle(
                  //               // color: Constant.red,
                  //               )),
                  //       SvgPicture.asset(
                  //         'assets/images/svg/arrow-right-start-on-rectangle.svg',
                  //         width: 16,
                  //         height: 16,
                  //         colorFilter: ColorFilter.mode(
                  //           onSurface,
                  //           BlendMode.srcIn,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  //   onTap: () {
                  //     Modal.confirm(
                  //         context: context,
                  //         title: "Are you sure?",
                  //         message:
                  //             "You need to login to save your learning information, if you exit, you will not be able to use the application",
                  //         onConfirm: () {
                  //           Get.find<AuthController>().logout();
                  //           Get.offAll(() => LoginScreen(),
                  //               transition: Transition.cupertino,
                  //               duration: Duration(milliseconds: 1000));
                  //         });

                  //     // widget.navigatorKey.currentState?.push(
                  //     //     MaterialPageRoute(
                  //     //         builder: (context) => ProfileEditScreen()));
                  //   },
                  // ),
                  // SButton(
                  //   color: ButtonColor.grey,
                  //   minWidth: 100,
                  //   child: Text('Chia sẻ hồ sơ'),
                  //   onTap: () {},
                  // ),
                ],
              ),
              SizedBox(height: Spacing.large),
              MenuTemplateScreen(
                applications: _applications,
                settings: _settings,
              ),

              // SizedBox(height: Spacing.large),
              // SizedBox(height: Spacing.medium),
              // Calendar(
              //   isShowFull: true,
              //   title: Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.only(bottom: Spacing.medium),
              //     child: Text("Streak history",
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //         )),
              //   ),
              // ),
              SizedBox(height: Spacing.large),
              // STitle(title: tr("Setting")),
              // SizedBox(height: Spacing.medium),
              // ListFolder(),
              // SettingScreen(),
              // SizedBox(height: Spacing.xSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreenDarkMode extends StatefulWidget {
  const _ScreenDarkMode({super.key, this.onChanged});
  final Function(ThemeMode)? onChanged;

  @override
  State<_ScreenDarkMode> createState() => _ScreenDarkModeState();
}

class _ScreenDarkModeState extends State<_ScreenDarkMode> {
  final systemController = Get.find<SystemController>();
  bool isAuto = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isAuto = systemController.themeMode == ThemeMode.system;
    });
  }

  @override
  Widget build(BuildContext context) {
    final systemController = Get.find<SystemController>();

    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container();
    // return ScreenDarkMode(
    //   onChanged: (value) {
    //     setState(() {
    //       isAuto = false;
    //     });
    //     final systemController = Get.find<SystemController>();
    //     systemController.updateThemeMode(value);
    //     widget.onChanged?.call(value);
    //   },
    //   isLight: isLight,
    //   onAutoChanged: (value) async {
    //     final systemController = Get.find<SystemController>();
    //     if (value) {
    //       systemController.updateThemeMode(ThemeMode.system);
    //       widget.onChanged?.call(ThemeMode.system);
    //     } else {
    //       final brightness = MediaQuery.of(context).platformBrightness;
    //       final isDarkMode = brightness == Brightness.dark;

    //       final themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    //       systemController.updateThemeMode(themeMode);
    //       widget.onChanged?.call(themeMode);
    //     }
    //     setState(() {
    //       isAuto = value;
    //     });
    //   },
    //   isAuto: isAuto,
    // );
  }
}
