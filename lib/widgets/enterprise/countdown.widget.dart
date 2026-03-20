import 'dart:async';

import 'package:flutter/material.dart';

class ECountdownController {
  Timer? _timer;
  int startTime = 0;

  ValueNotifier<int> seconds = ValueNotifier(0);
  bool isHide = false;
  Function()? onFinish;
  bool isCountDown = true;

  ECountdownController(
      {this.onFinish, this.isCountDown = true, this.startTime = 0});

  get second => seconds.value;

  void start([int? seconds]) {
    this.seconds.value = isCountDown ? (seconds ?? startTime) : 0;
    _timer?.cancel();

    if (isCountDown) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _countDown();
      });
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _countUp();
      });
    }
  }

  void _countDown() {
    this.seconds.value--;
    if (this.seconds.value == 0) {
      _timer?.cancel();
      onFinish?.call();
    }
  }

  void _countUp() {
    this.seconds.value++;
  }

  void restart(int? seconds) {
    _timer?.cancel();
    isHide = false;
    start(seconds ?? (isCountDown ? this.seconds.value : 0));
  }

  void dispose() {
    _timer?.cancel();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    seconds.value = isCountDown ? 0 : this.seconds.value;
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
  final Widget Function(int seconds) render;
  final ECountdownController controller;

  final int? seconds;
  final int? hours;
  final int? minutes;

  @override
  State<CountDown> createState() => _CountDown();
}

class _CountDown extends State<CountDown> {
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.start();
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
          return widget.render(value);
        });
  }
}

String formatTime(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final secs = seconds % 60;
  final arr = [hours, minutes, secs].where((element) => element > 0).toList();
  return arr.map((e) => e.toString().padLeft(2, '0')).join(':');
}
