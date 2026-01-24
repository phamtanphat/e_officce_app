import 'package:dio/dio.dart';
import 'package:e_officce_tfc/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

@riverpod
ApiClient apiClient(Ref ref) {
  return ApiClient();
}

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Constant.baseUrl,
        connectTimeout: const Duration(milliseconds: Constant.timeOut),
        receiveTimeout: const Duration(milliseconds: Constant.timeOut),
        sendTimeout: const Duration(milliseconds: Constant.timeOut),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
      case DioExceptionType.cancel:
        return RequestCancelledException();
      case DioExceptionType.connectionError:
        return NoInternetException();
      default:
        return UnknownException();
    }
  }

  Exception _handleResponseError(Response? response) {
    if (response == null) return UnknownException();

    switch (response.statusCode) {
      case 400:
        return BadRequestException(response.data['message']);
      case 401:
        return UnauthorizedException();
      case 403:
        return ForbiddenException();
      case 404:
        return NotFoundException();
      case 500:
        return ServerException();
      default:
        return UnknownException();
    }
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint(
        '${Constant.tag} REQUEST[${options.method}] => PATH: ${options.path}');
    debugPrint('${Constant.tag} Headers: ${options.headers}');
    debugPrint('${Constant.tag} Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        '${Constant.tag} RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    debugPrint('${Constant.tag} Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        '${Constant.tag} ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    debugPrint('${Constant.tag} Message: ${err.message}');
    super.onError(err, handler);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Add any global error handling logic here
    super.onError(err, handler);
  }
}

abstract class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class TimeoutException extends NetworkException {
  TimeoutException() : super('Connection timeout');
}

class NoInternetException extends NetworkException {
  NoInternetException() : super('No internet connection');
}

class RequestCancelledException extends NetworkException {
  RequestCancelledException() : super('Request cancelled');
}

class BadRequestException extends NetworkException {
  BadRequestException(String message) : super(message, statusCode: 400);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException() : super('Unauthorized access', statusCode: 401);
}

class ForbiddenException extends NetworkException {
  ForbiddenException() : super('Access forbidden', statusCode: 403);
}

class NotFoundException extends NetworkException {
  NotFoundException() : super('Resource not found', statusCode: 404);
}

class ServerException extends NetworkException {
  ServerException() : super('Internal server error', statusCode: 500);
}

class UnknownException extends NetworkException {
  UnknownException() : super('An unknown error occurred');
}
