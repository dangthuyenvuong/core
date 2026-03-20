extension SetX<T> on Set<T> {
  void toggle(T item) {
    if (contains(item)) {
      remove(item);
    } else {
      add(item);
    }
  }
}