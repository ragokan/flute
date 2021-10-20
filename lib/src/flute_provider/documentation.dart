/// {@template flute_provider}
///```dart
///  class CounterProvider extends FluteProvider<int>{
///   CounterProvider() : super(0); // 0 is state
///
///   void increment() => set(state +1);
///
///   void decrement() => update((state) => state -1);
/// }
///
///  final counterProvider = CounterProvider();
///  // Or
///  FluteProviderWidget(
///    create : (context) => CounterProvider(),
///  )
/// ```
/// {@endtemplate}