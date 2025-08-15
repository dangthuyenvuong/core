import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cupertino {
  // static void showActionSheet({
  //   required BuildContext context,
  //   required Widget? title,
  //   required Widget? message,
  //   required List<CupertinoActionSheetAction> Function(BuildContext context) builder,
  //   CupertinoActionSheetAction? cancelButton,
  //   ScrollController? actionScrollController,
  //   ScrollController? messageScrollController,
  // }) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     barrierDismissible: true,
  //     useRootNavigator: true,

  //     builder: (BuildContext context) => CupertinoActionSheet(
  //       title: title,
  //       message: message,
  //       cancelButton: cancelButton,
  //       actionScrollController: actionScrollController,
  //       messageScrollController: messageScrollController,
  //       actions: builder(context),
  //     ),
  //   );
  // }

  // static void showActionSheet({
  //   required BuildContext context,
  //   required Widget? title,
  //   required Widget? message,
  //   required List<CupertinoActionSheetAction> actions,
  // }) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoActionSheet(
  //       title: title,
  //       message: message,
  //       actions: actions,
  //     ),
  //   );
  // }

  static Future<T?> showAlertDialog<T>({
    required BuildContext context,
    required Widget? title,
    required Widget? content,
    required List<CupertinoDialogAction> actions,
  }) {
    return showCupertinoDialog<T?>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  static Future<T?> showDatePicker<T>({
    required BuildContext context,
    DateTime? initialDateTime,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
    use24hFormat = false,
    showDayOfWeek = false,
    required Function(DateTime) onDateTimeChanged,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: initialDateTime,
            mode: mode,
            use24hFormat: use24hFormat,
            // This shows day of week alongside day of month
            // showDayOfWeek: showDayOfWeek,
            // This is called when the user changes the date.
            onDateTimeChanged: onDateTimeChanged,
          ),
        ),
      ),
    );
  }

  static void picker({
    required BuildContext context,
    required List<String> items,
    int? initialItem,
    required Function(int) onSelectedItemChanged,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32,
            // This sets the initial item.
            scrollController:
                FixedExtentScrollController(initialItem: initialItem ?? 0),
            // This is called when selected item is changed.
            onSelectedItemChanged: onSelectedItemChanged,
            children: List<Widget>.generate(items.length, (int index) {
              return Center(child: Text(items[index]));
            }),
          ),
        ),
      ),
    );
  }

  static void showModalPopup<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    showCupertinoDialog<T>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (BuildContext context) => SafeArea(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: builder(context),
        ),
      ),
    );
  }

  static void showAlertOutPage({
    required BuildContext context,
    required String title,
    required String content,
    required Function()? onExit,
    required Function()? onCancel,
    String? exitText,
    String? cancelText,
  }) {
    Cupertino.showAlertDialog(
      context: context,
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(exitText ?? tr("Quit")),
          onPressed: onExit ??
              () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
        ),
        CupertinoDialogAction(
          child: Text(cancelText ?? tr("Cancel")),
          isDestructiveAction: true,
          onPressed: onCancel ??
              () {
                Navigator.pop(context);
              },
        ),
      ],
    );
  }
}
