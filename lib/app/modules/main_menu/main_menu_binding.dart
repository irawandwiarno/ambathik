import 'package:ambathik/app/modules/main_menu/main_menu_controller.dart';
import 'package:get/get.dart';

class MainMenuBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(MainMenuController());
  }
}