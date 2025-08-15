import 'dart:math';

import 'package:core/extension.dart';
import 'package:flutter/material.dart';

class SAvatar extends StatelessWidget {
  const SAvatar({
    super.key,
    this.url,
    this.size = 40,
    this.radius = 999,
    this.action,
    this.onTap,
    this.fallback,
    this.isOnline,
  });
  final String? url;
  final double size;
  final double radius;
  final Widget? action;
  final String? fallback;
  final Function()? onTap;
  final bool? isOnline;

  // Hàm xác định xem ảnh đến từ network hay asset
  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).scaffoldBackgroundColor;
    final sizeOnline = max(10, size * 0.15 + 2).toDouble();

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: size,
            width: size,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
            ),
            child: url != null || fallback != null
                ? Image(
                    image: url.isNotNullOrEmpty
                        ? _getImageProvider(url!)
                        : AssetImage(fallback!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return fallback != null
                          ? Image.asset(
                              fallback!,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox.shrink();
                    },
                  )
                : null,
          ),
          if (action != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: action!,
            ),
          if (isOnline != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: sizeOnline + 2,
                height: sizeOnline + 2,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: sizeOnline,
                  height: sizeOnline,
                  decoration: BoxDecoration(
                    color: isOnline! ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
