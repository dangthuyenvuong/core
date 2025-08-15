import 'dart:async';

import 'package:flutter/material.dart';

class CountdownController {
  Timer? _timer;

  ValueNotifier<int> seconds = ValueNotifier(0);
  bool isHide = false;
  Function()? onFinish;

  CountdownController({this.onFinish});

  get second => seconds.value;

  void start(int seconds) {
    this.seconds.value = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      this.seconds.value--;
      if (this.seconds.value == 0) {
        _timer?.cancel();
        onFinish?.call();
      }
    });
  }

  void restart(int? seconds) {
    _timer?.cancel();
    isHide = false;
    start(seconds ?? this.seconds.value);
  }

  void dispose() {
    _timer?.cancel();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    seconds.value = 0;
  }

  void hide() {
    stop();
    isHide = true;
  }
}

class CountDown extends StatefulWidget {
  const CountDown(
      {super.key,
      this.onCountDown,
      this.onFinish,
      required this.render,
      required this.seconds,
      required this.controller,
      this.hours,
      this.minutes});
  final Function(int)? onCountDown;
  final Function()? onFinish;
  final Widget Function({int seconds}) render;
  final CountdownController controller;

  final int seconds;
  final int? hours;
  final int? minutes;

  @override
  State<CountDown> createState() => _CountDown(seconds: seconds);
}

class _CountDown extends State<CountDown> {
  int seconds = 0;

  _CountDown({required this.seconds}) {}

  @override
  void initState() {
    super.initState();
    widget.controller.start(widget.seconds);
  }

  @override
  void dispose() {
    widget.controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.isHide) return Container();
    return ValueListenableBuilder(
        valueListenable: widget.controller.seconds,
        builder: (context, value, child) {
          return widget.render(seconds: value);
        });
  }
}
