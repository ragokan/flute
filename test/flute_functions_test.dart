import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flute/flute.dart';

void main() {
  test('setTimeout invokes after duration', () {
    fakeAsync((fa) {
      var called = false;
      Flute.setTimeout(const Duration(milliseconds: 100), () {
        called = true;
      });
      expect(called, isFalse);
      fa.elapse(const Duration(milliseconds: 100));
      expect(called, isTrue);
    });
  });

  test('setInterval invokes repeatedly and can be cancelled', () {
    fakeAsync((fa) {
      var calls = 0;
      final cancel = Flute.setInterval(const Duration(milliseconds: 100), () {
        calls++;
      });

      fa.elapse(const Duration(milliseconds: 250));
      expect(calls, 2);

      cancel();
      fa.elapse(const Duration(milliseconds: 300));
      expect(calls, 2);
    });
  });

  testWidgets('addPostFrameCallback executes on next frame', (tester) async {
    var called = false;
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    Flute.addPostFrameCallback(() {
      called = true;
    });
    expect(called, isFalse);
    await tester.pump();
    expect(called, isTrue);
  });
}