import 'package:ambathik/app/config/app_colors.dart';
import 'package:ambathik/app/config/app_text_style.dart';
import 'package:ambathik/app/modules/main_menu/main_menu_controller.dart';
import 'package:ambathik/app/shared/utils/app_spacing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainMenuPage extends GetView<MainMenuController> {
  MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
          navBarStyle: NavBarStyle.style15,
          controller: controller.controllerNavBar,
          screens: controller.screens,
          items: controller.navBarsItems(),
      ),
    );
  }

}
