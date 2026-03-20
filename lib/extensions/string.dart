extension StringX on String {
  double doubleSafeParse() {
    String normalized = toString().replaceAll(",", ".");
    return double.tryParse(normalized) ?? 0;
  }

  int intSafeParse() {
    return int.tryParse(toString()) ?? 0;
  }

  String lastN(int count) {
    if (count >= length) return this;
    return substring(length - count);
  }
}
