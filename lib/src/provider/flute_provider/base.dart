// ignore_for_file: subtype_of_sealed_class

part of '../flute_provider.dart';

abstract class FluteNotifierProviderRef<Notifier extends FluteNotifier<State>?,
    State> implements Ref {
  Notifier get notifier;
}

@sealed
class FluteNotifierProvider<Notifier extends FluteNotifier<State>?, State>
    extends AlwaysAliveProviderBase<Notifier>
    with
        FluteNotifierProviderOverrideMixin<Notifier, State>,
        OverrideWithProviderMixin<Notifier,
            FluteNotifierProvider<Notifier, State>> {
  FluteNotifierProvider(
    Create<Notifier, FluteNotifierProviderRef<Notifier, State>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family? from,
    Object? argument,
  })  : notifier = _NotifierProvider<Notifier, State>(
          create,
          name: name,
          dependencies: dependencies,
          from: from,
          argument: argument,
        ),
        super(name: name, from: from, argument: argument);

  static const family = FluteNotifierProviderFamilyBuilder();

  static const autoDispose = AutoDisposeFluteNotifierProviderBuilder();

  @override
  ProviderBase<Notifier> get originProvider => notifier;

  @override
  final AlwaysAliveProviderBase<Notifier> notifier;

  @override
  Notifier create(ProviderElementBase<Notifier> ref) {
    final notifier = ref.watch<Notifier>(this.notifier);
    _listenNotifier(notifier, ref);
    return notifier;
  }

  @override
  ProviderElement<Notifier> createElement() {
    return ProviderElement(this);
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;
}

class _NotifierProvider<Notifier extends FluteNotifier<State>?, State>
    extends AlwaysAliveProviderBase<Notifier> {
  _NotifierProvider(
    this._create, {
    required String? name,
    required this.dependencies,
    Family? from,
    Object? argument,
  }) : super(
          name: modifierName(name, 'notifier'),
          from: from,
          argument: argument,
        );

  @override
  final List<ProviderOrFamily>? dependencies;

  final Create<Notifier, FluteNotifierProviderRef<Notifier, State>> _create;

  @override
  Notifier create(covariant FluteNotifierProviderRef<Notifier, State> ref) {
    final notifier = _create(ref);
    if (notifier != null) ref.onDispose(notifier.dispose);

    return notifier;
  }

  @override
  _NotifierProviderElement<Notifier, State> createElement() {
    return _NotifierProviderElement<Notifier, State>(this);
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;
}

class _NotifierProviderElement<Notifier extends FluteNotifier<State>?, State>
    extends ProviderElementBase<Notifier>
    implements FluteNotifierProviderRef<Notifier, State> {
  _NotifierProviderElement(_NotifierProvider<Notifier, State> provider)
      : super(provider);

  @override
  Notifier get notifier => requireState;
}

@sealed
class FluteNotifierProviderFamily<Notifier extends FluteNotifier<State>?, State,
    Arg> extends Family<Notifier, Arg, FluteNotifierProvider<Notifier, State>> {
  FluteNotifierProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<Notifier, FluteNotifierProviderRef<Notifier, State>, Arg>
      _create;

  @override
  FluteNotifierProvider<Notifier, State> create(Arg argument) =>
      FluteNotifierProvider<Notifier, State>(
        (ref) => _create(ref, argument),
        name: name,
        from: this,
        argument: argument,
      );

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);

    setup(origin: provider, override: provider);
    setup(origin: provider.notifier, override: provider.notifier);
  }

  Override overrideWithProvider(
    FluteNotifierProvider<Notifier, State> Function(Arg argument) override,
  ) =>
      FamilyOverride<Arg>(
        this,
        (arg, setup) {
          final provider = call(arg);

          setup(origin: provider.notifier, override: override(arg).notifier);
          setup(origin: provider, override: provider);
        },
      );
}
