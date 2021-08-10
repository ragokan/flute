import '../../flute.dart';

/// The base of [Flute] dependency injection.
///
/// We just mix this class with the [Flute], then we can use it.
///
/// It is a totally undependent mixin, no override or anything required.
mixin FluteDependencyInjection {
  /// A [Set] of injected [_dependencies].
  /// It is set because we don't want to have duplicates.
  final Set _dependencies = <dynamic>{};

  /// Injects the dependency to the [Flute], so that you can use it
  /// with [use] function.
  ///
  /// It also returns the dependency, so you can directly use it.
  ///
  /// ```dart
  /// final counter = Flute.inject(Counter());
  /// counter.count++;
  ///
  /// // or
  /// Flute.inject(Counter());
  /// Flute.use<Counter>().count++;
  /// ```
  T inject<T>(T dependency) {
    _dependencies.add(dependency);
    if (dependency is FluteController) {
      // We call the onInject method if the controller is [FluteController].
      dependency.onInject();
    }
    return dependency;
  }

  /// Removes the dependency that is injected before with [inject] function.
  ///
  /// ```dart
  /// Flute.eject<Counter>();
  /// ```
  ///
  /// Good for memory, if you don't use dependency, just kill it :D
  /// After you [eject], you won't be able to [use] it anymore.
  void eject<T>() => _dependencies.removeWhere((dependency) => dependency is T);

  /// Returns the dependency that is injected before with [inject] function.
  ///
  /// ```dart
  /// Flute.use<Counter>().count++;
  /// ```
  ///
  /// If you are going to use [use] function multiple times in your code,
  /// it is best to assign it to a variable.
  /// ```dart
  /// final counter = Flute.use<Counter>();
  /// counter.count++;
  /// counter.count--;
  /// ```
  T use<T>() => _dependencies.firstWhere((dependency) => dependency is T,
      orElse: () => throw Exception('''
      You have to inject a variable to use it with [use] function.
      Please read the documents or hover over the [use] function to see its usage.
      Note that you can't use type [dynamic] with [use] function.
        '''));
}
