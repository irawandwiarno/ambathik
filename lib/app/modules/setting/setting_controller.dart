import 'package:ambathik/app/data/models/save_model_info.dart';
import 'package:ambathik/app/data/services/classification_service.dart';
import 'package:ambathik/app/data/services/preference_service.dart';
import 'package:ambathik/app/shared/utils/path_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final List<String> items = [
    'InceptionV3',
    'MobileNetV2',
    'Resnet18',
    'MobileViT',
  ];

  final Map<String, String> modelMap = {
    'InceptionV3': PathModel.INCEPTIONV3,
    'MobileNetV2': PathModel.MOBILENET,
    'Resnet18': PathModel.RESNET18,
    'MobileViT': PathModel.MOBILEVIT,
  };

  var selectedValue = ''.obs;

  @override
  void onInit() async {
    SavedModelInfo? savedModelInfo = await PreferenceService.getModelInfo();
    if (savedModelInfo == null) {
      selectedValue.value = items[0];
    } else {
      selectedValue.value = savedModelInfo.label;
    }
    super.onInit();
  }

  void onChangeModel(String? value) async {
    SavedModelInfo savedModelInfo =
        SavedModelInfo(label: value!, path: modelMap[value]!);
    PreferenceService.saveModelInfo(savedModelInfo);
    selectedValue.value = value;

    var res = await TFLiteService().changeModel(modelMap[value]!, value);
    if (res) {
      Get.snackbar('Load Model', 'Success load model',
          duration: Duration(seconds: 2), backgroundColor: Colors.green);
    }else{
      Get.snackbar('Load Model', 'Gagal load model',
          duration: Duration(seconds: 2), backgroundColor: Colors.redAccent);
    }
  }
}
