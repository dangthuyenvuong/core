import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DynamicImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;

  DynamicImage({required this.imagePath, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    if (imagePath.endsWith('.svg')) {
      return SvgPicture.asset(imagePath);
    }

    return Image(
      image: _getImageProvider(imagePath),
      width: width,
      height: height,
      fit: fit,
    );
  }

  // Hàm xác định xem ảnh đến từ network hay asset
  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }
}
