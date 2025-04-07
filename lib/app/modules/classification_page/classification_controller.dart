import 'package:ambathik/app/data/services/classification_service.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;


class ClassificationController extends GetxController {
  var image;

  @override
  void onInit() {
    image = Get.arguments;
    print("mulai init");

    if(image != null){
      print("mulai clasify");
      clasify();
    }
    super.onInit();
  }

  void clasify() async{
    if (image != null) {
      final bytes = await image.readAsBytes();
      final original = img.decodeImage(bytes);

      if (original == null) {
        print("❌ Gagal decode image");
        return;
      }

      final bwImage = TFLiteService().preprocessToBlackWhiteRGB(original);

      // Klasifikasi hasil segmentasi
      final result = await TFLiteService().classifyImage(bwImage);

      print("✅ Hasil klasifikasi:");
      for (var res in result) {
        print("Label: ${res['labelIndex']} - Confidence: ${res['confidence']}");
      }
    }
  }
}
