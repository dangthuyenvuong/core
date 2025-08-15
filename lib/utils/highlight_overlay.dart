import 'dart:ui';

import 'package:flutter/material.dart';

class HighlightOverlay {
  static final HighlightOverlay _instance = HighlightOverlay._internal();
  factory HighlightOverlay() => _instance;
  HighlightOverlay._internal();
  OverlayEntry? _entry;

  static void show({
    required BuildContext context,
    required GlobalKey globalKey,
    Widget? child,
    List<Widget> Function(Offset, Size)? builder,
  }) {
    if (_instance._entry != null) return;

    final RenderBox box =
        globalKey.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

    _instance._entry = OverlayEntry(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final bg = isDarkMode ? Colors.black.withAlpha(150) : Colors.white.withAlpha(150);
        return Material(
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Lớp mờ
              GestureDetector(
                onTap: hide,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                  child: Container(color: bg),
                ),
              ),

              // Tin nhắn được làm nổi
              if (child != null)
                Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  width: size.width,
                  height: size.height,
                  child: child,
                ),
              if (builder != null) ...builder(offset, size)
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_instance._entry!);
  }

  static void hide() {
    _instance._entry?.remove();
    _instance._entry = null;
  }
}

void showHighlightOverlay(BuildContext context, String message) {
  OverlayEntry(
    builder: (context) {
      return Container(
        color: Colors.black.withAlpha(150),
      );
    },
  );
}
