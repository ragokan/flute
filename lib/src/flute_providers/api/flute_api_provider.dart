import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../flute.dart';

class FluteApiProvider {
  final String? _endPoint;

  final void Function(DioError error, ErrorInterceptorHandler handler)?
      _onError;

  const FluteApiProvider([this._endPoint, this._onError]);

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
    if (_onError != null) {
      _dio.interceptors.add(InterceptorsWrapper(onError: _onError));
    }

    final _response = await _dio.fetch<T>(
      RequestOptions(
        method: method,
        path: path,
        data: body,
        queryParameters: queryParameters,
        headers: {'Authorization': FluteStorage.read(kTokenKey)},
        baseUrl: _endPoint,
      ),
    );

    _dio.close();
    return _response;
  }
}
