import 'package:ambathik/app/config/app_colors.dart';
import 'package:ambathik/app/shared/utils/app_gap.dart';
import 'package:ambathik/app/shared/utils/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget untuk halaman di dalam carousel
class HowToUsePage extends StatelessWidget {
  const HowToUsePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color(0xFFFDF3F2),
          child: Column(
            children: [
              AppGap.flex,
              Image.asset('assets/images/welcome-three.jpeg')
            ],
          ),
        ),
        Container(
          padding: 20.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppGap.v(80),
              Text(
                'How To Use',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'Batik Recognizer',
                style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 32,
                    fontWeight: FontWeight.w400),
              ),
              AppGap.v20,
              Container(
                width: Get.width / 1.2,
                child: Text(
                  '1. Open the Ambathik App.\n'
                  '2. Capture an image of the batik pattern you want to indentify using your device\'s camera.\n'
                  '3. Wait for image recognition process to complete.\n'
                  '4. View the indetified batik patterns and their details.',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  softWrap: true,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
