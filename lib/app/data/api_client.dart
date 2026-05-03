import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:get/get.dart' as getx;
import 'package:karan/app/core/error_handling/app_release_error_handler.dart';
import 'package:karan/app/services/toasts.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../core/config/dev_auth_config.dart';
import '../core/const/app_dialogs.dart';
import '../core/const/not_found.dart';
import '../routes/app_pages.dart';
import '../services/local_storage_services/local_storage_services.dart';
import '../services/secure_token_service/secure_token_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static Dio? _dio;

  factory ApiClient() {
    if (_dio == null) _instance._initDio();
    return _instance;
  }

  ApiClient._internal();

  void _initDio() {
    // Laravel `routes/api.php` is mounted at /api; routes use prefix `v1` → full base /api/v1/.
    // Production: https://todoist.jamesbrookit.com/api/v1/
    // Local override: --dart-define=APP_API_BASE_URL=http://127.0.0.1:8000/api/v1/
    const configuredBase = String.fromEnvironment(
      'APP_API_BASE_URL',
      defaultValue: 'https://todoist.jamesbrookit.com/api/v1/',
    );
    _dio = Dio(
      BaseOptions(
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
        baseUrl: configuredBase,
        // Laravel/API: ask for JSON responses (errors as JSON, not HTML redirects).
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );

    _dio!.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true, //
        responseBody: true,
      ),
    );

    _dio!.interceptors.addAll([
      RetryInterceptor(
        dio: _dio!,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    ]);

    // ✅ Fixed Interceptor - Token automatically add kar raha hai
    _dio!.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers.putIfAbsent('Accept', () => 'application/json');
          final secureToken = await SecureTokenService().getAuthToken();
          final authToken = secureToken.isNotEmpty
              ? secureToken
              : LocalStorageService().getAuthToken();
          if (authToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $authToken';
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          print("API Error: ${error.response?.statusCode}");

          if (error.response?.statusCode == 401) {
            print("Unauthorized - Token might be expired");
            if (!DevAuthConfig.shouldBypassAuth) {
              await LocalStorageService().logout();
              getx.Get.offAllNamed(Routes.AUTH_WELCOME);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  // ✅ Simplified getHeaders method
  Map<String, String> getHeaders({
    bool isMultipart = false,
    bool includeAuth = true,
  }) {
    final token = LocalStorageService().getAuthToken();
    final headers = <String, String>{
      "Content-Type": isMultipart ? "multipart/form-data" : "application/json",
      "Accept": "application/json",
    };
    if (includeAuth && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  Future<T?> _makeRequest<T>(Future<Response> request) async {
    try {
      Response response = await request;
      return _parseResponse<T>(response);
    } on DioException catch (e) {
      print("DioException_line_103: ${e.message}");
      print("Status Code_line_104 ${e.response?.statusCode}");
      print("Response Data_line_10 ${e.response?.data}");
      return ApiException(dioException: e).apiExceptionResponse() as T?;
    }
  }

  // ✅ GET request - Headers properly add kiye
  Future<Map<String, dynamic>?> getRequest({
    required String endPoint,
    bool includeAuth = true,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.get(
        endPoint,
        options: Options(headers: getHeaders(includeAuth: includeAuth)),
      ),
    );
  }

  // ✅ POST request - Simple version
  Future<Map<String, dynamic>?> postRequest({
    required String endPoint,
    required dynamic body,
    bool includeAuth = true,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.post(
        endPoint,
        data: body,
        options: Options(headers: getHeaders(includeAuth: includeAuth)),
      ),
    );
  }

  // ✅ PUT request - Headers properly add kiye
  Future<Map<String, dynamic>?> putRequest({
    required String endPoint,
    required dynamic body,
    bool? isMultipart,
    bool includeAuth = true,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.put(
        endPoint,
        data: body,
        options: Options(
          headers: getHeaders(
            isMultipart: isMultipart ?? false,
            includeAuth: includeAuth,
          ),
        ),
      ),
    );
  }

  // ✅ DELETE request - Headers properly add kiye
  Future<Map<String, dynamic>?> deleteRequest({
    required String endPoint,
    required dynamic body,
    bool includeAuth = true,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.delete(
        endPoint,
        data: body,
        options: Options(headers: getHeaders(includeAuth: includeAuth)),
      ),
    );
  }

  // ✅ PATCH request - Headers properly add kiye
  Future<Map<String, dynamic>?> patchRequest({
    required String endPoint,
    required dynamic body,
    bool includeAuth = true,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.patch(
        endPoint,
        data: body,
        options: Options(headers: getHeaders(includeAuth: includeAuth)),
      ),
    );
  }

  Future<Map<String, dynamic>?> uploadFileRequest({
    required String endPoint,
    required String filePath,
    String fileField = 'file',
    Map<String, dynamic>? extraFields,
    ProgressCallback? onSendProgress,
    bool includeAuth = true,
  }) async {
    final fileName = filePath.split(RegExp(r'[\\/]')).last;
    final formData = FormData.fromMap({
      ...(extraFields ?? const {}),
      fileField: await MultipartFile.fromFile(filePath, filename: fileName),
    });

    return await _makeRequest<Map<String, dynamic>>(
      _dio!.post(
        endPoint,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(
          headers: getHeaders(isMultipart: true, includeAuth: includeAuth),
        ),
      ),
    );
  }

  T _parseResponse<T>(Response response) {
    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 400) {
      return response.data as T;
    } else {
      return ApiException(response: response).apiExceptionResponse() as T;
    }
  }
}

class ApiException implements Exception {
  DioException? dioException;
  Response? response;

  ApiException({this.dioException, this.response});

  Map<String, dynamic>? apiExceptionResponse() {
    if (dioException != null) {
      final d = dioException!;
      final code = d.response?.statusCode;

      if (d.type == DioExceptionType.connectionError) {
        getx.Get.to(const NoInternetPage());
      } else if (d.type == DioExceptionType.connectionTimeout ||
          d.type == DioExceptionType.receiveTimeout ||
          d.type == DioExceptionType.sendTimeout) {
        Toasts.getErrorToast(text: kGenericUserErrorMessage);
      } else if (code == 400) {
        final msg = d.response?.data is Map
            ? '${(d.response!.data as Map)['message'] ?? 'Bad Request'}'
            : 'Bad Request';
        Toasts.getErrorToast(text: msg);
      } else if (code == 401) {
        if (!DevAuthConfig.shouldBypassAuth) {
          LocalStorageService().logout();
          getx.Get.offAllNamed(Routes.AUTH_WELCOME);
          AppDialog.showToast(
            "${d.response?.data is Map ? (d.response!.data as Map)['message'] : ''}"
                    .trim()
                    .isEmpty
                ? 'Unauthorized'
                : '${(d.response!.data as Map)['message']}',
          );
        }
      } else if (code == 403) {
        if (!DevAuthConfig.shouldBypassAuth) {
          LocalStorageService().logout();
          AppDialog.showToast(
            "${d.response?.data is Map ? (d.response!.data as Map)['message'] : ''}"
                    .trim()
                    .isEmpty
                ? 'Forbidden'
                : '${(d.response!.data as Map)['message']}',
          );
        }
      } else if (code == 404) {
        AppDialog.showToast(
          "${d.response?.data is Map ? (d.response!.data as Map)['message'] : ''}"
                  .trim()
                  .isEmpty
              ? 'Requested resource not found'
              : '${(d.response!.data as Map)['message']}',
        );
      } else if (code == 420) {
        return d.response?.data;
      } else if (code == 422) {
        final body = d.response?.data;
        if (body is Map<String, dynamic>) return body;
        if (body is Map) return Map<String, dynamic>.from(body);
        return <String, dynamic>{'message': 'Validation failed'};
      } else if (code != null && code >= 500 && code < 600) {
        Toasts.getErrorToast(text: kGenericUserErrorMessage);
      } else if (code != null) {
        Toasts.getErrorToast(text: kGenericUserErrorMessage);
      } else {
        Toasts.getErrorToast(text: kGenericUserErrorMessage);
      }
      return null;
    }

    switch (response?.statusCode) {
      case 204:
        print("Updated Successfully");
        return {"message": "Updated Successfully"};
      case 400:
        print("400 Error: ${response?.data}");
        _logError('Bad request: ${response?.data}');
        Toasts.getErrorToast(text: 'Bad request');
        return null;
      case 403:
        if (!DevAuthConfig.shouldBypassAuth) {
          getx.Get.offAllNamed(Routes.AUTH_WELCOME);
        }
        _logError('Authentication error 403: ${response?.data}');
        return null;
      case 404:
        _logError('Not found: ${response?.data}');
        Toasts.getErrorToast(text: kGenericUserErrorMessage);
        return null;
      case 500:
      case 502:
      case 503:
        _logError('Server error: ${response?.data}');
        Toasts.getErrorToast(text: kGenericUserErrorMessage);
        return null;
      case 401:
        _logError('Unauthorized : ${response?.data}');
        if (!DevAuthConfig.shouldBypassAuth) {
          LocalStorageService().logout();
          getx.Get.offAllNamed(Routes.AUTH_WELCOME);
        }
        return null;
      default:
        final sc = response?.statusCode;
        if (sc != null && sc >= 500) {
          Toasts.getErrorToast(text: kGenericUserErrorMessage);
        } else {
          _logError('API error: ${response?.data}');
          Toasts.getErrorToast(text: kGenericUserErrorMessage);
        }
        return null;
    }
  }

  void _logError(String message) {
    print(message);
  }
}
