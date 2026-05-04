 import 'package:flutter/material.dart';
 import 'package:get/get.dart';
 import 'package:image_picker/image_picker.dart';
 import '../../../services/local_storage_services/local_storage_services.dart';
 import '../../../services/secure_token_service/secure_token_service.dart';
 import '../../../routes/app_pages.dart';
 
 class OnboardingController extends GetxController {
   final RxInt step = 0.obs;
   final TextEditingController nameController = TextEditingController();
   final RxInt selectedGoal = (-1).obs;
  final RxString profileImagePath = ''.obs;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImagePath.value = image.path;
    }
  }

  double get progress => (step.value + 1) / 4;

  void goStep(int s) => step.value = s;
  void back() {
    if (step.value > 0) {
      step.value -= 1;
    }
    Get.back();
  }
  void nextFromWelcome() {
    step.value = 1;
    Get.toNamed(Routes.ONBOARDING_NAME);
  }
  void submitName() {
    step.value = 2;
    Get.toNamed(Routes.ONBOARDING_GOAL);
  }
  void submitGoal() {
    step.value = 3;
    Get.toNamed(Routes.ONBOARDING_REMINDERS);
  }

  Future<void> _goNext() async {
    await LocalStorageService().setIsOnboardingCompleted(true);
    Get.offAllNamed(Routes.DASHBOARD);
  }

  Future<void> submitReminders() async {
    await _goNext();
  }
 }
