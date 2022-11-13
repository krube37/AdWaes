extension ListExtension on List<dynamic> {
  dynamic firstWhereOrNull(bool Function(dynamic element) test) {
    for (dynamic element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
