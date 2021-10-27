import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../flute.dart';

abstract class FluteApiProvider {
  String? _token;

  final String _endPoint;

  late final VoidFunction _removeListener;

  @protected
  void onError(DioError error, ErrorInterceptorHandler handler) =>
      handler.next(error);

  FluteApiProvider(this._endPoint) {
    _removeListener =
        FluteStorage.listen<String>(kTokenKey, (key) => _token = key);
  }

  void dispose() {
    _removeListener();
    _token = null;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async =>
      await _baseRequest('GET', path,
          queryParameters: queryParameters, body: body);

  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _baseRequest('POST', path,
          queryParameters: queryParameters, body: body);

  Future<Response<T>> patch<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _baseRequest('PATCH', path,
          queryParameters: queryParameters, body: body);

  Future<Response<T>> put<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _baseRequest('PUT', path,
          queryParameters: queryParameters, body: body);

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async =>
      _baseRequest('DELETE', path,
          queryParameters: queryParameters, body: body);

  @protected
  Future<Response<T>> _baseRequest<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final _dio = Dio();

    _dio.interceptors.add(InterceptorsWrapper(onError: onError));

    final _response = await _dio.fetch<T>(
      RequestOptions(
        method: method,
        path: path,
        data: body,
        queryParameters: queryParameters,
        headers: {'Authorization': _token},
        baseUrl: _endPoint,
      ),
    );

    _dio.close();
    return _response;
  }
}
