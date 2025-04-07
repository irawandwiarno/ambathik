import 'package:ambathik/app/modules/home_page/home_binding.dart';
import 'package:ambathik/app/modules/home_page/home_view.dart';
import 'package:ambathik/app/modules/main_menu/main_menu_binding.dart';
import 'package:ambathik/app/modules/main_menu/main_menu_page.dart';
import 'package:ambathik/app/modules/setting/setting_binding.dart';
import 'package:ambathik/app/modules/setting/setting_page.dart';
import 'package:ambathik/app/routes/app_routes.dart';
import 'package:get/get.dart';


class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => SettingPage(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.MAINMENU,
      page: () => MainMenuPage(),
      binding: MainMenuBinding(),
    ),
  ];
}