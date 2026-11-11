import 'package:dio/dio.dart';

import 'api_config.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._();

  static String? token;

  static void Function()? onUnauthorized;

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (_) => true,
    ),
  );

  static Options get _opsi =>
      Options(headers: {if (token != null) 'Authorization': 'Bearer $token'});

  static Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _kirim(() => _dio.get(path, queryParameters: query, options: _opsi));

  static Future<dynamic> post(String path, {Object? body}) =>
      _kirim(() => _dio.post(path, data: body ?? {}, options: _opsi));

  static Future<dynamic> put(String path, {Object? body}) =>
      _kirim(() => _dio.put(path, data: body ?? {}, options: _opsi));

  static Future<dynamic> patch(String path, {Object? body}) =>
      _kirim(() => _dio.patch(path, data: body ?? {}, options: _opsi));

  static Future<dynamic> postForm(String path, FormData data) => _kirim(
    () => _dio.post(
      path,
      data: data,
      options: _opsi.copyWith(
        contentType: Headers.multipartFormDataContentType,
      ),
    ),
  );

  static Future<dynamic> delete(String path) =>
      _kirim(() => _dio.delete(path, options: _opsi));

  static Future<dynamic> _kirim(
    Future<Response<dynamic>> Function() req,
  ) async {
    try {
      final res = await req();
      return _proses(res);
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw ApiException('Koneksi ke server terlalu lama');
        default:
          throw ApiException('Tidak bisa terhubung ke server');
      }
    } catch (e) {
      throw ApiException('Terjadi kesalahan: $e');
    }
  }

  static dynamic _proses(Response<dynamic> res) {
    final code = res.statusCode ?? 0;
    final json = res.data;

    if (code >= 200 && code < 300) return json;

    if (code == 401) {
      token = null;
      onUnauthorized?.call();
    }

    String pesan = 'Error $code';
    if (json is Map) {
      if (json['message'] != null) pesan = json['message'].toString();
      if (json['errors'] is Map && (json['errors'] as Map).isNotEmpty) {
        final first = (json['errors'] as Map).values.first;
        if (first is List && first.isNotEmpty) pesan = first.first.toString();
      }
    }
    throw ApiException(pesan, statusCode: code);
  }
}
