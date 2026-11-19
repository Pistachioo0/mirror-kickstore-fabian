import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_exception.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio();
    _configureOptions();
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  void _configureOptions() {
    _dio.options
      ..baseUrl = 'https://dummyjson.com'
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..sendTimeout = const Duration(seconds: 15)
      ..headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
  }

  Future<Response<T>> get<T>(String path) async {
    try {
      return await _dio.get<T>(path);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}