import 'package:ambathik/app/modules/guide_page/widget/advance_using_page.dart';
import 'package:ambathik/app/modules/guide_page/widget/ambathik_pages.dart';
import 'package:ambathik/app/modules/guide_page/widget/contact_us_page.dart';
import 'package:ambathik/app/modules/guide_page/widget/how_to_use_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideController extends GetxController{
  /// Controller untuk PageView
  final PageController pageController = PageController();

  /// List halaman yang akan ditampilkan
  var pages = <Widget>[
    AmbathikPages(),
    HowToUsePage(),
    AdvanceUsingPage(),
    ContactUsPage()
  ].obs;

}