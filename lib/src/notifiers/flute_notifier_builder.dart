import 'package:flutter/material.dart';
import 'package:flute/flute.dart';

typedef _FluteBuilderCallback<State> = Widget Function(
    BuildContext context, State state);
typedef _FilterCallback<State> = Object? Function(State state);
typedef _ListenerCallback<State> = void Function(
    BuildContext context, State state);

class FluteNotifierBuilder<Notifier extends FluteNotifier<State>, State>
    extends StatefulWidget {
  const FluteNotifierBuilder({
    Key? key,
    required this.notifier,
    required this.builder,
    this.filter,
    this.listener,
  }) : super(key: key);

  final Notifier notifier;

  final _FluteBuilderCallback<State> builder;

  final _FilterCallback<State>? filter;

  final _ListenerCallback<State>? listener;

  Object? _callFilter() {
    if (filter == null) return null;
    return filter!(notifier.state);
  }

  Widget _callBuilder(BuildContext context) => builder(context, notifier.state);

  @override
  _FluteNotifierBuilderState<Notifier, State> createState() =>
      _FluteNotifierBuilderState<Notifier, State>();
}

class _FluteNotifierBuilderState<
        BuilderNotifier extends FluteNotifier<BuilderState>, BuilderState>
    extends State<FluteNotifierBuilder<BuilderNotifier, BuilderState>> {
  void Function()? _removeListener;
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

    if (cachedState != _result) {
      cachedState = _result;
      _update();
    }
  }

  void _update() {
    widget.listener?.call(context, widget.notifier.state);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    cachedState = widget._callFilter();
    _listen();
  }

  @override
  void didUpdateWidget(
      covariant FluteNotifierBuilder<BuilderNotifier, BuilderState> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notifier != oldWidget.notifier) {
      _listen();
    }
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget._callBuilder(context);
}
