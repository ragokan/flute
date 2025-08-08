import 'package:flutter_test/flutter_test.dart';
import 'package:flute/flute.dart';

void main() {
  group('Either', () {
    test('Left holds value and reports correctly', () {
      const either = Left<String, int>('error');
      expect(either.isLeft, isTrue);
      expect(either.isRight, isFalse);
      expect(either.left, 'error');
      expect(() => either.right, throwsA(isA<TypeError>()));
      final folded = either.fold((l) => 'L:$l', (r) => 'R:$r');
      expect(folded, 'L:error');
    });

    test('Right holds value and reports correctly', () {
      const either = Right<String, int>(42);
      expect(either.isLeft, isFalse);
      expect(either.isRight, isTrue);
      expect(either.right, 42);
      expect(() => either.left, throwsA(isA<TypeError>()));
      final folded = either.fold((l) => 'L:$l', (r) => 'R:$r');
      expect(folded, 'R:42');
    });
  });
}