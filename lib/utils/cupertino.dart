import 'dart:math';

import 'package:core/core.dart';
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

  static Future<DateTime?> showDatePicker({
    BuildContext? context,
    DateTime? initialDateTime,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
    use24hFormat = false,
    showDayOfWeek = false,
    required Function(DateTime)? onDateTimeComplete,
    Function(DateTime)? onDateTimeChange,
    bool isRequired = false,
    DateTime? minimumDate,
    DateTime? maximumDate,
    final bool allowClear = false,
    final Function()? onClear,
    String? title,
  }) async {
    final disableMaxDate = minimumDate != null &&
        maximumDate != null &&
        minimumDate.compareTo(maximumDate) >= 0;
    final onSurface = getOnSurface(Get.context!);

    DateTime time = initialDateTime ?? DateTime.now();
    final result = await showCupertinoModalPopup<bool?>(
      context: context ?? Get.context!,
      builder: (BuildContext context) => GestureDetector(
        onTap: () {
          // if (isRequired) {
          //   Navigator.pop(context, true);
          // }
        },
        child: Material(
          color: Colors.transparent,
          child: IntrinsicHeight(
            child: Container(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      Spacing.medium,
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: onSurface.withAlpha(30)))),
                    child: Column(
                      children: [
                        if (isRequired)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text(
                                  "Close".tr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text(
                                  "Cancel".tr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              if (title != null)
                                Expanded(
                                    child: STitle(
                                  title: title,
                                  textAlign: TextAlign.center,
                                )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text(
                                  "Save".tr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Container(
                    height: 216,
                    padding: const EdgeInsets.only(top: Spacing.medium),

                    // The Bottom margin is provided to align the popup above the system
                    // navigation bar.
                    margin: EdgeInsets.only(
                        // top: Spacing.medium,
                        bottom: max(MediaQuery.of(context).viewInsets.bottom,
                            MediaQuery.of(context).padding.bottom)),
                    // Provide a background color for the popup.
                    // color:
                    //     CupertinoColors.systemBackground.resolveFrom(context),
                    // Use a SafeArea widget to avoid system overlaps.
                    child: CupertinoDatePicker(
                      initialDateTime: initialDateTime,
                      mode: mode,
                      use24hFormat: use24hFormat,
                      minimumDate: disableMaxDate ? null : minimumDate,
                      maximumDate: disableMaxDate ? null : maximumDate,
                      // This shows day of week alongside day of month
                      // showDayOfWeek: showDayOfWeek,
                      // This is called when the user changes the date.
                      onDateTimeChanged: (value) {
                        time = value;
                        onDateTimeChange?.call(value);
                      },
                    ),
                  ),
                  if (allowClear)
                    SizedBox(
                      width: double.infinity,
                      child: SButton(
                        color: ButtonColor.grey,
                        textColor: Colors.red,
                        icon: Icons.clear,
                        child: Text("Clear"),
                        onTap: () {
                          onClear?.call();
                          Navigator.pop(context, false);
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (result != null && result) {
      onDateTimeComplete?.call(time);
      return time;
    }

    return null;
  }

  static Future<DateTimeRange?> showDateRangePicker({
    required BuildContext context,
    DateTimeRange? initialDateTime,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
    use24hFormat = false,
    showDayOfWeek = false,
    required Function(DateTimeRange)? onDateTimeComplete,
    Function(DateTimeRange)? onDateTimeChange,
    bool isRequired = false,
    DateTime? minimumDate,
    DateTime? maximumDate,
    final bool allowClear = false,
    final Function()? onClear,
    final bool disabledStart = false,
    final bool disabledEnd = false,
  }) async {
    DateTimeRange time = initialDateTime ??
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final result = await showCupertinoModalPopup<bool?>(
      context: context,
      builder: (BuildContext context) => GestureDetector(
        onTap: () {
          if (isRequired) {
            Navigator.pop(context, true);
          }
        },
        child: Material(
          color: Colors.transparent,
          child: IntrinsicHeight(
            child: Container(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              padding: EdgeInsets.all(Spacing.medium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isRequired)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrange),
                          ),
                        ),
                      ],
                    ),
                  Container(
                    // height: 216 * 2,
                    padding: const EdgeInsets.only(top: 6.0),
                    // The Bottom margin is provided to align the popup above the system
                    // navigation bar.
                    margin: EdgeInsets.only(
                        top: Spacing.medium,
                        bottom: max(MediaQuery.of(context).viewInsets.bottom,
                            MediaQuery.of(context).padding.bottom)),
                    // Provide a background color for the popup.
                    // color:
                    //     CupertinoColors.systemBackground.resolveFrom(context),
                    // Use a SafeArea widget to avoid system overlaps.
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 50, child: Text("From")),
                            Expanded(
                              child: disabledStart
                                  ? Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: Spacing.medium),
                                      child: Text(
                                          time.start.format("MMMM dd, yyyy"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 26)),
                                    )
                                  : Container(
                                      height: 216,
                                      child: CupertinoDatePicker(
                                        initialDateTime: time.start,
                                        mode: mode,
                                        use24hFormat: use24hFormat,
                                        minimumDate: minimumDate,
                                        maximumDate: maximumDate,
                                        // This shows day of week alongside day of month
                                        // showDayOfWeek: showDayOfWeek,
                                        // This is called when the user changes the date.
                                        onDateTimeChanged: (value) {
                                          time = DateTimeRange(
                                              start: value, end: time.end);
                                          onDateTimeChange?.call(time);
                                        },
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        Container(
                          height: 0.5,
                          color: onSurface.withAlpha(50),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 50, child: Text("To")),
                            Expanded(
                              child: Container(
                                height: 216,
                                child: CupertinoDatePicker(
                                  initialDateTime: time.end,
                                  mode: mode,
                                  use24hFormat: use24hFormat,
                                  minimumDate: minimumDate,
                                  maximumDate: maximumDate,
                                  // This shows day of week alongside day of month
                                  // showDayOfWeek: showDayOfWeek,
                                  // This is called when the user changes the date.
                                  onDateTimeChanged: (value) {
                                    time = DateTimeRange(
                                        start: time.start, end: value);
                                    onDateTimeChange?.call(time);
                                    // time = value;
                                    // onDateTimeChange?.call(value);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (allowClear)
                    SizedBox(
                      width: double.infinity,
                      child: SButton(
                        color: ButtonColor.grey,
                        textColor: Colors.red,
                        icon: Icons.clear,
                        child: Text("Clear"),
                        onTap: () {
                          onClear?.call();
                          Navigator.pop(context, false);
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (result != null && result) {
      onDateTimeComplete?.call(time);
      return time;
    }

    return null;
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
          child: Text(exitText ?? "Quit".tr),
          onPressed: onExit ??
              () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
        ),
        CupertinoDialogAction(
          child: Text(cancelText ?? "Cancel".tr),
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
