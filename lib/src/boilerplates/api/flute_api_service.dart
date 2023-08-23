import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../flute.dart';

typedef OnError = void Function(
    DioException exception, ErrorInterceptorHandler handler);

typedef GetHeaders = Map<String, String> Function();

@immutable
class FluteApiService {
  final String? _endPoint;

  final GetHeaders? getHeaders;

  const FluteApiService({
    this.getHeaders,
    String? endPoint,
  }) : _endPoint = endPoint;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    OnError? onError,
    ResponseType? responseType,
  }) async =>
      await _baseRequest(
        'GET',
        path,
        queryParameters: queryParameters,
        body: body,
        onError: onError,
        responseType: responseType,
      );

  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    OnError? onError,
    ResponseType? responseType,
  }) async =>
      await _baseRequest(
        'POST',
        path,
        queryParameters: queryParameters,
        body: body,
        onError: onError,
        responseType: responseType,
      );

  Future<Response<T>> patch<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    OnError? onError,
    ResponseType? responseType,
  }) async =>
      await _baseRequest(
        'PATCH',
        path,
        queryParameters: queryParameters,
        body: body,
        onError: onError,
        responseType: responseType,
      );

  Future<Response<T>> put<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    OnError? onError,
    ResponseType? responseType,
  }) async =>
      await _baseRequest(
        'PUT',
        path,
        queryParameters: queryParameters,
        body: body,
        onError: onError,
        responseType: responseType,
      );

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    OnError? onError,
    ResponseType? responseType,
  }) async =>
      _baseRequest(
        'DELETE',
        path,
        queryParameters: queryParameters,
        body: body,
        onError: onError,
        responseType: responseType,
      );

  @protected
  Future<Response<T>> _baseRequest<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    OnError? onError,
    ResponseType? responseType,
  }) async {
    final _dio = Dio();
    if (onError != null) {
      _dio.interceptors.add(InterceptorsWrapper(onError: onError));
    }

    final headers = getHeaders?.call() ?? {};
    final authToken = FluteStorage.get<String>(kTokenKey);
    if (authToken != null) {
      headers['Authorization'] = authToken;
    }

    final _response = await _dio.fetch<T>(
      RequestOptions(
        method: method,
        path: path,
        data: body,
        queryParameters: queryParameters,
        headers: headers,
        baseUrl: _endPoint,
        responseType: responseType,
      ),
    );

    _dio.close();
    return _response;
  }
}
