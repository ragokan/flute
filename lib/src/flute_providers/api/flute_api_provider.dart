import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../flute.dart';

// Response model?
// Belki web api?
class FluteApiProvider {
  String? _token;

  final String _endPoint;

  late final VoidFunction _removeListener;

  final void Function(Object error)? onError;

  FluteApiProvider(
    this._endPoint, {
    this.onError,
  }) {
    _removeListener =
        FluteStorage.listen<String>(kTokenKey, (key) => _token = key);
  }

  void dispose() {
    _removeListener();
    _token = null;
  }

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async =>
      await _baseRequest('GET', path,
          queryParameters: queryParameters, body: body);

  Future<T?> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _baseRequest('POST', path,
          queryParameters: queryParameters, body: body);

  Future<T?> patch<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _baseRequest('PATCH', path,
          queryParameters: queryParameters, body: body);

  Future<T?> put<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await _baseRequest('PUT', path,
          queryParameters: queryParameters, body: body);

  Future<T?> delete<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async =>
      _baseRequest('DELETE', path,
          queryParameters: queryParameters, body: body);

  Future<T?> _baseRequest<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    try {
      final _client = HttpClient();
      final request = await _client.openUrl(
        method,
        Uri(
          scheme: 'https',
          host: _endPoint,
          path: path,
          queryParameters: queryParameters,
        ),
      );

      request.headers.set(
          HttpHeaders.contentTypeHeader, 'application/json; charset=UTF-8');

      if (_token != null) {
        request.headers.set('Authorization', _token!);
      }

      if (body != null) {
        request.write(json.encode(body));
      }

      final val = await request.close();
      final response =
          await val.transform(utf8.decoder).transform(json.decoder).first;

      _client.close();
      return response as T;
    } catch (error) {
      debugPrint(error.toString());
      onError?.call(error);
    }
  }
}
