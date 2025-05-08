import 'dart:io';

import 'package:ambathik/app/data/models/history.dart';
import 'package:ambathik/app/data/services/classification_service.dart';
import 'package:ambathik/app/data/services/database_helper.dart';
import 'package:ambathik/app/modules/home_page/home_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class NotIdentifiedController extends GetxController {
  late XFile image;
  late List<dynamic> prediction;

  void setData({required XFile imageFile, required List<dynamic> result}) {
    image = imageFile;
    prediction = result;
    saveDataToDatabase(imageFile, result);
  }

  Map<String, dynamic> get topPrediction => prediction[0];
  int get topIndex => topPrediction['labelIndex'];
  String get topLabel => topPrediction['label'];
  double get topConfidence => topPrediction['confidence'];

  List<Map<String, dynamic>> get otherPredictions => prediction.length > 1
      ? prediction
      .sublist(1, prediction.length.clamp(1, 5))
      .cast<Map<String, dynamic>>()
      : [];


  void saveDataToDatabase(imageFile, result) {
    saveHistory(imageFile, result);
    var homeController = Get.find<HomeController>();
    homeController.getHistory();
  }

  void saveHistory(XFile imageFile, predictionOutput) async {
    var newPath = await saveImageToAppDirectory(imageFile);
    var history = History.fromPredictionOutput(
        newPath, TFLiteService().modelName!, predictionOutput,
        label: "Can't Be Identified", isIdentified: false);

    DatabaseHelper().insertHistory(history);

    var homeC = Get.find<HomeController>();
    homeC.getHistory();
  }

  Future<String> saveImageToAppDirectory(XFile image) async {
    // Dapatkan direktori penyimpanan lokal aplikasi
    final Directory appDir = await getApplicationDocumentsDirectory();

    // Pastikan folder penyimpanan ada, jika belum maka buat
    final Directory saveDir = Directory('${appDir.path}/saved_images');
    if (!await saveDir.exists()) {
      await saveDir.create(recursive: true);
    }

    // Buat nama file baru atau gunakan yang lama
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String fileName = "ambathik-$timestamp.jpg";

    // Lokasi tujuan penyimpanan
    final File savedImage = File('${saveDir.path}/$fileName');

    // Salin file dari sumber ke tujuan
    final File newImage = await File(image.path).copy(savedImage.path);

    print("📁 Gambar disimpan di: ${newImage.path}");

    return newImage.path;
  }
}
