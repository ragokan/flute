// ignore_for_file: subtype_of_sealed_class
part of '../flute_provider.dart';

abstract class AutoDisposeFluteNotifierProviderRef<Notifier, State>
    implements AutoDisposeRef {
  Notifier get notifier;
}

@sealed
class AutoDisposeFluteNotifierProvider<Notifier extends FluteNotifier<State>?,
        State> extends AutoDisposeProviderBase<Notifier>
    with
        FluteNotifierProviderOverrideMixin<Notifier, State>,
        OverrideWithProviderMixin<Notifier,
            AutoDisposeFluteNotifierProvider<Notifier, State>> {
  AutoDisposeFluteNotifierProvider(
    Create<Notifier, AutoDisposeFluteNotifierProviderRef<Notifier, State>>
        create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family? from,
    Object? argument,
  })  : notifier = _AutoDisposeNotifierProvider<Notifier, State>(
          create,
          name: modifierName(name, 'notifier'),
          dependencies: dependencies,
          from: from,
          argument: argument,
        ),
        super(name: name, from: from, argument: argument);

  static const family = AutoDisposeFluteNotifierProviderFamilyBuilder();

  @override
  ProviderBase<Notifier> get originProvider => notifier;

  @override
  final AutoDisposeProviderBase<Notifier> notifier;

  @override
  Notifier create(AutoDisposeProviderElementBase<Notifier> ref) {
    final notifier = ref.watch<Notifier>(this.notifier);
    _listenNotifier(notifier, ref);
    return notifier;
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;

  @override
  AutoDisposeProviderElement<Notifier> createElement() =>
      AutoDisposeProviderElement(this);
}

class _AutoDisposeNotifierProvider<Notifier extends FluteNotifier<State>?,
    State> extends AutoDisposeProviderBase<Notifier> {
  _AutoDisposeNotifierProvider(
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

  final Create<Notifier, AutoDisposeFluteNotifierProviderRef<Notifier, State>>
      _create;

  @override
  Notifier create(
    covariant AutoDisposeFluteNotifierProviderRef<Notifier, State> ref,
  ) {
    final notifier = _create(ref);
    if (notifier != null) ref.onDispose(notifier.dispose);

    return notifier;
  }

  @override
  _AutoDisposeNotifierProviderElement<Notifier, State> createElement() {
    return _AutoDisposeNotifierProviderElement<Notifier, State>(this);
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;
}

class _AutoDisposeNotifierProviderElement<
        Notifier extends FluteNotifier<State>?,
        State> extends AutoDisposeProviderElementBase<Notifier>
    implements AutoDisposeFluteNotifierProviderRef<Notifier, State> {
  _AutoDisposeNotifierProviderElement(
      _AutoDisposeNotifierProvider<Notifier, State> provider)
      : super(provider);

  @override
  Notifier get notifier => requireState;
}

@sealed
class AutoDisposeFluteNotifierProviderFamily<
        Notifier extends FluteNotifier<State>?, State, Arg>
    extends Family<Notifier, Arg,
        AutoDisposeFluteNotifierProvider<Notifier, State>> {
  AutoDisposeFluteNotifierProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<Notifier,
      AutoDisposeFluteNotifierProviderRef<Notifier, State>, Arg> _create;

  @override
  AutoDisposeFluteNotifierProvider<Notifier, State> create(Arg argument) =>
      AutoDisposeFluteNotifierProvider<Notifier, State>(
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
    AutoDisposeFluteNotifierProvider<Notifier, State> Function(Arg argument)
        override,
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
