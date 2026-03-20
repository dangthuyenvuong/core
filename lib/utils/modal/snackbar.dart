part of "modal.dart";

SnackbarController? snackbarController;

extension Snackbar on _Modal {
  void closeSnackbar() {
    Get.closeCurrentSnackbar();
    Get.closeAllSnackbars();
    snackbarController?.close();
  }

  void showSnackBar({
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
    OnTap? onTap,
    // Widget? icon,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    Widget? title,
    Duration? duration,
  }) {
    Get.closeCurrentSnackbar();
    Get.closeAllSnackbars();
    snackbarController = Get.showSnackbar(
      GetSnackBar(
        onTap: onTap,
        backgroundColor: backgroundColor ??
            Get.theme.bottomNavigationBarTheme.backgroundColor?.lighter(0.1) ??
            Color(0xFF303030),
        padding: padding ?? EdgeInsets.all(16),
        // mainButton: IconButton(
        //   onPressed: onTap,
        //   icon: Icon(Icons.close),
        // ),
        // message: "ádfasdf",
        messageText: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            if (leading != null) leading,
            Expanded(child: message),
            ...actions,
          ],
        ),
        snackPosition: snackPosition,
        // backgroundColor: Colors.black,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: duration ?? Duration(seconds: 2),
        animationDuration: kThemeAnimationDuration,
        // icon: icon,
        shouldIconPulse: false,
        titleText: title,
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

  showError(String message) {
    Modal.showSnackBar(
      context: Get.context!,
      leading: Icon(CupertinoIcons.xmark_circle_fill, color: Colors.white),
      backgroundColor: Colors.red,
      message: Text(message, style: TextStyle(color: Colors.white)),
    );
  }

  void showNotification({
    required BuildContext context,
    String? title,
    String? message,
    Widget? icon,
    List<Widget> actions = const [],
  }) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    Modal.showSnackBar(
      duration: Duration(seconds: 5),
      context: context,
      // backgroundColor: Theme.of(
      //   context,
      // ).bottomNavigationBarTheme.backgroundColor?.lighter(0.1),
      message: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          if (message != null) Text(message),
        ],
      ),
      leading: icon,
      // title: Text(
      //   "Inbox",
      //   style: TextStyle(fontWeight: FontWeight.bold),
      // ),
      actions: actions,
      // backgroundColor: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
