import 'package:karan/app/services/toasts.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/io.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../core/const/app_dialogs.dart';
import '../core/const/not_found.dart';
import '../routes/app_pages.dart';
import '../services/local_storage_services/local_storage_services.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static Dio? _dio;

  factory ApiClient() {
    if (_dio == null) _instance._initDio();
    return _instance;
  }

  ApiClient._internal();

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
        baseUrl: 'https://api.coupoint.ca/',
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

    _dio!.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client = HttpClient(
          context: SecurityContext(withTrustedRoots: false),
        );
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return client;
      },
    );

    // ✅ Fixed Interceptor - Token automatically add kar raha hai
    _dio!.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final authToken = LocalStorageService().getAuthToken();
          if (authToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $authToken';
            // talker.info("Token added to header: Bearer $authToken");
          } else {
            print("No auth token found");
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          print("API Error: ${error.response?.statusCode}");

          // if (error.response?.statusCode == 401) {
          //   print("Unauthorized - Token might be expired");
          //   PrefUtils().logout();
          //   getx.Get.offAllNamed('/login');
          // }

          return handler.next(error);
        },
      ),
    );
  }

  // ✅ Simplified getHeaders method
  Map<String, String> getHeaders({bool isMultipart = false}) {
    final token = LocalStorageService().getAuthToken();
    final _ = LocalStorageService().getUserId();
    // talker.info("token==>$token");
    // talker.info("user_id==>$userId");

    return {
      "Authorization": "Bearer $token",
      "Content-Type": isMultipart ? "multipart/form-data" : "application/json",
    };
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
  Future<Map<String, dynamic>?> getRequest({required String endPoint}) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.get(endPoint, options: Options(headers: getHeaders())),
    );
  }

  // ✅ POST request - Simple version
  Future<Map<String, dynamic>?> postRequest({
    required String endPoint,
    required dynamic body,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.post(
        endPoint,
        data: body,
        options: Options(headers: getHeaders()),
      ),
    );
  }

  // ✅ PUT request - Headers properly add kiye
  Future<Map<String, dynamic>?> putRequest({
    required String endPoint,
    required dynamic body,
    bool? isMultipart,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.put(
        endPoint,
        data: body,
        options: Options(
          headers: getHeaders(isMultipart: isMultipart ?? false),
        ),
      ),
    );
  }

  // ✅ DELETE request - Headers properly add kiye
  Future<Map<String, dynamic>?> deleteRequest({
    required String endPoint,
    required dynamic body,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.delete(
        endPoint,
        data: body,
        options: Options(headers: getHeaders()),
      ),
    );
  }

  // ✅ PATCH request - Headers properly add kiye
  Future<Map<String, dynamic>?> patchRequest({
    required String endPoint,
    required dynamic body,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.patch(
        endPoint,
        data: body,
        options: Options(headers: getHeaders()),
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
      if (dioException!.type == DioExceptionType.connectionError) {
        getx.Get.to(NoInternetPage());
      }
      if (dioException!.response?.statusCode == 400) {
        Toasts.getErrorToast(
          text: "${dioException!.response!.data["message"] ?? "Bad Request"}",
        );
      }

      if (dioException!.response?.statusCode == 401) {
        AppDialog.showToast(
          "${dioException!.response!.data["message"] ?? "Bad Request"}",
        );
      }

      if (dioException!.response?.statusCode == 403) {
        LocalStorageService().logout();
        AppDialog.showToast(
          "${dioException!.response!.data["message"] ?? "Bad Request"}",
        );
      }
      if (dioException!.response?.statusCode == 404) {
        getx.Get.to(Error404Page());
      }
      if (dioException!.response?.statusCode == 503) {
        getx.Get.to(Error404Page());
      }
      if (dioException!.response?.statusCode == 500) {
        getx.Get.to(Error500Page());
      }
      if (dioException!.response?.statusCode == 420) {
        return dioException!.response?.data;
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
        return null;
      case 403:
        getx.Get.offAllNamed(Routes.AUTH_WELCOME);
        _logError('Authentication error 403: ${response?.data}');
        return null;
      case 404:
        _logError('Not found: ${response?.data}');
        return null;
      case 500:
        _logError('Server error: ${response?.data}');
        return null;
      case 401:
        _logError('Unauthorized : ${response?.data}');
        return null;
      default:
        _logError('Unauthorized : ${response?.data}');
        return null;
    }
  }

  void _logError(String message) {
    print(message);
  }
}
