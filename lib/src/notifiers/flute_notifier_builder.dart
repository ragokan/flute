import 'package:flutter/material.dart';
import 'package:flute/flute.dart';

typedef _FluteBuilderCallback<State> = Widget Function(State state);
typedef _FilterCallback<State> = Partial Function<Partial extends Object>(
    State state);

class FluteNotifierBuilder<State extends FluteNotifier<State>>
    extends StatefulWidget {
  const FluteNotifierBuilder({
    Key? key,
    required this.notifier,
    required this.builder,
    this.filter,
  }) : super(key: key);

  final FluteNotifier<State> notifier;

  final _FluteBuilderCallback<State> builder;

  final _FilterCallback<State>? filter;

  Partial? _callFilter<Partial>() {
    if (filter == null) return null;
    return filter!(notifier.state);
  }

  @override
  _FluteNotifierBuilderState<State> createState() =>
      _FluteNotifierBuilderState<State>();
}

class _FluteNotifierBuilderState<
        BuilderState extends FluteNotifier<BuilderState>>
    extends State<FluteNotifierBuilder<BuilderState>> {
  VoidFunction? _removeListener;
  Object? cachedState;

  void _listen() {
    _removeListener?.call();
    _removeListener = widget.notifier.listen(
      (_) => _listener(),
      callImmediately: false,
    );
  }

  void _listener() {
    if (!mounted) return;

    if (widget.filter == null) {
      return _update();
    }

    final _result = widget.filter!(widget.notifier.state);

    if (!identical(cachedState, _result) && cachedState != _result) {
      cachedState = _result;
      _update();
    }
  }

  void _update() => setState(() {});

  @override
  void initState() {
    super.initState();
    cachedState = widget._callFilter();
    _listen();
  }

  @override
  void didUpdateWidget(covariant FluteNotifierBuilder<BuilderState> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.notifier, oldWidget.notifier) &&
        widget.notifier != oldWidget.notifier) {
      _listen();
    }
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(widget.notifier.state);
}
