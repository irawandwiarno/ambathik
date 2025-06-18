import 'package:ambathik/app/config/app_colors.dart';
import 'package:ambathik/app/data/services/classification_service.dart';
import 'package:ambathik/app/data/services/image_service.dart';
import 'package:ambathik/app/data/services/tensorflowlite_services.dart';
import 'package:ambathik/app/modules/classification_page/classification_view.dart';
import 'package:ambathik/app/modules/not_identified/not_identified_view.dart';
import 'package:ambathik/app/shared/utils/app_spacing.dart';
import 'package:ambathik/app/shared/utils/constant.dart';
import 'package:ambathik/app/shared/utils/path_model.dart';
import 'package:ambathik/app/shared/widgets/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ambathik/app/modules/home_page/home_view.dart';
import 'package:ambathik/app/modules/setting/setting_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:image/image.dart' as img;

class MainMenuController extends GetxController {
  var screens = [HomeView(), HomeView(), SettingPage()];

  var tfLite = TFLiteService();
  final tfliteService = TensorflowLiteServices();

  XFile? image;

  PersistentTabController controllerNavBar =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: "Home",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/first",
          routes: {
            "/first": (context) => HomeView(),
            "/second": (context) => SettingPage(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: FloatingActionButton(
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: Text(
                  "Choose Method",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardIconButton(Icons.image_outlined, "Gallery", () async {
                        image = await ImageService.pickFromGallery();

                        pushToClassifyPage();
                      }),
                      CardIconButton(Icons.camera_alt_outlined, "Camera", () async {
                        image = await ImageService.pickFromCamera();
                        pushToClassifyPage();
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
          backgroundColor: CupertinoColors.activeBlue,
          child: Icon(
            CupertinoIcons.camera,
            color: Colors.white,
            size: 28,
          ),
          elevation: 0,
          shape: CircleBorder(),
        ),
        title: "Recognize",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        // Optional: Disable navigation for this item if it's only for triggering the dialog
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/first",
          routes: {
            "/first": (context) => HomeView(),
            "/second": (context) => SettingPage(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings_solid),
        title: "Settings",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/second",
          routes: {
            "/first": (context) => HomeView(),
            "/second": (context) => SettingPage(),
          },
        ),
      ),
    ];
  }

  void pushToClassifyPage() async{
    Get.back();
    if (image != null) {
      tfLite.loadLabels(PathModel.LABELS);
      print("🖼️ Gambar dari galeri: ${image!.path}");
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      await Future.delayed(const Duration(seconds: 1));
      if (tfliteService.modelName == "InceptionV3") {
        clasify();
      } else {
        classify512(image!);
      }
    }
  }

  Future<void> classify512(XFile pickedFile) async {
    final result = await tfliteService.runOnImage(pickedFile);
    print('Predicted label: ${result}');

    var param = {
      'image': image,
      'prediction': result,
    };

    pushToResultPage(param: param, result: result);
  }

  void pushToResultPage({result, param}){
    Get.back();
    if (isIndentified(result)) {
      Get.to(ClassificationView(), arguments: param);
    } else {
      Get.to(NotIdentifiedView(), arguments: param);
    }
  }

  void clasify() async {
    print("clasify mulai");
    if (image != null) {
      print("image found");
      final bytes = await image!.readAsBytes();
      final original = img.decodeImage(bytes);

      if (original == null) {
        print("❌ Gagal decode image");
        return;
      }

      print("bw image start");
      final bwImage = tfLite.preprocessToBlackWhiteRGB(original);
      print("bw image end");

      print("go go indentify");
      // Klasifikasi hasil segmentasi
      final result = await tfLite.classifyImage(bwImage);

      var param = {
        'image': image,
        'prediction': result,
      };

      print("✅ Hasil klasifikasi:");
      for (var res in result) {
        var indexLabel = res['labelIndex'];
        print(
            "Label: ${Constant.LABEL[indexLabel]} - Confidence: ${res['confidence']}");
      }

      pushToResultPage(param: param, result: result);

      //
      // print("✅ Hasil klasifikasi:");
      // for (var res in result) {
      //   var indexLabel = res['labelIndex'];
      //   print("Label: ${Constant.LABEL[indexLabel]} - Confidence: ${res['confidence']}");
      // }
    }
  }

  bool isIndentified(result) {
    var confiden = result[0]['confidence'] * 100;
    if (confiden > 50) {
      return true;
    }

    return false;
  }

  Widget CardIconButton(IconData icon, String title, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 70, color: AppColors.primary),
                Text(
                  title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
