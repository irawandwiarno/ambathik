import 'package:ambathik/app/modules/guide_page/guide_controller.dart';
import 'package:get/get.dart';

class GuideBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(GuideController());
  }
}