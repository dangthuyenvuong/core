import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _padding = Spacing.medium / 2;

// class MenuGroup extends StatelessWidget {
//   const MenuGroup({
//     super.key,
//     required this.items,
//     this.title,
//     this.helperText,
//   });
//   final List<MenuItem> items;
//   final String? title;
//   final String? helperText;

//   @override
//   Widget build(BuildContext context) {
//     final onSurface = Theme.of(context).colorScheme.onSurface;

//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: _padding,
//         // vertical: Spacing.small,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: Spacing.small,
//         children: [
//           if (title != null)
//             Padding(
//               padding: EdgeInsets.only(
//                 left: Spacing.medium,
//                 right: Spacing.medium,
//               ),
//               child: Text(
//                 title!.toUpperCase(),
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: onSurface.withAlpha(100),
//                 ),
//               ),
//             ),
//           Container(
//             decoration: BoxDecoration(
//               color: onSurface.withAlpha(10),
//               borderRadius: BorderRadius.circular(Spacing.small),
//             ),
//             child: Column(
//               children: items.mapV2((e, index) {
//                 // if (index < items.length - 1) {
//                 //   e.showBorder = true;
//                 // }
//                 return e;
//               }).toList(),
//             ),
//           ),
//           if (helperText != null)
//             Padding(
//               padding: EdgeInsets.only(
//                 left: Spacing.medium,
//                 right: Spacing.medium,
//               ),
//               child: Text(
//                 helperText!,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w300,
//                   color: onSurface.withAlpha(100),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class MenuItem extends StatefulWidget {
//   MenuItem({
//     super.key,
//     required this.text,
//     this.icon,
//     this.isSelected = false,
//     this.onTap,
//     this.isDisabled = false,
//     this.isShowChevron = false,
//     this.isShowCheckmark = false,
//     this.showBorder = false,
//     this.subText,
//     this.value,
//   });
//   final String text;
//   final Widget? icon;
//   final bool isSelected;
//   final VoidCallback? onTap;
//   final bool isDisabled;
//   final bool isShowChevron;
//   final bool isShowCheckmark;
//   final String? subText;
//   final String? value;
//   final bool showBorder;

//   @override
//   State<MenuItem> createState() => _MenuItemState();
// }

// class _MenuItemState extends State<MenuItem> {
//   @override
//   Widget build(BuildContext context) {
//     final onSurface = Theme.of(context).colorScheme.onSurface;
//     return Row(
//       children: [
//         if (widget.icon != null)
//           Container(
//             padding: EdgeInsets.only(
//               right: Spacing.medium,
//               left: Spacing.medium,
//             ),
//             child: IconTheme(
//               data: IconThemeData(
//                 size: 20,
//                 color: onSurface.withAlpha(100),
//               ),
//               child: widget.icon!,
//             ),
//           ),
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.only(
//               top: Spacing.mediumSmall,
//               bottom: Spacing.mediumSmall,
//               right: Spacing.mediumSmall,
//             ),
//             decoration: BoxDecoration(
//               border: widget.showBorder
//                   ? Border(bottom: BorderSide(color: onSurface.withAlpha(20)))
//                   : null,
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     // spacing: Spacing.xSmall,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             widget.text,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           if (widget.value != null)
//                             Expanded(
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: Spacing.small),
//                                 child: Text(
//                                   widget.value!,
//                                   textAlign: TextAlign.end,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: onSurface.withAlpha(100),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           SizedBox(width: Spacing.small),
//                         ],
//                       ),
//                       if (widget.subText != null)
//                         Text(
//                           widget.subText!,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: onSurface.withAlpha(100),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 if (widget.isShowChevron)
//                   Icon(
//                     CupertinoIcons.chevron_right,
//                     size: 18,
//                     color: onSurface.withAlpha(100),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
