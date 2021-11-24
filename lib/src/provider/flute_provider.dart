// ignore_for_file: implementation_imports, subtype_of_sealed_class

import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/common.dart';
import 'package:riverpod/src/value_provider.dart';

import '../../flute.dart';

import './flute_builders.dart';

part 'flute_provider/base.dart';
part 'flute_provider/auto_dispose.dart';

Notifier _listenFluteNotifier<Notifier extends FluteNotifier<State>, State>(
  Notifier notifier,
  ProviderElementBase<State> ref,
) {
  final _removeListener = notifier.listen(ref.setState, callImmediately: false);
  ref.onDispose(_removeListener);
  return notifier;
}

mixin FluteNotifierProviderOverrideMixin<Notifier extends FluteNotifier<State>,
    State> on ProviderBase<State> {
  ProviderBase<Notifier> get notifier;

  @override
  late final List<ProviderOrFamily>? dependencies = [notifier];

  @override
  ProviderBase<FluteNotifier<State>> get originProvider => notifier;

  Override overrideWithValue(Notifier value) => ProviderOverride(
        origin: notifier,
        override: ValueProvider<Notifier>(value),
      );
}
