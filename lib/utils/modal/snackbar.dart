part of "modal.dart";

extension Snackbar on _Modal {
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
    VoidCallback? onTap,
    Widget? icon,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    Get.closeCurrentSnackbar();
    Get.closeAllSnackbars();
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
        snackPosition: snackPosition,
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
}
