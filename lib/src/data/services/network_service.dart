import 'dart:developer';

import 'package:chatapp_ui/src/constants/api_constants.dart';
import 'package:chatapp_ui/src/constants/constants.dart';
import 'package:chatapp_ui/src/data/exceptions/session_expired_exception.dart';
import 'package:chatapp_ui/src/data/services/secure_store_service.dart';
import 'package:chatapp_ui/src/data/services/session_expired_event_listener.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@Singleton()
class NetworkService {
  NetworkService(
    Dio dio,
    SecureStoreService secureStoreService,
    SessionExpiredEventListener sessionExpiredEventListener,
  )   : _dio = dio,
        _secureStoreService = secureStoreService,
        _sessionExpiredEventListener = sessionExpiredEventListener;

  final Dio _dio;
  final SecureStoreService _secureStoreService;
  final SessionExpiredEventListener _sessionExpiredEventListener;

  @factoryMethod
  factory NetworkService.init(
    SecureStoreService secureStoreService,
    SessionExpiredEventListener sessionExpiredEventListener,
  ) {
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
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            logPrint: (object) => log(object.toString()),
          )
        ],
      );
    return NetworkService(dio, secureStoreService, sessionExpiredEventListener);
  }

  Future<Response> get(
    String path, {
    bool attachToken = false,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Options? options,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      var headers = options?.headers ?? {};
      if (attachToken) {
        final token = await _getToken();
        headers['Authorization'] = "Bearer $token";
      }

      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        data: body,
        options:
            options?.copyWith(responseType: responseType, headers: headers) ??
                Options(responseType: responseType, headers: headers),
      );

      return response;
    } on DioException catch (dioException) {
      if (dioException.response?.statusCode == 403) {
        final sessionExpiredException =
            SessionExpiredException(dioException.message);
        await _deleteToken();
        _sessionExpiredEventListener.addEvent(sessionExpiredException);
        throw sessionExpiredException;
      }
      rethrow;
    } catch (e) {
      //TODO: throw custom exception
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    bool attachToken = false,
    bool retrieveToken = false,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Options? options,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      var headers = options?.headers ?? {};
      if (attachToken) {
        final token = await _getToken();
        headers['Authorization'] = "Bearer $token";
      }

      final response = await _dio.post(
        path,
        queryParameters: queryParameters,
        data: body,
        options:
            options?.copyWith(responseType: responseType, headers: headers) ??
                Options(responseType: responseType, headers: headers),
      );

      if (retrieveToken) {
        final token = response.data['token'] as String?;
        if (token != null) {
          await _secureStoreService.put(key: jwtTokenKey, value: token);
        }
      }

      return response;
    } on DioException catch (dioException) {
      if (dioException.response?.statusCode == 403) {
        final sessionExpiredException =
            SessionExpiredException(dioException.message);
        await _deleteToken();
        if (!retrieveToken) {
          _sessionExpiredEventListener.addEvent(sessionExpiredException);
        }
        throw sessionExpiredException;
      }
      rethrow;
    } catch (e) {
      //TODO: throw custom exception
      rethrow;
    }
  }

  Future<String> _getToken() async {
    final token = await _secureStoreService.get(key: jwtTokenKey);
    if (token != null) return token;
    throw Exception("Session Expired");
  }

  Future<void> _deleteToken() async {
    return _secureStoreService.delete(key: jwtTokenKey);
  }
}
