import 'dart:io';

import 'package:ambathik/app/data/models/history.dart';
import 'package:ambathik/app/modules/classification_page/classification_controller.dart';
import 'package:ambathik/app/modules/detail_history/detail_history_controller.dart';
import 'package:ambathik/app/shared/utils/app_gap.dart';
import 'package:ambathik/app/shared/utils/constant.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailHistoryView extends StatelessWidget {
  DetailHistoryView({super.key});

  final controller = Get.put(DetailHistoryController());

  @override
  Widget build(BuildContext context) {
    final res = Get.arguments;
    controller.setData(res);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Hasil Klasifikasi')),
        body: Obx(
          () => controller.history.value == null
              ? Container(
                  width: double.infinity,
                  height: 200, // bisa disesuaikan
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(), // loading spinner
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(),
                      controller.isIdentified()
                          ? _buildTopPredictionSection()
                          : _buildTopPredictionSectionNotIdentified(),
                      controller.isIdentified()
                          ? _buildDescription(controller.history.value!)
                          : _buildDescriptionNotIdentified(),
                      AppGap.v(20),
                      controller.isIdentified()
                          ? _buildOtherPredictionsSection(
                              controller.history.value!)
                          : _buildOtherPredictionsSectionNotIdentified(),
                      AppGap.v(24),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 250,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(controller.history.value!.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTopPredictionSectionNotIdentified() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Can't Be Identified",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTopPredictionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            controller.history.value!.label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'Tingkat Kepercayaan: ${(controller.history.value!.prediction[0]['confidence']).toString()}%',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(History history) {
    final prediction = history.prediction[0]; // skip index 0
    final int labelIndex = prediction['labelIndex'];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        "${Constant.FILOSOFI[labelIndex]}",
        style: GoogleFonts.poppins(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildDescriptionNotIdentified() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        "Batik tidak dapat diidentifikasi. Kemungkinan data batik belum tersedia atau gambar yang dimasukkan terlalu abstract untuk dikenali.",
        style: GoogleFonts.poppins(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildOtherPredictionsSection(History history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Prediksi Lainnya',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: history.prediction.length - 1,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (context, index) {
              final prediction = history.prediction[index + 1]; // skip index 0
              final int labelIndex = prediction['labelIndex'];
              final String label =
                  Constant.LABEL[labelIndex] ?? "Tidak diketahui";

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Image.asset(
                          Constant.PathImageBatik[labelIndex]!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${(prediction['confidence']).toString()}%',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOtherPredictionsSectionNotIdentified() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Kemungkinan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: controller.history.value!.prediction.length,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (context, index) {
              final prediction = controller.history.value!.prediction[index];
              final int labelIndex = prediction['labelIndex'];
              final String label =
                  Constant.LABEL[labelIndex] ?? "Tidak diketahui";

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Image.asset(
                          Constant.PathImageBatik[labelIndex]!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${(prediction['confidence']).toString()}%',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
