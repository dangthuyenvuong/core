import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension CoreSvg on CoreBase {
  Widget svgAsset(String path,
      {double? size,
      Color? color,
      String? package,
      AlignmentGeometry? alignment}) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      package: package,
      alignment: alignment ?? Alignment.center,
    );
  }
}
