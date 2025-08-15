import 'package:flutter/material.dart';

class Snapshot<T> {
  final T? data;
  final ConnectionState connectionState;

  Snapshot({required this.data, required this.connectionState});
}

class SFutureBuilder<T> extends StatefulWidget {
  final Future<T> Function() future;
  final Widget Function(BuildContext context, Snapshot<T> snapshot) builder;
  final T? initialData;

  const SFutureBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.initialData,
  });

  @override
  State<SFutureBuilder<T>> createState() => _SFutureBuilderState<T>();
}

class _SFutureBuilderState<T> extends State<SFutureBuilder<T>> {
  T? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    data = widget.initialData;
    widget.future().then((val) {
      setState(() {
        data = val;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context,
        Snapshot<T>(
            data: data,
            connectionState:
                isLoading ? ConnectionState.waiting : ConnectionState.done));
  }
}
