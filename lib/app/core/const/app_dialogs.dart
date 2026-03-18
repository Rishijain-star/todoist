import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../services/local_storage_services/local_storage_services.dart';
import '../extensions.dart';
import 'app_colors.dart';

class AppDialog {
  static void showToast(String message, {ToastGravity? gravity}) {
    Fluttertoast.showToast(
      msg: "  $message  ",
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: AppColors.primaryColor,
      textColor: Colors.white,
      fontSize: 14.0.sp,
    );
  }

  static void showSnackBarError({
    required String message,
    int durationMilliseconds = 3000,
  }) {
    print("showSnackBarError===>$message");
    final overlay = Overlay.of(Get.context!);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewPadding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.r,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(milliseconds: durationMilliseconds)).then((_) {
      overlayEntry.remove();
    });
  }

  static void logoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r), // 👈
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            'Log out'.style.w524.make(),
            16.heightBox,
            'Lorem ipsum dolor sit amet consectetur. Luctus aliquet adipiscing sit lectus morbi tristique dignissim sit.'
                .style
                .w416
                .color(Color.fromRGBO(150, 154, 168, 1))
                .lineHeight(1.4)
                .center
                .make(),

            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: "Cancel".style.w418
                        .color(AppColors.primaryColor)
                        .make(),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Get.toNamed(Routes.LOGIN);
                      LocalStorageService().logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: "Log out".style.w518.color(AppColors.white).make(),
                  ),
                ),
              ],
            ),
          ],
        ).paddingAll(20.r),
      ),
    );
  }

  static void deleteDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r), // 👈 Yeh line add ki gayi
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Delete Account'.style.w524.make(),
            16.heightBox,
            'All your data will be permanently deleted and cannot be recovered. If you agree, we will send an OTP to verify your request.'
                .style
                .w416
                .color(Color.fromRGBO(150, 154, 168, 1))
                .lineHeight(1.4)
                .center
                .make(),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: "Cancel".style.w418
                        .color(AppColors.primaryColor)
                        .make(),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      //   Get.back();
                      //    GlobalFunctions.kprint("PrefUtils().getEmailId()${PrefUtils().getEmailId()}");
                      // bool response = await  ApiRepository.forgot_password(email: PrefUtils().getEmailId());
                      //  if(response){
                      //     try {
                      //       Get.find<ForgotPasswordOtpController>().otpController.dispose();
                      //     } catch (e) {
                      //       // Get.put(ForgotPasswordOtpController());
                      //        GlobalFunctions.kprint("ForgotPasswordOtpController not found: $e");
                      //     }
                      //      GlobalFunctions.kprint("PrefUtils().getEmailId()${PrefUtils().getEmailId()}");
                      //    Get.toNamed(
                      //      Routes.FORGOT_PASSWORD_OTP,
                      //      arguments: {'email':  PrefUtils().getEmailId(), "isDeleteAccount": true},
                      //    );
                      //  }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: "Delete".style.w518.color(AppColors.white).make(),
                  ),
                ),
              ],
            ),
          ],
        ).paddingAll(20.r),
      ),
    );
  }
}
