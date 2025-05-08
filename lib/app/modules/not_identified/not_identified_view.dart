import 'dart:io';

import 'package:ambathik/app/data/models/history.dart';
import 'package:ambathik/app/modules/not_identified/not_identified_controller.dart';
import 'package:ambathik/app/shared/utils/app_gap.dart';
import 'package:ambathik/app/shared/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotIdentifiedView extends StatelessWidget {
  NotIdentifiedView({super.key});

  final controller = Get.put(NotIdentifiedController());

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    controller.setData(imageFile: arg['image'], result: arg['prediction']);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: const Text('Hasil Klasifikasi')),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                _buildTopPredictionSection(),
                _buildDescription(),
                AppGap.v(20),
                _buildOtherPredictionsSection(),
                AppGap.v(24),
              ],
            ),
          )),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Can't Be Identified",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        "Batik tidak dapat diidentifikasi. Kemungkinan data batik belum tersedia atau gambar yang dimasukkan terlalu abstract untuk dikenali.",
        style: GoogleFonts.poppins(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildOtherPredictionsSection() {
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
            itemCount: controller.prediction.length,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (context, index) {
              final prediction = controller.prediction[index];
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
