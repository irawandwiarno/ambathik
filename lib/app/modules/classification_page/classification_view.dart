import 'dart:io';

import 'package:ambathik/app/modules/classification_page/classification_controller.dart';
import 'package:ambathik/app/shared/utils/app_gap.dart';
import 'package:ambathik/app/shared/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassificationView extends StatelessWidget {
  ClassificationView({super.key});

  final controller = Get.put(ClassificationController());

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    final List<dynamic> result = arg['prediction'];
    controller.setData(imageFile: arg['image'], result: arg['prediction']);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Hasil Klasifikasi')),
        body: buildSingleChildScrollView(result),
      ),
    );
  }

  Widget buildSingleChildScrollView(List<dynamic> result) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            _buildTopPredictionSection(),
            _buildDescription(),
            AppGap.v(20),
            _buildOtherPredictionsSection(result),
            AppGap.v(24),
          ],
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
          File(controller.image.path),
          fit: BoxFit.cover,
        ),
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
            controller.topLabel,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'Tingkat Kepercayaan: ${(controller.topConfidence * 100).toStringAsFixed(2)}%',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        "${Constant.FILOSOFI[controller.topIndex]}",
        style: GoogleFonts.poppins(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildOtherPredictionsSection(List<dynamic> result) {
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
            itemCount: result.length > 5 ? 4 : result.length - 1,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (context, index) {
              final prediction = result[index + 1]; // skip index 0
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
                        child: Image.asset(Constant.PathImageBatik[labelIndex]!,
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
                              '${(prediction['confidence'] * 100).toStringAsFixed(2)}%',
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
