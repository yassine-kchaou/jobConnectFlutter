import 'package:dio/dio.dart';
import 'package:jobconnect/core/constants/api_constants.dart';
import 'package:jobconnect/data/datasources/http_client.dart';

/// Implémentation Singleton de HttpClient avec Dio
///
/// Pattern: Singleton + Adapter
/// - Singleton: Une seule instance en mémoire
/// - Adapter: Adapte Dio à l'interface HttpClient
///
/// Respecte SRP: Responsabilité unique = Gestion HTTP
/// Respecte DIP: Implémente HttpClient (abstraction)
class ApiClient implements HttpClient {
  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;
  String? _token;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        contentType: 'application/json',
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('[ApiClient] ${options.method.toUpperCase()} ${options.path}');
          print('[ApiClient] Headers: ${options.headers}');
          if (options.data != null) {
            print('[ApiClient] Data: ${options.data}');
          }

          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
            print('[ApiClient] Token attached to request');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('[ApiClient] Response Status: ${response.statusCode}');
          print('[ApiClient] Response Data: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('[ApiClient] Error: ${error.type}');
          print('[ApiClient] Status Code: ${error.response?.statusCode}');
          print('[ApiClient] Error Data: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );
  }

  // Getter pour le dio
  Dio get dio => _dio;

  @override
  String? getToken() => _token;

  @override
  void setToken(String token) {
    _token = token;
    print('[ApiClient] Token set: ${token.substring(0, 20)}...');
  }

  @override
  void clearToken() {
    _token = null;
    print('[ApiClient] Token cleared');
  }

  // Méthodes HTTP - Implémentation de HttpClient
  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      print('[ApiClient] GET request to: $path');
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } catch (e) {
      print('[ApiClient] GET request failed: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      print('[ApiClient] POST request to: $path with data: $data');
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      print('[ApiClient] POST response: ${response.statusCode}');
      return response;
    } catch (e) {
      print('[ApiClient] POST request failed: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      print('[ApiClient] PUT request to: $path');
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } catch (e) {
      print('[ApiClient] PUT request failed: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      print('[ApiClient] DELETE request to: $path');
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } catch (e) {
      print('[ApiClient] DELETE request failed: $e');
      rethrow;
    }
  }

  Future<Response> uploadFile(String path, String filePath,
      {String fieldName = 'file'}) async {
    try {
      print('[ApiClient] Uploading file to: $path');
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post(path, data: formData);
      return response;
    } catch (e) {
      print('[ApiClient] File upload failed: $e');
      rethrow;
    }
  }
}
