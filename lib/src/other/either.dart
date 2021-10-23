// I got it from 'dartz' package, just changed it a little bit and made it smaller.

abstract class Either<L, R> {
  const Either();

  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight);

  bool get isLeft => fold((_) => true, (_) => false);

  bool get isRight => fold((_) => false, (_) => true);

  L get left => (this as L);

  R get right => (this as R);
}

class Left<L, R> extends Either<L, R> {
  final L _l;
  const Left(this._l);

  L get value => _l;

  @override
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) => ifLeft(_l);
}

class Right<L, R> extends Either<L, R> {
  final R _r;
  const Right(this._r);

  R get value => _r;

  @override
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) => ifRight(_r);
}
