import 'package:flute/flute.dart';
import 'package:flutter_test/flutter_test.dart';

class Counter {
  int count = 0;
}

void main() {
  /// Firstly inject the counter
  /// Then, you can use it by [use] function anywhere!
  Flute.inject(Counter());
  doTests();
}

void doTests() {
  test('dependency tests', () {
    /// Now, we can use it.
    final counter = Flute.use<Counter>();

    expect(counter.count, 0);
    expect(counter.count, Flute.use<Counter>().count);

    counter.count++;

    expect(counter.count, 1);
    expect(counter.count, Flute.use<Counter>().count);

    counter.count--;

    expect(counter.count, 0);
    expect(counter.count, Flute.use<Counter>().count);
  });
}
