import 'dart:ui';

import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
// import 'package:get/get.dart';

part "snackbar.dart";
part "select.dart";

class WarningOption {
  Widget child;
  Function() onTap;

  WarningOption({
    required this.child,
    required this.onTap,
  });
}

enum ButtonActionColor { blue, red, grey }

const _ACTION_COLORS = {
  ButtonActionColor.red: Colors.red,
  ButtonActionColor.blue: Colors.blue,
  ButtonActionColor.grey: Colors.grey,
};

class ButtonAction {
  String title;
  Function() onTap;
  ButtonActionColor color;

  ButtonAction(
      {required this.title,
      required this.onTap,
      this.color = ButtonActionColor.blue});
}

class _Modal {
  pop(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }

  Future<T?> dialog<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    barrierDismissible = true,
  }) async {
    return await showCupertinoDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: true,
      requestFocus: true,
      builder: (context) => GestureDetector(
        onTap: () {
          if (barrierDismissible) {
            Navigator.pop(context);
          }
        },
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Center(child: builder(context))),
        ),
      ),
    );
  }

  Future<void> inputDialog(
      {required BuildContext context,
      required Function(String) onConfirm,
      Widget? label,
      String? hintText,
      String? description,
      Widget? suffix,
      String? defaultValue,
      TextInputType? keyboardType,
      int? minLines,
      int? maxLines,
      bool multiline = false,
      bool required = false,
      int? maxLength,
      String? confirmText,
      List<TextInputFormatter> inputFormatters = const []}) async {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final controller = InputController(value: defaultValue);
    return dialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              bool disabled =
                  required ? (controller.text.trim().isEmpty) : false;

              return DialogWraper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: Spacing.small,
                  children: [
                    if (label != null)
                      DefaultTextStyle(
                          style: TextStyle(
                              color: onSurface,
                              fontSize: 20,
                              letterSpacing: -1,
                              fontWeight: FontWeight.bold),
                          child: label),
                    if (description != null)
                      DefaultTextStyle(
                          style: TextStyle(
                              color: onSurface.withAlpha(150),
                              fontWeight: FontWeight.w500),
                          child: Text(description)),
                    SizedBox(height: Spacing.medium),
                    SInput(
                      autofocus: true,
                      controller: controller,
                      keyboardType: keyboardType,
                      minLine: minLines,
                      maxLine: maxLines,
                      maxLength: maxLength,
                      multiline: multiline,
                      hintText: hintText,
                      suffix: suffix,
                      // minLines: minLines,
                      // maxLines: maxLines,
                      inputFormatters: inputFormatters,
                      showError: false,
                      onChanged: (value) {
                        setState(() {
                          disabled = value.trim().isEmpty;
                        });
                      },
                      clearable: true,
                      // decoration: InputDecoration(
                      //   hintText: hintText,
                      //   hintStyle: TextStyle(color: onSurface.withAlpha(100)),
                      //   enabledBorder: UnderlineInputBorder(
                      //     borderSide: BorderSide(
                      //       color: onSurface.withAlpha(50),
                      //     ),
                      //   ),
                      //   suffix: suffix,
                      // ),
                    ),
                    if (maxLength != null)
                      SizedBox(
                          width: double.infinity,
                          child: Text(
                            "${controller.value.length}/${maxLength}",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: onSurface.withAlpha(150)),
                          )),
                    SizedBox(height: Spacing.medium),
                    Row(
                      spacing: Spacing.small,
                      children: [
                        Expanded(
                          child: SButton(
                            color: ButtonColor.grey,
                            rounded: true,
                            child: Text(tr("Cancel")),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: SButton(
                            color: ButtonColor.red,
                            rounded: true,
                            disabled: disabled,
                            child: Text(confirmText ?? tr("Confirm")),
                            onTap: () {
                              Navigator.pop(context);
                              onConfirm(controller.text);
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }));
  }

  Future<T?> showBottomSheet<T>({
    required BuildContext context,
    Widget Function(BuildContext, ScrollController?)? builder,
    Widget? leading,
    // double? size,
    double? initialSize,
    double? maxSize,
    double? minSize,
    String? title,
    bool draggableScrollable = false,
    bool feedback = true,
    bool dismissible = true,
    final Color? bgColor,
  }) async {
    if (feedback) {
      HapticFeedback.mediumImpact();
    }
    // assert(builder != null || (children != null && children!.isNotEmpty));
    return await showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true, // Cho phép kiểm soát chiều cao
      barrierColor: Colors.black.withAlpha(100),
      backgroundColor: Colors.transparent, // Đặt nền trong suốt
      useSafeArea: true,
      isDismissible: dismissible,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: double.infinity,
      ),

      builder: (context) {
        final onSurface = Theme.of(context).colorScheme.onSurface;
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: DefaultTextStyle(
            style: TextStyle(color: onSurface),
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: draggableScrollable
                  ? DraggableScrollableSheet(
                      expand: false,
                      // controller: controller,
                      initialChildSize: initialSize ?? 0.5,
                      minChildSize: minSize ?? 0.3, // Kích thước nhỏ nhất (30%)
                      maxChildSize: maxSize ?? 1, // Kích thước lớn nhất (90%)
                      snap: true,
                      builder: (context, scrollController) {
                        return _BottomSheetWraper(
                            bgColor: bgColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Top(),
                                if (title != null) _Title(title),
                                if (leading != null) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.medium,
                                        vertical: 8),
                                    child: leading,
                                  ),
                                  // SizedBox(height: 4),
                                  Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withAlpha(50),
                                  ),
                                  SizedBox(height: 8),
                                ],
                                Expanded(
                                  child: SizedBox(
                                      width: double.infinity,
                                      child:
                                          builder!(context, scrollController)),
                                )
                              ],
                            ));
                      },
                    )
                  : _BottomSheetWraper(
                      bgColor: bgColor,
                      child: SafeArea(
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Top(),
                              if (title != null) _Title(title),
                              if (leading != null) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Spacing.medium, vertical: 8),
                                  child: leading,
                                ),
                                // SizedBox(height: 4),
                                Divider(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withAlpha(50),
                                ),
                                SizedBox(height: 8),
                              ],
                              Expanded(
                                child: SizedBox(
                                    width: double.infinity,
                                    child: builder!(context, null)),
                              )
                            ],
                          ),
                        ),
                      )),
            ),
          ),
        );
      },
    );
  }

  void popup(BuildContext context, Widget Function(BuildContext) builder) {
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) => builder(context),
    );
  }

  void confirm({
    required BuildContext context,
    required String title,
    required String message,
    List<ButtonAction>? actions,
    double width = 300,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    Function? onConfirm,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final descriptionColor = isDarkMode ? onSurface.withAlpha(150) : onSurface;

    showDialog(
      useRootNavigator: true,
      context: context,
      barrierColor: Colors.black.withAlpha(100),
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              clipBehavior: Clip.hardEdge,
              width: width,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(Spacing.medium),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.medium,
                      vertical: Spacing.medium,
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Row(children: [
                    if (actions != null)
                      ...actions!.map((btn) {
                        return _ButtonAction(
                          text: Text(btn.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _ACTION_COLORS[btn.color],
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          onTap: btn.onTap,
                        );
                      }),
                    Expanded(
                      child: _ButtonAction(
                        rightBorder: true,
                        text: Text(tr(cancelText),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: _ButtonAction(
                        text: Text(tr(confirmText),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )),
                        onTap: () {
                          Navigator.pop(context);
                          onConfirm?.call();
                        },
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void show({
    required BuildContext context,
    double? width,
    EdgeInsetsGeometry padding = const EdgeInsets.all(Spacing.medium),
    required Widget child,
    barrierDismissible = true,
  }) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).bottomNavigationBarTheme.backgroundColor;

    showCupertinoModalPopup(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
        tileMode: TileMode.mirror,
      ),
      barrierDismissible: barrierDismissible,
      useRootNavigator: true,
      context: context,
      barrierColor: Colors.black.withAlpha(100),
      builder: (context) {
        return GestureDetector(
          onTap: () {
            if (barrierDismissible) {
              Navigator.pop(context);
            }
          },
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {},
              child: Center(
                child: Padding(
                  padding: padding,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: width,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(Spacing.medium),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Spacing.medium,
                              vertical: Spacing.medium,
                            ),
                            child: child),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showWarning({
    required BuildContext context,
    required String title,
    required String message,
    double width = 300,
    String confirmText = 'Confirm',
    Function? onConfirm,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      useRootNavigator: true,
      context: context,
      barrierColor: Colors.black.withAlpha(100),
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              clipBehavior: Clip.hardEdge,
              width: width,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(Spacing.medium),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.medium,
                      vertical: Spacing.medium,
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  _ButtonAction(
                    text: Text(tr(confirmText),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      onConfirm?.call();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<T?> showAlertDialog<T>({
    BuildContext? context,
    String? title,
    String? message,
    List<CupertinoDialogAction> actions = const [],
    List<CupertinoDialogAction> Function(BuildContext context)? builderActions,
    bool barrierDismissible = true,
    Widget Function(BuildContext)? builder,
  }) {
    return showCupertinoDialog<T>(
      context: context ?? Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) =>
          builder?.call(context) ??
          CupertinoAlertDialog(
            title: title == null
                ? null
                : Text(title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
            content: Padding(
              padding: const EdgeInsets.only(top: Spacing.small),
              child: message == null
                  ? null
                  : Text(message, style: TextStyle(height: 1.5)),
            ),
            actions: builderActions?.call(context) ?? actions,
          ),
    );
  }

  Future<bool> showConfirm(
      {required String title,
      required String message,
      String? cancelText,
      String? confirmText,
      BuildContext? context}) async {
    final check = await showCupertinoDialog<bool>(
      context: context ?? Get.context!,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          content: Padding(
            padding: const EdgeInsets.only(top: Spacing.small),
            child: Text(message, style: TextStyle(height: 1.5)),
          ),
          actions: [
            CupertinoDialogAction(
                onPressed: () {
                  context.closeModal(result: false);
                },
                child: Text(cancelText ?? tr("Cancel"))),
            CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  context.closeModal(result: true);
                },
                child: Text(confirmText ?? tr("Confirm"))),
          ]),
    );

    return check == true;
  }

  void showMenu({
    required BuildContext context,
    required String title,
    required String message,
    required List<ButtonMenu> menus,
    double width = 300,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final descriptionColor = isDarkMode ? onSurface.withAlpha(150) : onSurface;

    showCupertinoDialog(
      useRootNavigator: true,
      context: context,
      // barrierColor: Colors.black.withAlpha(100),
      barrierDismissible: true,
      // useSafeArea: true,

      // animationStyle: AnimationStyle(
      //   duration: kThemeAnimationDuration,
      // ),
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              clipBehavior: Clip.hardEdge,
              width: width,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(Spacing.medium),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.medium,
                      vertical: Spacing.medium,
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _MENU_COLORS[ButtonMenuColor.blue],
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    child: Column(children: menus),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDatePicker({
    required BuildContext context,
    required Function(DateTime) onDateTimeChanged,
    DateTime? minimumDate,
    DateTime? maximumDate,
    DateTime? initialDateTime,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
  }) {
    _showDateTimePicker(
        context: context,
        child: CupertinoDatePicker(
          initialDateTime: initialDateTime ?? DateTime.now(),
          mode: mode,
          use24hFormat: true,
          // This shows day of week alongside day of month
          showDayOfWeek: mode == CupertinoDatePickerMode.date,
          // This is called when the user changes the date.
          onDateTimeChanged: onDateTimeChanged,
        ));
  }

  void showWarningOutPage({
    required BuildContext context,
    required String title,
    required String message,
    bool hideDefaultAction = false,
    List<ButtonAction>? actions,
    double width = 300,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    Function? onConfirm,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final descriptionColor = isDarkMode ? onSurface.withAlpha(150) : onSurface;

    showAlertDialog(context: context, title: title, message: message, actions: [
      CupertinoDialogAction(
        child: Text(cancelText),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      CupertinoDialogAction(
        child: Text(confirmText),
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
          onConfirm?.call();
        },
      ),
    ]);

    // showDialog(
    //   useRootNavigator: true,
    //   context: context,
    //   barrierColor: Colors.black.withAlpha(100),
    //   builder: (context) {
    //     return Material(
    //       color: Colors.transparent,
    //       child: Center(
    //         child: Container(
    //           clipBehavior: Clip.hardEdge,
    //           width: width,
    //           decoration: BoxDecoration(
    //             color: isDarkMode ? Colors.black : Colors.white,
    //             borderRadius: BorderRadius.circular(Spacing.medium),
    //           ),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.symmetric(
    //                   horizontal: Spacing.medium,
    //                   vertical: Spacing.medium,
    //                 ),
    //                 child: Column(
    //                   children: [
    //                     Text(
    //                       title,
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                         fontSize: 18,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                     Text(
    //                       message,
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(fontSize: 14),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Column(children: [
    //                 if (actions != null)
    //                   ...actions!.map((btn) {
    //                     return _ButtonAction(
    //                       text: Text(btn.title,
    //                           textAlign: TextAlign.center,
    //                           style: TextStyle(
    //                             color: _ACTION_COLORS[btn.color],
    //                             fontSize: 18,
    //                             fontWeight: FontWeight.w600,
    //                           )),
    //                       onTap: btn.onTap,
    //                     );
    //                   }),
    //                 if (!hideDefaultAction)
    //                   _ButtonAction(
    //                     text: Text(tr(confirmText),
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                           color: Colors.red,
    //                           fontSize: 18,
    //                           fontWeight: FontWeight.w600,
    //                         )),
    //                     onTap: () {
    //                       Navigator.pop(context);
    //                       onConfirm?.call();
    //                     },
    //                   ),
    //                 if (!hideDefaultAction)
    //                   _ButtonAction(
    //                     text: Text(tr(cancelText),
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                           color: Colors.blue,
    //                           fontSize: 18,
    //                           fontWeight: FontWeight.w600,
    //                         )),
    //                     onTap: () {
    //                       Navigator.pop(context);
    //                     },
    //                   )
    //               ]),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  void warning({
    String? message,
    String? title,
    Function? onConfirm,
    String? confirmText,
    String? cancelText,
    List<WarningOption>? actions,
  }) {
    final context = Get.context!;
    popup(context, (context) {
      return Builder(builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // actionsAlignment: MainAxisAlignment.center,
          elevation: 20,
          title: Text(tr(title ?? "Warning")),
          content: Text(tr(message ?? "Are you sure?")),

          actions: actions
                  ?.map((e) => TextButton(onPressed: e.onTap, child: e.child))
                  .toList() ??
              [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(tr(cancelText ?? "Cancel"))),
                TextButton(
                    onPressed: () {
                      onConfirm?.call();
                      Navigator.pop(context);
                    },
                    child: Text(tr(confirmText ?? "Confirm"),
                        style: TextStyle(
                          color: Constant.red,
                        ))),
              ],
          // child: Column(
          //   children: [
          //     Text(title ?? "Warning"),
          //     Text(message ?? "Are you sure?"),
          //   ],
          // ),
        );
      });
    });
  }

  void hide(BuildContext context) {
    Navigator.pop(context);
  }

  Widget showPopover({
    required BuildContext context,
    required Widget child,
    required Widget trigger,
    Alignment alignment = Alignment.bottomRight,
    Offset offset = Offset.zero,
  }) {
    Offset? tapPosition;

    final overlay = Overlay.of(context);
    final globalKey = GlobalKey();

    return GestureDetector(
      key: globalKey,
      // onTapDown: (details) {
      //   tapPosition = details.globalPosition;
      // },
      onTap: () {
        final box = globalKey.currentContext?.findRenderObject() as RenderBox;
        final _offset = box.localToGlobal(Offset.zero);
        var x = _offset.dx + offset.dx;
        var y = _offset.dy + offset.dy;
        // final overlay =
        //     Overlay.of(context).context.findRenderObject() as RenderBox;

        late OverlayEntry entry;

        entry = OverlayEntry(
          // builder: (_) => Positioned(
          //   left: x,
          //   top: y,
          //   child: Material(child: Container(color: Colors.red, child: child)),
          // ),
          builder: (_) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: (details) {
                    entry.remove();
                  },
                ),
              ),
              Positioned(
                left: x,
                top: y,
                child: Material(color: Colors.transparent, child: child),
              )
            ],
          ),
        );

        overlay.insert(entry);
      },
      child: trigger,
    );
  }
}

class DialogWraper extends StatelessWidget {
  const DialogWraper({
    super.key,
    required this.child,
    this.maxWidth = double.infinity,
    this.barrierDismissible = true,
    this.padding = const EdgeInsets.all(Spacing.medium),
    this.radius = Spacing.large,
  });

  final Widget child;
  final double maxWidth;
  final bool barrierDismissible;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTap: () {
        if (barrierDismissible) {
          Navigator.pop(context);
        }
      },
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Container(
                      padding: padding,
                      margin: EdgeInsets.symmetric(horizontal: Spacing.medium),
                      clipBehavior: Clip.hardEdge,
                      constraints: BoxConstraints(
                        maxWidth: maxWidth,
                      ),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      child: Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                          ),
                          child: SingleChildScrollView(
                              child: IntrinsicHeight(child: child))),
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

class _ButtonAction extends StatelessWidget {
  const _ButtonAction({
    super.key,
    required this.text,
    this.onTap,
    this.rightBorder = false,
  });
  final Widget text;
  final Function()? onTap;
  final bool rightBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withAlpha(50),
          ),
          right: rightBorder
              ? BorderSide(
                  color: Colors.grey.withAlpha(50),
                )
              : BorderSide.none,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.small),
            child: text,
          ),
        ),
      ),
    );
  }
}

class _BottomSheetWraper extends StatelessWidget {
  const _BottomSheetWraper({
    super.key,
    required this.child,
    this.bgColor,
  });

  final Widget child;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;

    final _bgColor = bgColor ??
        (isDarkMode
            ? Color(0xFF142127)
            : Theme.of(context).scaffoldBackgroundColor);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        // Prevent close modal when tap on background
        // Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Spacing.medium),
            topRight: Radius.circular(Spacing.medium),
          ),
          color: _bgColor,
          // color: Colors.red,

          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 5,
            )
          ],
        ),
        child: child,
      ),
    );
  }
}

class _Top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF444d53) : Color(0xFFc9ccd2),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withAlpha(50),
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          right: 4,
          child: SIconButton(
            svgPath: 'assets/images/svg/x.svg',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

void _showDateTimePicker({
  required BuildContext context,
  required Widget child,
}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      // The Bottom margin is provided to align the popup above the system
      // navigation bar.
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // Provide a background color for the popup.
      color: CupertinoColors.systemBackground.resolveFrom(context),
      // Use a SafeArea widget to avoid system overlaps.
      child: SafeArea(top: false, child: child),
    ),
  );
}

//--------------------------------

enum ButtonMenuColor { blue, red, grey }

const _MENU_COLORS = {
  ButtonMenuColor.red: Colors.red,
  ButtonMenuColor.blue: Colors.blue,
  ButtonMenuColor.grey: Colors.grey,
};

class ButtonMenu extends StatelessWidget {
  const ButtonMenu({
    super.key,
    required this.text,
    this.onTap,
    this.rightBorder = false,
  });
  final Widget text;
  final Function()? onTap;
  final bool rightBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withAlpha(50),
          ),
          right: rightBorder
              ? BorderSide(
                  color: Colors.grey.withAlpha(50),
                )
              : BorderSide.none,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child:
            Padding(padding: const EdgeInsets.all(Spacing.small), child: text),
      ),
    );
  }
}

class ActionSheetWraper extends StatelessWidget {
  const ActionSheetWraper({
    super.key,
    required this.children,
    this.title,
    this.scrollController,
    this.padding,
    this.childPadding,
    this.titlePadding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });
  final List<Widget> children;
  final Widget? title;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? childPadding;
  final EdgeInsetsGeometry? titlePadding;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return SingleChildScrollView(
      controller: scrollController,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              padding: titlePadding ??
                  EdgeInsets.symmetric(
                    horizontal: Spacing.medium,
                    vertical: Spacing.medium,
                  ),
              margin: EdgeInsets.only(bottom: Spacing.medium / 2),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: onSurface.withAlpha(30),
                  ),
                ),
              ),
              child: title!,
            ),
          Container(
            padding: childPadding,
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              spacing: Spacing.small,
              children: children,
            ),
          )
        ],
      ),
    );
  }
}

class BottomSheetTitle extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  BottomSheetTitle({
    this.leading,
    this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = getOnSurface(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (leading != null) leading!,
        if (title != null)
          Expanded(
            child: DefaultTextStyle(
                style: TextStyle(
                    fontSize: 24,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.bold,
                    color: onSurface),
                child: title!),
          ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ignore: must_be_immutable
class ActionSheet extends StatelessWidget {
  ActionSheet({
    super.key,
    this.icon,
    this.title,
    this.subTitle,
    this.onTap,
    this.color,
    this.checked,
    this.trailing,
    this.isDestructive = false,
    this.radioButton = false,
    this.selected = false,
  });
  final Widget? icon;
  final Widget? title;
  final Widget? subTitle;
  Function()? onTap;
  final Color? color;
  final bool? checked;
  final Widget? trailing;
  final bool isDestructive;
  bool radioButton;
  bool selected;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          // vertical: Spacing.small,
          horizontal: Spacing.medium,
        ),
        width: double.infinity,
        decoration: BoxDecoration(),
        child: Row(
          spacing: Spacing.small,
          children: [
            if (icon != null)
              IconTheme(
                data: IconThemeData(
                  color: isDestructive ? Colors.red : color ?? onSurface,
                  size: 20,
                ),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(50),
                    shape: BoxShape.circle,
                  ),
                  child: icon!,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Spacing.xSmall,
                children: [
                  if (title != null)
                    DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDestructive
                                ? Colors.red
                                : color ?? onSurface),
                        child: title!),
                  if (subTitle != null)
                    DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 12, color: onSurface.withAlpha(150)),
                        child: subTitle!),
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (checked != null)
              Transform.scale(
                scale: 0.7,
                child: Transform.translate(
                  offset: Offset(10, 0),
                  child: CupertinoSwitch(
                    applyTheme: true,
                    value: checked!,
                    onChanged: (value) {},
                  ),
                ),
              ),
            if (radioButton)
              SRadio(
                size: 25,
                // color: onSurface.withAlpha(100),
                borderColor: onSurface.withAlpha(30),
                unCheckedColor: onSurface.withAlpha(30),
                checked: selected,
                // onChanged: (value) {},
              )
          ],
        ),
      ),
    );
  }
}

class ActionTitle extends StatelessWidget {
  const ActionTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      margin: const EdgeInsets.only(
        left: Spacing.medium,
        right: Spacing.medium,
        bottom: Spacing.medium,
      ),
      child: Text(title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: onSurface.withAlpha(150))),
    );
  }
}

class ActionDivider extends StatelessWidget {
  const ActionDivider({
    super.key,
    this.padding,
    this.color,
  });
  final double? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      margin: EdgeInsets.symmetric(vertical: padding ?? Spacing.small),
      child: Divider(
        color: color ?? onSurface.withAlpha(30),
        height: 1,
      ),
    );
  }
}

//--------------------------------
var Modal = _Modal();

extension ModalX on BuildContext {
  closeModal({dynamic result}) {
    Modal.pop(this, result: result);
    // Get.back(result: true);
  }
}
