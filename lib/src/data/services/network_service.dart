import 'dart:developer';

import 'package:chatapp_ui/src/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@Singleton()
class NetworkService {
  NetworkService(Dio dio) : _dio = dio;

  final Dio _dio;

  @factoryMethod
  factory NetworkService.init() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        followRedirects: false,
        contentType: "application/json",
      ),
    )..interceptors.addAll(
        [
          PrettyDioLogger(
            request: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            logPrint: (object) => log(object.toString()),
          )
        ],
      );
    return NetworkService(dio);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Options? options,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      final response = _dio.get(
        path,
        queryParameters: queryParameters,
        data: body,
        options: options?.copyWith(responseType: responseType) ??
            Options(responseType: responseType),
      );
      return response;
    } on DioException {
      rethrow;
    } catch (e) {
      //TODO: throw custom exception
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Options? options,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      final response = _dio.post(
        path,
        queryParameters: queryParameters,
        data: body,
        options: options?.copyWith(responseType: responseType) ??
            Options(responseType: responseType),
      );
      return response;
    } on DioException {
      rethrow;
    } catch (e) {
      //TODO: throw custom exception
      rethrow;
    }
  }
}
