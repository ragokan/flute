import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../flute.dart';

typedef OnError = void Function(
    DioError error, ErrorInterceptorHandler handler);

class FluteApiService {
  final String? _endPoint;

  const FluteApiService([this._endPoint]);

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    OnError? onError,
  }) async =>
      await _baseRequest(
        'GET',
        path,
        queryParameters: queryParameters,
        body: body,
        onError: onError,
      );

  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    OnError? onError,
  }) async =>
      await _baseRequest(
        'POST',
        path,
        queryParameters: queryParameters,
        body: body,
        onError: onError,
      );

  Future<Response<T>> patch<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    OnError? onError,
  }) async =>
      await _baseRequest(
        'PATCH',
        path,
        queryParameters: queryParameters,
        body: body,
        onError: onError,
      );

  Future<Response<T>> put<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    OnError? onError,
  }) async =>
      await _baseRequest(
        'PUT',
        path,
        queryParameters: queryParameters,
        body: body,
        onError: onError,
      );

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    OnError? onError,
  }) async =>
      _baseRequest(
        'DELETE',
        path,
        queryParameters: queryParameters,
        body: body,
        onError: onError,
      );

  @protected
  Future<Response<T>> _baseRequest<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    OnError? onError,
  }) async {
    final _dio = Dio();
    if (onError != null) {
      _dio.interceptors.add(InterceptorsWrapper(onError: onError));
    }

    final _response = await _dio.fetch<T>(
      RequestOptions(
        method: method,
        path: path,
        data: body,
        queryParameters: queryParameters,
        headers: {'Authorization': FluteStorage.get(kTokenKey)},
        baseUrl: _endPoint,
      ),
    );

    _dio.close();
    return _response;
  }
}