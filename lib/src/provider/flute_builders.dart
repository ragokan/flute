// ignore_for_file: implementation_imports

import 'index.dart';
import '../../flute.dart';

import 'package:riverpod/riverpod.dart';

import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/internals.dart';

class FluteNotifierProviderBuilder {
  const FluteNotifierProviderBuilder();

  FluteNotifierProvider<Notifier, State>
      call<Notifier extends FluteNotifier<State>?, State>(
    Create<Notifier, FluteNotifierProviderRef<Notifier>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) {
    return FluteNotifierProvider<Notifier, State>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  AutoDisposeFluteNotifierProviderBuilder get autoDispose {
    return const AutoDisposeFluteNotifierProviderBuilder();
  }

  FluteNotifierProviderFamilyBuilder get family =>
      const FluteNotifierProviderFamilyBuilder();
}

class FluteNotifierProviderFamilyBuilder {
  const FluteNotifierProviderFamilyBuilder();

  FluteNotifierProviderFamily<Notifier, State, Arg>
      call<Notifier extends FluteNotifier<State>?, State, Arg>(
    FamilyCreate<Notifier, FluteNotifierProviderRef<Notifier>, Arg> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) {
    return FluteNotifierProviderFamily<Notifier, State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  AutoDisposeFluteNotifierProviderFamilyBuilder get autoDispose {
    return const AutoDisposeFluteNotifierProviderFamilyBuilder();
  }
}

class AutoDisposeFluteNotifierProviderBuilder {
  const AutoDisposeFluteNotifierProviderBuilder();

  AutoDisposeFluteNotifierProvider<Notifier, State>
      call<Notifier extends FluteNotifier<State>?, State>(
    Create<Notifier, AutoDisposeFluteNotifierProviderRef<Notifier>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) =>
          AutoDisposeFluteNotifierProvider<Notifier, State>(
            create,
            name: name,
            dependencies: dependencies,
          );

  AutoDisposeFluteNotifierProviderFamilyBuilder get family {
    return const AutoDisposeFluteNotifierProviderFamilyBuilder();
  }
}

class AutoDisposeFluteNotifierProviderFamilyBuilder {
  const AutoDisposeFluteNotifierProviderFamilyBuilder();

  AutoDisposeFluteNotifierProviderFamily<Notifier, State, Arg>
      call<Notifier extends FluteNotifier<State>?, State, Arg>(
    FamilyCreate<Notifier, AutoDisposeFluteNotifierProviderRef<Notifier>, Arg>
        create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeFluteNotifierProviderFamily<Notifier, State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}
