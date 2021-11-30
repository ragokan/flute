List<T> insert<T>(List<T> list, T item) => [item, ...list];

List<T> add<T>(List<T> list, T item) => [...list, item];

List<T> where<T>(List<T> list, bool Function(T item) test) => [
      for (var item in list)
        if (test(item)) item
    ];

List<T> addAndFilter<T>(List<T> list, item, bool Function(T item) test) => [
      item,
      for (var item in list)
        if (test(item)) item
    ];

List<T> insertAndFilter<T>(List<T> list, item, bool Function(T item) test) => [
      for (var item in list)
        if (test(item)) item,
      item
    ];

T? firstWhereOrNull<T>(List<T> list, bool Function(T item) test) {
  T? result;
  for (var item in list) {
    if (test(item)) {
      return result = item;
    }
  }
  return result;
}

List<T> update<T>(List<T> list, bool Function(T item) test, T updatedItem) => [
      for (var item in list)
        if (test(item)) updatedItem else item
    ];
