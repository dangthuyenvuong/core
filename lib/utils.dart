import 'dart:math';

import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Utils {
  static void modal({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    Function()? onClose,
  }) {
    showDialog(
      context: context,
      builder: builder,
    ).then((value) => onClose?.call());
  }

  static void showBottomSheet({
    required BuildContext context,
    required List<String> options,
    required Function(String, int index) onSelected,
    String? value,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            // height: 250,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32))),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 250),
              child: SingleChildScrollView(
                child: Column(
                  children: options
                          .asMap()
                          .entries
                          ?.map((entry) => ListTile(
                                title: Row(
                                  children: [
                                    Text(entry.value),
                                    Spacer(),
                                    value == entry.value
                                        ? Icon(Icons.check_circle,
                                            color: Constant.primaryColor)
                                        : SizedBox()
                                  ],
                                ),
                                onTap: () {
                                  onSelected(entry.value, entry.key);
                                  Navigator.pop(context); // Đóng BottomSheet
                                },
                              ))
                          .toList() ??
                      [],
                ),
              ),
            ),
          );
        });
  }

  static void showBottomActionSheet({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    Function()? onClose,
  }) {
    showModalBottomSheet(
      context: context,
      builder: builder,
    ).then((value) => onClose?.call());
  }

  static void showSnackBar({
    required BuildContext context,
    required Widget message,
    Widget? leading,
    // Widget? trailing,
    List<Widget> actions = const [],
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
    EdgeInsets? padding,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    VoidCallback? onTap,
    Widget? icon,
  }) {
    Get.closeCurrentSnackbar();
    Get.showSnackbar(
      GetSnackBar(
        // mainButton: IconButton(
        //   onPressed: onTap,
        //   icon: Icon(Icons.close),
        // ),
        // message: "ádfasdf",
        messageText: Row(
          children: [
            leading ?? SizedBox(),
            message,
          ],
        ),
        snackPosition: SnackPosition.BOTTOM,
        // backgroundColor: Colors.black,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
        animationDuration: kThemeAnimationDuration,
        icon: icon,
      ),
      // snackPosition: SnackPosition.BOTTOM,
      // // titleText: Text("Thông báo"),
      // messageText: message,
      // // backgroundColor: Colors.black,
      // // colorText: Colors.white,
      // borderRadius: 10,
      // margin: EdgeInsets.all(10),
      // duration: Duration(seconds: 2),
      // animationDuration: kThemeAnimationDuration,
    );

    // final scaffoldMessengerKey =
    //     Get.find<SystemController>().scaffoldMessengerKey;
    // scaffoldMessengerKey.currentState?.showSnackBar(
    //   SnackBar(content: Text('Global SnackBar nè!')),
    // );
    // scaffoldMessengerKey.currentState?.clearSnackBars();

    // final overlay =
    //     Overlay.of(context, rootOverlay: true); // 👈 lấy root overlay
    // final entry = OverlayEntry(
    //   builder: (context) => Positioned(
    //     bottom: MediaQuery.of(context).padding.top + 20,
    //     left: 20,
    //     right: 20,
    //     child: Material(
    //       color: Colors.transparent,
    //       child: Container(
    //         padding: EdgeInsets.all(16),
    //         decoration: BoxDecoration(
    //           color: Colors.black.withOpacity(0.85),
    //           borderRadius: BorderRadius.circular(8),
    //         ),
    //         child: SnackBar(
    //           padding: EdgeInsets.only(bottom: 10),
    //           elevation: 0,
    //           backgroundColor: Colors.transparent,
    //           content: DefaultTextStyle(
    //             style: TextStyle(fontSize: 14),
    //             child: GestureDetector(
    //               onTap: onTap,
    //               child: Container(
    //                 width: double.infinity,
    //                 padding: EdgeInsets.symmetric(horizontal: Spacing.medium),
    //                 child: Container(
    //                   padding: EdgeInsets.symmetric(
    //                       horizontal: Spacing.small, vertical: 12),
    //                   decoration: BoxDecoration(
    //                     color: Color(0xFF3a3a3a),
    //                     borderRadius: BorderRadius.circular(Spacing.small),
    //                   ),
    //                   child: Row(
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       leading ?? SizedBox(),
    //                       Expanded(
    //                         child: message,
    //                       ),
    //                       ...actions
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    // // Thêm vào root overlay
    // overlay.insert(entry);

    // // Auto remove sau 3s
    // Future.delayed(Duration(seconds: 2)).then((_) => entry.remove());

    // scaffoldMessengerKey.currentState?.showSnackBar(
    //   SnackBar(
    //     // behavior: SnackBarBehavior.fixed,
    //     padding: EdgeInsets.only(bottom: 10),
    //     elevation: 0,
    //     backgroundColor: Colors.transparent,
    //     content: DefaultTextStyle(
    //       style: TextStyle(fontSize: 14),
    //       child: GestureDetector(
    //         onTap: onTap,
    //         child: Container(
    //           width: double.infinity,
    //           padding: EdgeInsets.symmetric(horizontal: Spacing.medium),
    //           child: Container(
    //             padding: EdgeInsets.symmetric(
    //                 horizontal: Spacing.small, vertical: 12),
    //             decoration: BoxDecoration(
    //               color: Color(0xFF3a3a3a),
    //               borderRadius: BorderRadius.circular(Spacing.small),
    //             ),
    //             child: Row(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 leading ?? SizedBox(),
    //                 Expanded(
    //                   child: message,
    //                 ),
    //                 ...actions
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     duration: Duration(seconds: 2),
    //   ),
    // );
  }

  static void showConfirmDialog({
    required BuildContext context,
    required String message,
    Function()? onDelete,
    String? description,
    String? cancelText,
    String? okText,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(message),
              content: Text(description ?? ''),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(tr(cancelText ?? 'Cancel'))),
                TextButton(
                    onPressed: () async {
                      await onDelete?.call();
                      Navigator.pop(context);
                    },
                    child: Text(tr(okText ?? 'Confirm')))
              ],
            ));
  }

  static void showLoading({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Container(
              child: Center(child: CircularProgressIndicator()),
            ));
  }

  static void hideLoading({required BuildContext context}) {
    Navigator.pop(context);
  }

  static Future<DateTime?> showDate({
    required BuildContext context,
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: initialDatePickerMode,
    );
  }

  // static Future<T?> showMenu<T>({
  //   required BuildContext context,
  //   // required List<String> options,
  //   // required Function(String, int index) onSelected,
  //   // String? value,
  // }) async {
  //   final RenderBox button = context.findRenderObject() as RenderBox;
  //   final Offset position = button.localToGlobal(Offset.zero);
  //   // final Size size = button.size;
  //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //   // final bgColor = isDarkMode ? Colors.white : Colors.black;
  //   // final textColor = isDarkMode ? Colors.black : Colors.white;

  //   return await showDialog(
  //     useSafeArea: true,
  //     context: context,
  //     barrierColor: Colors.black.withAlpha(200),
  //     builder: (context) {
  //       return SafeArea(
  //         child: Stack(
  //           children: [
  //             Positioned(
  //               left: position.dx - 100,
  //               top: position.dy - 20,
  //               child: ClipRRect(
  //                 // borderRadius: BorderRadius.circular(20),
  //                 borderRadius: BorderRadius.circular(8),
  //                 // clipBehavior: Clip.hardEdge,
  //                 child: BackdropFilter(
  //                   filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
  //                   child: Container(
  //                     clipBehavior: Clip.hardEdge,
  //                     // width: 150,
  //                     // padding: EdgeInsets.all(8),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(8),
  //                       color: isDarkMode
  //                           ? Colors.white.withAlpha(30)
  //                           : Colors.white,
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         _MenuItem(
  //                             title: 'Tạo flashcard',
  //                             svgIcon: 'assets/images/svg/plus.svg'),
  //                         // _MenuItem(title: 'Tạo chủ đề'),
  //                         _MenuItem(
  //                           title: 'Nhập bộ sưu tập',
  //                           svgIcon: 'assets/images/svg/folder.svg',
  //                           onTap: () {
  //                             showCommingSoonModal(context);
  //                           },
  //                           border: false,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    super.key,
    this.border = true,
    required this.title,
    required this.svgIcon,
    this.onTap,
  });

  final String title;
  final bool border;
  final String svgIcon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.black.withAlpha(50),
        child: Container(
          padding: EdgeInsets.all(Spacing.small),
          decoration: BoxDecoration(
              border: border
                  ? Border(bottom: BorderSide(color: textColor.withAlpha(20)))
                  : null),
          child: Row(
            children: [
              SvgPicture.asset(
                svgIcon,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
              ),
              SizedBox(width: Spacing.small),
              Text(title, style: TextStyle(color: textColor))
            ],
          ),
        ),
      ),
    );
  }
}

T getRandomEnum<T>(List<T> values) {
  final random = Random();

  if (values.length == 1) {
    return values.first;
  }
  return values[random.nextInt(values.length - 1)];
}

void notiCopyToClipboard({
  required BuildContext context,
  required String text,
}) {
  Utils.showSnackBar(
    context: context,
    message: Text(text),
    leading: Padding(
      padding: EdgeInsets.only(right: Spacing.small),
      child: SvgPicture.asset(
        'assets/images/svg/check-circle.svg',
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          Constant.green,
          BlendMode.srcIn,
        ),
      ),
    ),
  );
}
