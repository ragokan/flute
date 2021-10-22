import 'package:flute/flute.dart';

mixin LoadingProvider on FluteProviderBase {
  bool get isLoading => _isLoading ?? false;
  bool? _isLoading;

  void setIsLoading(bool? to) {
    _isLoading = to;
    notifyListeners();
  }
}
