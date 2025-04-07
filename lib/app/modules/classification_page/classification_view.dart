import 'package:ambathik/app/modules/classification_page/classification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassificationView extends StatelessWidget {
  ClassificationView({super.key});

  var controller = Get.put(ClassificationController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(),
    ));
  }
}
