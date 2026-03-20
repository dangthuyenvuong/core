class QueryController<T> {
  bool loading = true;
  T? _data;
  Future<T> Function() fetch;
  void Function(void Function() fn) setState;
  bool init = false;

  QueryController({
    required this.fetch,
    required this.setState,
    this.init = false,
    T? initialData,
  }) {
    _data = initialData;
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

class QueryListController<T> extends QueryController<List<T>> {
  QueryListController(
      {required super.fetch,
      required super.setState,
      super.init,
      super.initialData});


  void add(T data) {
    if (_data is List) {
      (_data as List).add(data);
      setState(() {});
    }
  }

  void remove(T data) {
    if (_data is List) {
      (_data as List).remove(data);
      setState(() {});
    }
  }
}
