import 'package:evencir_task/modules/home/home_screen.dart';
import 'package:get/get.dart';
import 'dart:async';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    startSplashTimer();
  }

  void startSplashTimer() {
    Timer(const Duration(seconds: 3), () {
      Get.off(() => HomeScreen());
    });
  }
}
