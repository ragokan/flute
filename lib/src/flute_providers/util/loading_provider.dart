import 'package:flute/flute.dart';

mixin LoadingProvider on FluteProviderBase {
  bool get isLoading => _isLoading ?? false;
  bool? _isLoading;

  void setIsLoading(bool? to) {
    if (_isLoading == to) return;
    _isLoading = to;
    notifyListeners();
  }
}
