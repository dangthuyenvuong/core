import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class QueryController<T> {
  bool loading = false;
  T? _data;
  Future<T> Function() fetch;
  void Function(void Function() fn) setState;
  bool init = false;

  QueryController({
    required this.fetch,
    required this.setState,
    this.init = false,
  }) {
    if (this.init) {
      call();
    }
  }

  Future<T> call() async {
    setState(() {
      loading = true;
    });
    final temp = await fetch();
    setState(() {
      _data = temp;
      loading = false;
    });
    return data!;
  }

  T? get data => _data;
}
