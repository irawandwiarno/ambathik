import 'package:ambathik/app/config/app_colors.dart';
import 'package:ambathik/app/data/services/classification_service.dart';
import 'package:ambathik/app/data/services/image_service.dart';
import 'package:ambathik/app/modules/classification_page/classification_view.dart';
import 'package:ambathik/app/shared/utils/app_spacing.dart';
import 'package:ambathik/app/shared/utils/path_model.dart';
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

  XFile? image;

  PersistentTabController controllerNavBar =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            "/first": (final context) => const HomeView(),
            "/mid": (final context) => const HomeView(),
            "/second": (final context) => const SettingPage(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          padding: 10.all,
          decoration: BoxDecoration(
            color: CupertinoColors.activeBlue,
            shape: BoxShape.circle,
          ),
          child: Icon(
            CupertinoIcons.camera,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: ("Recognize"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        onPressed: (BuildContext? context) {
          Get.dialog(
            AlertDialog(
              title: Text("Choose metode",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              content: SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardIconButton(Icons.image_outlined, "Gallery", () async {
                      image = await ImageService.pickFromGallery();
                      pushToClasifyPage();
                    }),
                    CardIconButton(Icons.camera_alt_outlined, "Camera",
                        () async {
                      image = await ImageService.pickFromCamera();
                      pushToClasifyPage();
                    }),
                  ],
                ),
              ),
            ),
          );
        },
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            "/first": (final context) => const HomeView(),
            "/mid": (final context) => const HomeView(),
            "/second": (final context) => const SettingPage(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            "/first": (final context) => const HomeView(),
            "/mid": (final context) => const HomeView(),
            "/second": (final context) => const SettingPage(),
          },
        ),
      ),
    ];
  }

  void pushToClasifyPage() {
    if (image != null) {
      tfLite.loadModel(PathModel.INCEPTIONV3);
      tfLite.loadLabels(PathModel.LABELS);
      Get.back(); // Tutup dialog
      print("🖼️ Gambar dari galeri: ${image!.path}");
      clasify();
    }
  }

  void clasify() async{
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

      print("✅ Hasil klasifikasi:");
      for (var res in result) {
        print("Label: ${res['labelIndex']} - Confidence: ${res['confidence']}");
      }
    }
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
