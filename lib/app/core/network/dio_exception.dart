import 'package:dio/dio.dart';

class NetworkFailure implements Exception {
  final int code;
  final String message;

  const NetworkFailure({required this.code, required this.message});
}

class ErrorHandler {
  static NetworkFailure handle(Object error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return NetworkFailure(
      code: -99,
      message: 'Terjadi kesalahan tidak terduga: ${error.toString()}',
    );
  }

  static NetworkFailure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          code: -1,
          message: 'Waktu koneksi habis (Timeout). Periksa koneksi internet Anda.',
        );
      case DioExceptionType.connectionError:
        return const NetworkFailure(
          code: -6,
          message: 'Gagal terhubung ke server. Pastikan perangkat terhubung ke internet.',
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      default:
        return NetworkFailure(
          code: -8,
          message: 'Gangguan koneksi: ${error.message ?? 'Terjadi kesalahan tidak diketahui'}',
        );
    }
  }

  static NetworkFailure _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    switch (statusCode) {
      case 400:
        return const NetworkFailure(code: 400, message: 'Permintaan tidak valid (Bad Request).');
      case 401:
        return const NetworkFailure(code: 401, message: 'Anda tidak memiliki akses (Unauthorized).');
      case 404:
        return const NetworkFailure(code: 404, message: 'Data tidak ditemukan di server (Not Found).');
      case 500:
        return const NetworkFailure(code: 500, message: 'Server sedang bermasalah (Internal Server Error).');
      default:
        return NetworkFailure(
          code: statusCode,
          message: 'Server merespons dengan kode $statusCode.',
        );
    }
  }
}