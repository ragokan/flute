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

Notifier _listenNotifier<Notifier extends FluteNotifier<State>, State>(
  Notifier notifier,
  ProviderElementBase<Notifier> ref,
) {
  final _listener = notifier.stream.listen((_) => ref.setState(notifier));
  ref.onDispose(_listener.cancel);
  return notifier;
}

mixin FluteNotifierProviderOverrideMixin<Notifier extends FluteNotifier<State>,
    State> on ProviderBase<Notifier> {
  ProviderBase<Notifier> get notifier;

  @override
  late final List<ProviderOrFamily>? dependencies = [notifier];

  Override overrideWithValue(Notifier value) => ProviderOverride(
        origin: notifier,
        override: ValueProvider<Notifier>(value),
      );
}
