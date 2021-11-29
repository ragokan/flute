import 'package:flutter/material.dart';

class DataProvider<Data> extends InheritedWidget {
  final Data data;

  const DataProvider({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant DataProvider<State> oldWidget) =>
      data != oldWidget.data;

  static Data of<Data>(BuildContext context) {
    final DataProvider? dataProvider =
        context.dependOnInheritedWidgetOfExactType<DataProvider<Data>>();

    assert(dataProvider != null,
        'You have to provide the data with DataProvider to your childs');
    return dataProvider!.data;
  }
}

extension DataExtension on BuildContext {
  Data data<Data>() => DataProvider.of<Data>(this);
}
