import 'package:dio/dio.dart';
import '../../flute.dart';

abstract class FluteApiProvider {
  String? token;
  String endPoint;

  void Function()? dispose;

  FluteApiProvider({
    this.token,
    required this.endPoint,
  }) {
    dispose = FluteStorage.listen<String>(kTokenKey, (key) => token = key);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      await _getDio().get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      await _getDio().post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      await _getDio().patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      await _getDio().put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      await _getDio().delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  void onError(DioError error, ErrorInterceptorHandler handler) {
    handler.next(error);
  }

  Dio _getDio() {
    final _dio = Dio();

    if (token != null) _dio.options.headers['Authorization'] = token;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: onError,
      ),
    );

    return _dio;
  }
}
