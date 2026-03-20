import 'dart:io';
import 'dart:math';

import 'package:core/extension.dart';
import 'package:flutter/material.dart';

class SAvatar extends StatelessWidget {
  const SAvatar(
      {super.key,
      this.url,
      this.size = 40,
      this.radius = 999,
      this.action,
      this.onTap,
      this.fallback,
      this.isOnline,
      this.onlineOffset = const Offset(0, 0),
      this.name,
      this.file,
      this.child});
  final String? url;
  final double size;
  final double radius;
  final Widget? action;
  final String? fallback;
  final Function()? onTap;
  final bool? isOnline;
  final Offset? onlineOffset;
  final String? name;
  final File? file;
  final Widget? child;

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
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final file = this.file != null
        ? Image.file(width: size, height: size, this.file!, fit: BoxFit.cover)
        : null;

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
              color: onSurface.withAlpha(20),
              // image: DecorationImage(
              //   image: url.isNotNullAndEmpty
              //       ? _getImageProvider(url!)
              //       : AssetImage(fallback!),
              //   fit: BoxFit.cover,
              // ),
            ),
            alignment: Alignment.center,
            child: file ??
                ((url.isNotNullAndEmpty || fallback != null)
                    ? Image(
                        width: size,
                        height: size,
                        image: url.isNotNullAndEmpty
                            ? _getImageProvider(url!)
                            : fallback.isNotNullAndEmpty
                                ? AssetImage(fallback!)
                                : AssetImage('assets/images/avatar.png'),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          if (name != null) {
                            return Text(
                              name!.substring(0, 2).toUpperCase(),
                              style: TextStyle(
                                  fontSize: size * 0.5,
                                  fontWeight: FontWeight.bold,
                                  color: onSurface),
                            );
                          }
                          return fallback != null
                              ? Image.asset(
                                  fallback!,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox.shrink();
                        },
                      )
                    : name.isNotNullAndEmpty
                        ? FittedBox(
                            child: Text(
                              name!.substring(0, 2).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: size * 0.5,
                                  fontWeight: FontWeight.bold,
                                  color: onSurface),
                            ),
                          )
                        : child),
          ),
          if (action != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: action!,
            ),
          if (isOnline != null)
            Positioned(
              right: onlineOffset?.dx,
              bottom: onlineOffset?.dy,
              child: Container(
                width: sizeOnline + 4,
                height: sizeOnline + 4,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: sizeOnline,
                  height: sizeOnline,
                  decoration: BoxDecoration(
                    color: isOnline! ? Colors.green : Colors.grey.shade600,
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
