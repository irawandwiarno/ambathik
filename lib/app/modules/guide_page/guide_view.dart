import 'package:ambathik/app/modules/guide_page/guide_controller.dart';
import 'package:ambathik/app/modules/guide_page/widget/advance_using_page.dart';
import 'package:ambathik/app/modules/guide_page/widget/ambathik_pages.dart';
import 'package:ambathik/app/modules/guide_page/widget/contact_us_page.dart';
import 'package:ambathik/app/modules/guide_page/widget/how_to_use_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GuideView extends GetView<GuideController> {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() => PageView(
              controller: controller.pageController,
              scrollDirection: Axis.vertical, // Scroll ke atas-bawah
              children: controller.pages.toList(),
            )),
            // Indikator di pojok kanan atas
            Positioned(
              top: 40,
              right: 16,
              child: Obx(() => SmoothPageIndicator(
                controller: controller.pageController,
                count: controller.pages.length,
                axisDirection: Axis.vertical,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.black,
                  dotColor: Colors.grey,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
