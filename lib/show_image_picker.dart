import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// void showImagePicker({required BuildContext context}) {
//   showModalBottomSheet(
//       context: context,
//       useRootNavigator: true,
//       useSafeArea: true,
//       enableDrag: true,
//       backgroundColor: Colors.transparent,
//       barrierColor: Colors.black.withAlpha(100),
//       builder: (context) => CupertinoActionSheet(
//             title: Text("Image picker".tr),
//             actions: [
//               CupertinoActionSheetAction(
//                 child: Text("View".tr),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               CupertinoActionSheetAction(
//                 child: Text("Camera".tr),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               CupertinoActionSheetAction(
//                 child: Text("Gallery".tr),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//             cancelButton: CupertinoActionSheetAction(
//               child: Text("Cancel".tr),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           )
//       // builder: (context) => SafeArea(
//       //   child: Padding(
//       //     padding: EdgeInsets.symmetric(horizontal: 8),
//       //     child: Column(
//       //       mainAxisSize: MainAxisSize.min,
//       //       children: [
//       //         Container(
//       //           clipBehavior: Clip.hardEdge,
//       //           decoration: BoxDecoration(
//       //             color: Color(0xFFf0f0f0),
//       //             borderRadius: BorderRadius.all(
//       //               Radius.circular(12),
//       //             ),
//       //           ),
//       //           child: Column(
//       //             children: [
//       //               _OptionItem(title: "Chụp ảnh"),
//       //               _OptionItem(title: "Tải ảnh lên"),
//       //               _OptionItem(title: "Xem ảnh", border: false),
//       //             ],
//       //           ),
//       //         ),
//       //         SizedBox(height: 8),
//       //         Container(
//       //           clipBehavior: Clip.hardEdge,
//       //           decoration: BoxDecoration(
//       //             color: Colors.white,
//       //             borderRadius: BorderRadius.all(
//       //               Radius.circular(12),
//       //             ),
//       //           ),
//       //           child: _OptionItem(
//       //             title: "Hủy",
//       //             border: false,
//       //           ),
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//       );
// }

class _OptionItem extends StatelessWidget {
  const _OptionItem({
    super.key,
    this.border = true,
    required this.title,
    this.onTap,
  });
  final String title;
  final bool border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        child: InkWell(
          splashColor: Colors.black.withAlpha(30),
          onTap: () {
            print("tap");
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: border
                    ? BorderSide(
                        color: Color(0xFFe0e0e0),
                      )
                    : BorderSide.none,
              ),
            ),
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF057aff),
                    // fontWeight: FontWeight.w400,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
