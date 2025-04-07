import 'package:ambathik/app/modules/setting/setting_controller.dart';
import 'package:get/get.dart';

class SettingBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(SettingController());
  }
}