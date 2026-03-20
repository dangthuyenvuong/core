import 'dart:io';

import 'package:core/controllers/user.controller.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileEditScreenSave {
  String? avatar;
  String? fullName;
  String? email;
  DateTime? birthday;
  File? avatarFile;
  Gender? gender;

  ProfileEditScreenSave({
    required this.avatar,
    this.fullName,
    this.email,
    this.birthday,
    this.avatarFile,
    this.gender,
  });
}

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    super.key,
    this.navigatorKey,
    this.avatar,
    this.fullName,
    this.email,
    this.birthday,
    this.gender,
    required this.onSave,
    this.title,
    this.editable = true,
    this.saveOnBack = true,
    this.footer,
    this.action,
    this.allowCopyEmail = true,
    this.isProtect = false,
  });
  final GlobalKey<NavigatorState>? navigatorKey;
  final String? avatar;
  final String? fullName;
  final String? email;
  final DateTime? birthday;
  final Gender? gender;
  final Function(ProfileEditScreenSave) onSave;
  final bool editable;
  final String? title;
  // final Widget? footer;
  final Widget Function(ProfileEditScreenSave data)? action;
  final bool saveOnBack;
  final Widget? footer;
  final bool allowCopyEmail;
  final bool isProtect;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  // final userController = Get.find<UserController>();
  bool isLoading = false;

  late ProfileEditScreenSave profile;

  @override
  void initState() {
    super.initState();
    profile = ProfileEditScreenSave(
      avatar: widget.avatar,
      fullName: widget.fullName,
      email: widget.email,
      birthday: widget.birthday,
      gender: widget.gender,
    );
  }

  @override
  Widget build(BuildContext context) {
    final editableFn = widget.editable ? null : () {};
    return PopScope(
      onPopInvokedWithResult: (did, result) {
        if (!widget.saveOnBack) return;
        if (!widget.editable) return;
        if (widget.avatar != profile.avatar ||
            widget.fullName != profile.fullName ||
            widget.email != profile.email ||
            widget.birthday != profile.birthday ||
            widget.gender != profile.gender ||
            profile.avatarFile != null) {
          widget.onSave(profile);
        }
      },
      child: Scaffold(
        appBar: SAppBar(
          leading: IconBack(navigatorKey: widget.navigatorKey),
          padding: EdgeInsets.only(left: 0, right: 40),
          titleCenter: true,
          title: Text(widget.title ?? "Edit profile".tr,
              textAlign: TextAlign.center),
          // actions: [IconSearch()],
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SAvatar(
                  size: 100,
                  url: widget.avatar,
                  file: profile.avatarFile,
                  fallback:
                      'assets/images/${widget.gender?.name.toString()}-avatar-default.png',
                  action: widget.editable
                      ? SIconButton(
                          bgColor: Theme.of(context).scaffoldBackgroundColor,
                          paddingX: 4,
                          paddingY: 4,
                          size: 18,
                          child: Icon(CupertinoIcons.camera),
                        )
                      : null,
                  onTap: editableFn ??
                      () {
                        pickImage(
                            context: context,
                            onUpload: (file) {
                              profile.avatarFile = file;
                              setState(() {});
                            });
                      },
                ),
                SizedBox(height: 16),
                // OpacityTap(
                //   child: Text(tr("Change avatar"),
                //       style: TextStyle(
                //         fontWeight: FontWeight.w500,
                //       )),
                //   onTap: () {
                //     showImagePicker(context: context);
                //   },
                // ),
                MenuGroup(
                  items: [
                    MenuItem(
                      // svgIcon: "assets/images/svg/user.svg",
                      // title: tr("Name"),
                      icon: Icon(Icons.person),
                      subText: profile.fullName ?? '',
                      isShowChevron: widget.editable,
                      text: "Name".tr,
                      onTap: editableFn ??
                          () {
                            Modal.inputDialog(
                                context: context,
                                label: Text("Edit name".tr),
                                required: true,
                                defaultValue: profile.fullName ?? '',
                                onConfirm: (value) {
                                  profile.fullName = value;
                                  setState(() {});
                                });
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => FormScreen(
                            //       onSave: (values) async {
                            //         // await userController.updateUser(
                            //         //   full_name: values['full_name'],
                            //         // );

                            //         return true;
                            //       },
                            //       title: tr("Edit name"),
                            //       fields: [
                            //         FieldItem(
                            //           name: 'full_name',
                            //           label: tr("Name"),
                            //           rules: [RequiredRule()],
                            //           placeholder: tr("Enter name"),
                            //           defaultValue: widget.fullName ?? '',
                            //           trailing: Opacity(
                            //             opacity: 0.5,
                            //             child: Text(
                            //               tr("Name cannot contain special characters"),
                            //             ),
                            //           ),
                            //           maxLength: 30,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // );
                          },
                      // isLink: true,
                    ),
                    if (!widget.isProtect)
                      MenuItem(
                        text: "Birthday".tr,
                        icon: Icon(CupertinoIcons.calendar),
                        subText: profile.birthday?.format('dd/MM/yyyy'),
                        onTap: editableFn ??
                            () {
                              Cupertino.showDatePicker(
                                  initialDateTime:
                                      profile.birthday ?? DateTime.now(),
                                  context: context,
                                  maximumDate: DateTime.now(),
                                  onDateTimeComplete: (value) {
                                    profile.birthday = value;
                                    setState(() {});
                                  });
                            },
                      ),
                    // SizedBox(height: 16),
                    if (profile.email != null && !widget.isProtect)
                      MenuItem(
                        // svgIcon: "assets/images/svg/identification.svg",
                        // title: tr("Account ID"),
                        icon: Icon(CupertinoIcons.at),
                        subText: profile.email,
                        // isShowChevron: true,
                        suffixIcon:
                            widget.allowCopyEmail ? Icon(Icons.copy) : null,
                        text: "Email",
                        readOnly: !widget.allowCopyEmail,
                        onTap: () {
                          if (!widget.allowCopyEmail) return;
                          Clipboard.setData(
                              ClipboardData(text: profile.email!));
                          Modal.showSnackBar(
                            context: context,
                            leading:
                                Icon(Icons.check_circle, color: Constant.green),
                            message: Text("Email has been copied".tr),
                          );
                        },
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => FormScreen(
                        //         onSave: (values) async {
                        //           // await userController.updateUser(
                        //           //   account_id: values['account_id'],
                        //           // );

                        //           // return true;
                        //         },
                        //         title: tr("Edit account ID"),
                        //         fields: [
                        //           FieldItem(
                        //             rules: [RequiredRule()],
                        //             name: 'account_id',
                        //             label: tr("Account ID"),
                        //             placeholder: tr("Enter account ID"),
                        //             defaultValue: widget.accountId ?? '',
                        //             trailing: Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 OpacityTap(
                        //                   onTap: () {
                        //                     Utils.showSnackBar(
                        //                       context: context,
                        //                       message: Text(
                        //                         tr("Account ID has been copied"),
                        //                       ),
                        //                       leading: Padding(
                        //                         padding: EdgeInsets.only(
                        //                           right: Spacing.small,
                        //                         ),
                        //                         child: SvgPicture.asset(
                        //                           'assets/images/svg/check-circle.svg',
                        //                           width: 20,
                        //                           height: 20,
                        //                           colorFilter: ColorFilter.mode(
                        //                             Constant.green,
                        //                             BlendMode.srcIn,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     );
                        //                   },
                        //                   child: Text.rich(
                        //                     style: TextStyle(),
                        //                     TextSpan(
                        //                       children: [
                        //                         TextSpan(
                        //                           text: 'https://spaceenglish.com/',
                        //                           style: TextStyle(
                        //                             color: Colors.grey,
                        //                           ),
                        //                         ),
                        //                         TextSpan(
                        //                           text: '@dangthuyenvuong ',
                        //                           style: TextStyle(
                        //                             fontWeight: FontWeight.w500,
                        //                           ),
                        //                         ),
                        //                         WidgetSpan(
                        //                           child: SvgPicture.asset(
                        //                             'assets/images/svg/copy.svg',
                        //                             width: 16,
                        //                             height: 16,
                        //                             colorFilter: ColorFilter.mode(
                        //                               Theme.of(
                        //                                 context,
                        //                               ).colorScheme.onSurface,
                        //                               BlendMode.srcIn,
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 SizedBox(height: 8),
                        //                 Text(
                        //                   tr(
                        //                     "Account ID can only include letters, numbers, underscores, and dots. When you change your Account ID, your profile link will also change.",
                        //                   ),
                        //                   style: TextStyle(color: Colors.grey),
                        //                 ),
                        //                 SizedBox(height: 8),
                        //                 Text(
                        //                   tr(
                        //                     "Each user can only change their Account ID 30 days",
                        //                   ),
                        //                   style: TextStyle(color: Colors.grey),
                        //                 ),
                        //               ],
                        //             ),
                        //             maxLength: 30,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   );
                        // },
                      ),
                    MenuItem(
                      text: "Gender".tr,
                      icon: Icon(CupertinoIcons.calendar),
                      value: profile.gender?.name.capitalizeFirst?.tr,
                      options: widget.editable
                          ? [
                              Gender.male.name.capitalizeFirst!.tr,
                              Gender.female.name.capitalizeFirst!.tr,
                            ]
                          : null,
                      // onChanged: (value) {
                      //   print(value);
                      // },
                      onSelected: (value) {
                        profile.gender = Gender.values.firstWhere(
                          (element) =>
                              element.name.capitalizeFirst!.tr == value,
                        );
                        setState(() {});
                      },
                      // onTap: () {
                      //   Cupertino.showDatePicker(
                      //       initialDateTime: profile.birthday ?? DateTime.now(),
                      //       context: context,
                      //       maximumDate: DateTime.now(),
                      //       onDateTimeComplete: (value) {
                      //         profile.birthday = value;
                      //         setState(() {});
                      //       });
                      // },
                    ),
                  ],
                ),
                if (widget.footer != null) widget.footer!,
                if (widget.action != null) widget.action!(profile)

                // MenuItem(
                //   svgIcon: "assets/images/svg/link.svg",
                //   title: "Liên kết tài khoản",
                //   subtitle: "Facebook, Google, Apple...",
                //   isLink: true,
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => _ConnectAccount(),
                //       ),
                //     );
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectAccount extends StatefulWidget {
  @override
  State<_ConnectAccount> createState() => _ConnectAccountState();
}

class _ConnectAccountState extends State<_ConnectAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SAppBar(leading: SIconBack(), title: Text("Liên kết tài khoản")),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          spacing: 8,
          children: [
            _ItemConnectAccount(
              icon: 'assets/images/svg/fb.svg',
              text: '${"Continue with".tr} Facebook',
            ),
            _ItemConnectAccount(
              icon: 'assets/images/svg/google.svg',
              text: '${"Continue with".tr} Google',
            ),
            _ItemConnectAccount(
              iconWidget: SvgPicture.asset(
                'assets/images/svg/apple.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              text: '${"Continue with".tr} Apple',
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemConnectAccount extends StatelessWidget {
  const _ItemConnectAccount({
    super.key,
    this.icon,
    required this.text,
    this.iconWidget,
  }) : assert(
          icon != null || iconWidget != null,
          'Either icon or iconWidget must be provided',
        );

  final String? icon;
  final String text;
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            // Get.offAll(() => MainScreen(),
            //     transition: Transition.rightToLeft,
            //     duration: Duration(milliseconds: 200));
          },
          child: Container(
            padding: EdgeInsets.all(12),
            child: Row(
              spacing: 8,
              children: [
                iconWidget ?? SvgPicture.asset(icon!, width: 24, height: 24),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Opacity(opacity: 0.5, child: Text("Đã kết nối")),
                Opacity(
                  opacity: 0.5,
                  child: SvgPicture.asset(
                    'assets/images/svg/chevron-right.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
