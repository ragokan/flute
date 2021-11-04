import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

typedef _StatusNotifierCallback<T, X extends ChangeNotifier> = T Function();

mixin StatusNotifierProvider<X extends ChangeNotifier> on ChangeNotifier {
  Status _status = Status.initial;

  Status get status => _status;

  void setStatus(Status newStatus, {bool shouldNotify = true}) {
    if (_status == newStatus) return;
    _status = newStatus;
    if (shouldNotify) {
      notifyListeners();
    }
  }

  T when<T>({
    required _StatusNotifierCallback<T, X> initial,
    required _StatusNotifierCallback<T, X> loading,
    required _StatusNotifierCallback<T, X> done,
    required _StatusNotifierCallback<T, X> error,
  }) {
    switch (_status) {
      case Status.initial:
        return initial();
      case Status.loading:
        return loading();
      case Status.done:
        return done();
      case Status.error:
        return error();
      default:
        return initial();
    }
  }
}
