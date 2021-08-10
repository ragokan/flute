import 'package:flutter/material.dart';
import '../../flute.dart';

import '../typedefs/callback_types.dart';
import 'controller.dart';
import 'modules/communication.dart';

/// [FluteBuilder] is the lite version of [FluteBuilder]
///
/// Example
///
/// ```dart
/// FluteBuilder(
/// controller: counterController,
/// builder: () => Text('${counterController.count}',
///   ),
/// );
/// ```
class FluteBuilder<T extends FluteController> extends StatefulWidget {
  /// [controller] should be a class that extends or mixs [FluteController].
  final T controller;

  /// Builder callback is called whenever your state changes.
  ///
  /// You have to return a Widget that you want to re-build on state changes.
  final BuilderCallback builder;

  /// Filter of builder
  final FilterCallback<T>? filter;

  /// Filter of builder
  Object? callFilter() => filter?.call(controller);

  /// FluteBuilder is the way to use FluteController.
  ///
  /// Its main advantage is having a builder that just re-renders itself on
  /// state change which means that your other widgets that doesn't depend
  /// on your state won't re-build on update.
  ///
  /// Usage is simple, just create an [FluteController] just like it is declared
  /// in its documentation, then show that controller when you call the builder.
  ///
  /// Example
  ///
  ///```dart
  /// FluteBuilder(
  ///        controller: counterController,
  ///        builder: () => Text('Current count is ${counterController.count}'),
  ///        ),
  /// ```
  ///
  /// Example With Multiple Controllers
  ///
  ///```dart
  /// FluteBuilder(
  ///        controller: counterController,
  ///        otherControllers: [ageController, userController /* and other controllers */],
  ///        builder: () => Text('Current count is ${counterController.count}'),
  ///        ),
  /// ```
  const FluteBuilder({
    Key? key,
    required this.controller,
    required this.builder,
    this.filter,
  }) : super(key: key);

  @override
  _FluteBuilderState createState() => _FluteBuilderState<T>();
}

// check if mounted or not
class _FluteBuilderState<T extends FluteController>
    extends State<FluteBuilder> {
  _FluteBuilderState();

  /// The unmount functions of controllers. At first, we watch and
  /// we add unmount functions, then we do a loop and remove all
  /// of the watchers.
  Function? _unmountFunction;

  bool _shouldUpdate = false;

  Object? _filter;

  void _updateState() {
    if (!_shouldUpdate || !mounted) return;

    if (widget.callFilter() == null) {
      setState(() {});
    } else {
      var _currentFilter = widget.callFilter();
      if (_currentFilter != _filter) {
        _filter = _currentFilter;
        setState(() {});
      }
    }
  }

  @protected
  @override
  void initState() {
    super.initState();
    widget.controller.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _shouldUpdate = true;
    });

    /// Here, we mount the [watch] function to re-render state on changes.
    _unmountFunction =
        controllerXviewStream.watch(widget.controller, _updateState);

    _filter = widget.callFilter();
  }

  @protected
  @override
  void dispose() {
    /// On dispose, we would like to unmount the watchers, so that
    /// we don't leak the memory and the [notify] function don't
    /// call the [watch] function.
    _unmountFunction?.call();
    _shouldUpdate = false;
    _filter = null;

    super.dispose();
  }

  @override
  Widget build(_) => widget.builder();
}
