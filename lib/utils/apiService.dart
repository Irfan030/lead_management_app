import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:leads_management_app/constant.dart';

import 'header_provider.dart'; // Your header class

class ApiService {
  static String baseUrl = AppData.apiBaseUrl;
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: HeaderProvider.headers,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    contentType: 'application/json',
    responseType: ResponseType.json,
  ));

  // Log request
  static void _logRequest(String method, String url, dynamic data) {
    print('➡️ $method: $url');
    if (data != null) print('📦 Body: $data');
  }

  // Log response
  static void _logResponse(Response response) {
    print('⬅️ Response [${response.statusCode}]: ${response.data}');
  }

  static Future<dynamic> login(
      String endpoint, Map<String, dynamic> data) async {
    final fullUrl = '$baseUrl$endpoint';
    // _logRequest('GET', fullUrl, data);
    try {
      final response = await _dio.get(
        endpoint,
        data: data,
        options: Options(
          headers: {
            'db': AppData.dbName,
            'login': data['email'],
            'password': data['password'],
          },
        ),
      );
      // _logResponse(response);
      // return response;
      if (response.data.toString().contains('<html>')) {
        return {'body': response.data};
      }
      return {
        'body': jsonDecode(response.data),
        'headers': response.headers.map,
        'statusCode': response.statusCode,
      };
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  static Future<dynamic> get(String endpoint, Map<String, dynamic> data) async {
    final fullUrl = '$baseUrl$endpoint';
    // _logRequest('GET', fullUrl, data);
    try {
      final response = await _dio.get(endpoint, data: data);
      // _logResponse(response);
      // return response;
      if (response.data.toString().contains('<html>')) {
        return {'body': response.data};
      }
      return {
        'body': jsonDecode(response.data),
        'headers': response.headers.map,
        'statusCode': response.statusCode,
      };
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> data) async {
    final fullUrl = '$baseUrl$endpoint';
    // _logRequest('POST', fullUrl, data);
    try {
      final response = await _dio.post(endpoint, data: data);
      if (response.data.toString().contains('<html>')) {
        return {'body': response.data};
      }
      return {
        'body': jsonDecode(response.data),
        'headers': response.headers.map,
        'statusCode': response.statusCode,
      };
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final fullUrl = '$baseUrl$endpoint';
    // _logRequest('PUT', fullUrl, data);
    try {
      final response = await _dio.put(endpoint, data: data);
      // _logResponse(response);
      // return response.data;
      if (response.data.toString().contains('<html>')) {
        return {'body': response.data};
      }
      return {
        'body': jsonDecode(response.data),
        'headers': response.headers.map,
        'statusCode': response.statusCode,
      };
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  static Future<dynamic> delete(String endpoint) async {
    final fullUrl = '$baseUrl$endpoint';
    try {
      final response = await _dio.delete(fullUrl);
      final data = response.data;

      // Handle HTML error responses gracefully
      if (data.toString().contains('<html>')) {
        return {
          'body': {
            'error': 'Unexpected HTML response',
            'content': data.toString()
          },
          'statusCode': response.statusCode ?? 500,
        };
      }

      final body = data is String ? jsonDecode(data) : data;

      return {
        'body': body,
        'headers': response.headers.map,
        'statusCode': response.statusCode,
      };
    } on DioException catch (e) {
      return {
        'body': {'error': e.message},
        'statusCode': e.response?.statusCode ?? 500,
      };
    } catch (e) {
      // Handle jsonDecode or any other unexpected errors
      return {
        'body': {'error': e.toString()},
        'statusCode': 500,
      };
    }
  }

  static void _handleError(DioException e) {
    if (e.response != null) {
      print("❌ Dio Error [${e.response?.statusCode}]: ${e.response?.data}");
      throw Exception('HTTP ${e.response?.statusCode}: ${e.response?.data}');
    } else {
      print("❌ Dio Error: ${e.message}");
      throw Exception('Dio Error: ${e.message}');
    }
  }
}
