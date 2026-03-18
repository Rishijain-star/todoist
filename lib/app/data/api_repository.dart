import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/local_storage_services/local_storage_services.dart';
import '../services/location_service_new/location_service_new.dart';
import 'api_client.dart';
import 'package:dio/dio.dart';

class ApiRepository {
  static final prefs = LocalStorageService.sharedPreferences!;
  // Auth Apis ********************************************************************************************************************************************************************************

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient().postRequest(
        endPoint: "auth/login",
        body: {
          "email": email,
          "password": password,
          "login_type": "email",
          "region": LocalStorageService().getCountry().toLowerCase() == "india"
              ? "canada"
              : LocalStorageService().getCountry().toLowerCase(),
        },
      );

      if (response != null) {
        // final loginModel = LoginModel.fromJson(response);
        // LocalStorageService().setAuthToken(loginModel.data?.tokens?.accessToken ?? "");
        // LocalStorageService().setUserId(loginModel.data?.user?.id ?? "");
        // LocalStorageService().setEmailId(loginModel.data?.user?.email ?? "");
        return true;
      }
    } catch (e, s) {
      print("login error: $e\n$s");
    }
    return false;
  }

  // static Future<bool> register({
  //   required String email,
  //   required String password,
  //   String? name,
  // }) async {
  //   try {
  //     final response = await ApiClient().postRequest(
  //       endPoint: "auth/register",
  //       body: {
  //         "email": email,
  //         "password": password,
  //         "name": name,
  //         "uid": "asdf",
  //         "region": LocalStorageService().getCountry().toLowerCase() == "india" ? "canada" : LocalStorageService().getCountry().toLowerCase(),
  //         "login_type": "email",
  //       },
  //     );
  //
  //     if (response != null) {
  //       AppDialog.showToast("OTP sent successfully!");
  //       return true;
  //     }
  //   } catch (e, s) {
  //     print("register error: $e\n$s");
  //   }
  //   return false;
  // }
  // static Future<GetTaxModel> buyCoinPrice() async {
  //   try {
  //     final response = await ApiClient().getRequest(
  //         endPoint: "/plans?type=customer&region=canada",
  //     );
  //     if (response != null) {
  //       return GetTaxModel.fromJson(response);
  //     }
  //   } catch (e, s) {
  //     print("❌ sponsoredCoupons error: $e\n$s");
  //   }
  //   return GetTaxModel();
  // }
}
