import 'package:flutter/material.dart';

mixin LoadingProvider on ChangeNotifier {
  bool get isLoading => _isLoading ?? false;
  bool? _isLoading;

  void setIsLoading(bool? to) {
    if (_isLoading == to) return;
    _isLoading = to;
    notifyListeners();
  }
}
