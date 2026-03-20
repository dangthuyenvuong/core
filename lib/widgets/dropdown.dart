import 'dart:math';
import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

class SDropdown extends StatefulWidget {
  const SDropdown({
    super.key,
    required this.itemBuilder,
    required this.builder,
    this.maxHeight,
    this.minWidth,
    this.width,
    this.height,
    this.alignment = Alignment.bottomLeft,
    this.borderRadius,
    this.isBlur = false,
  });
  final Widget Function(
      BuildContext context, Future<void> Function() toggleOpen) itemBuilder;
  final Widget Function(BuildContext context) builder;
  final double? maxHeight;
  final double? minWidth;
  final double? width;
  final double? height;
  final Alignment alignment;
  final BorderRadiusGeometry? borderRadius;
  final bool isBlur;

  @override
  _SDropdownState createState() => _SDropdownState();
}

class _SDropdownState extends State<SDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _dropdownOverlay;
  final aniKey = GlobalKey<_SAnimatedPopupState>();

  Future<void> _toggleDropdown() async {
    if (_dropdownOverlay == null) {
      _dropdownOverlay = _createOverlay();
      Overlay.of(context, rootOverlay: true)
          .insert(_dropdownOverlay!, above: null);
      setState(() {});
    } else {
      await _removeOverlay();
    }
  }

  Future<void> _removeOverlay() async {
    await aniKey.currentState?.dismiss();
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
    setState(() {});
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    Size buttonSize = renderBox.size;
    Offset buttonPosition = renderBox.localToGlobal(Offset.zero);
    final top = buttonPosition.dy + buttonSize.height;
    final maxHeight =
        widget.maxHeight ?? MediaQuery.of(context).size.height - top - 200;

    final bg = Theme.of(context).bottomNavigationBarTheme.backgroundColor;
    final controller = ScrollController();
    final child = Stack(
      children: [
        // Positioned.fill(
        //   child: GestureDetector(
        //     behavior: HitTestBehavior.translucent,
        //     onTap: _toggleDropdown,
        //   ),
        // ),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _toggleDropdown,
            child: Container(
              color: Colors.black.withAlpha(100),
            ),
          ),
        ),
        Positioned(
          // width: max(buttonSize.width, widget.minWidth ?? 0),
          top: top,
          left: widget.alignment.isRight() ? null : buttonPosition.dx,
          right: widget.alignment.isRight()
              ? MediaQuery.of(context).size.width -
                  buttonPosition.dx -
                  buttonSize.width
              : null,
          child: _SAnimatedPopup(
            key: aniKey,
            alignment: _getDropdownAlignment(),
            // onDismiss: () {
            //   _toggleDropdown();
            // },
            child: Padding(
              padding: EdgeInsets.only(),
              child: Container(
                width:
                    widget.width ?? max(buttonSize.width, widget.minWidth ?? 0),
                height: widget.height,
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                ),
                child: Material(
                  // elevation: 4,
                  borderRadius: widget.borderRadius,
                  clipBehavior: Clip.hardEdge,
                  color: bg,
                  child: Scrollbar(
                    controller: controller,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: controller,
                      child: widget.itemBuilder(context, _toggleDropdown),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return OverlayEntry(
      builder: (context) => widget.isBlur
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: child,
            )
          : child,
    );
  }

  Alignment _getDropdownAlignment() {
    if (widget.alignment.isBottom()) {
      if (widget.alignment.isRight()) {
        return Alignment.topRight;
      }
      return Alignment.topLeft;
    }

    if (widget.alignment.isRight()) {
      return Alignment.bottomRight;
    }
    return Alignment.bottomLeft;
  }

  Widget _dropdownItem(String text) {
    return ListTile(
      title: Text(text),
      onTap: () {
        _toggleDropdown(); // đóng lại
      },
    );
  }

  final GlobalKey _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _buttonKey,
        onTap: _toggleDropdown,
        behavior: HitTestBehavior.opaque,
        child: widget.builder(context),
      ),
    );
  }

  @override
  void dispose() {
    _dropdownOverlay?.remove();
    super.dispose();
  }
}

class _SAnimatedPopup extends StatefulWidget {
  final Widget child;
  final Alignment alignment;

  const _SAnimatedPopup({
    required this.child,
    this.alignment = Alignment.topCenter,
    super.key,
  });

  @override
  State<_SAnimatedPopup> createState() => _SAnimatedPopupState();
}

class _SAnimatedPopupState extends State<_SAnimatedPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      alignment: widget.alignment,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}
