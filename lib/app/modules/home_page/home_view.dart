import 'dart:io';

import 'package:ambathik/app/data/models/history.dart';
import 'package:ambathik/app/data/services/database_helper.dart';
import 'package:ambathik/app/modules/detail_history/detail_history_view.dart';
import 'package:ambathik/app/modules/home_page/home_controller.dart';
import 'package:ambathik/app/shared/utils/app_gap.dart';
import 'package:ambathik/app/shared/utils/app_spacing.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  var controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildWelcomeSection(),
            AppGap.v30,
            buildNewsSection(),
            AppGap.v30,
            buildHistorySection(),
          ],
        ),
      ),
    );
  }

  /// SECTION: Berita Batik
  Widget buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Berita Batik",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        buildNewsCarousel(),
      ],
    );
  }

  Widget buildNewsCarousel() {
    return Obx(() {
      final news = controller.newsImages;

      if (news.isEmpty) {
        return const SizedBox(
          height: 180,
          child: Center(
            child: Text(
              "Tidak ada news",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }

      return CarouselSlider(
        options: CarouselOptions(
          height: 180.0,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.8,
        ),
        items: news.map((url) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image)),
            ),
          );
        }).toList(),
      );
    });
  }

  /// SECTION: Riwayat Klasifikasi
  Widget buildHistorySection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Riwayat Klasifikasi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: buildHistoryGrid()),
        ],
      ),
    );
  }

  Widget buildHistoryGrid() {
    return Obx(() {
      final history = controller.historyImages;

      if (history.isEmpty) {
        return const Center(
          child: Text(
            "Tidak ada history",
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      return GridView.builder(
        itemCount: history.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              History? res =
                  await DatabaseHelper().getHistoryById(history[index].id!);
              Get.to(DetailHistoryView(), arguments: res);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Image.file(
                    File(history[index].imagePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            history[index].label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            history[index].modelName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // Method untuk bagian "Selamat Datang"
  Widget buildWelcomeSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat datang!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          'Temukan sejarah dan makna batik di sekitarmu.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}
