import 'package:ambathik/app/config/app_colors.dart';
import 'package:ambathik/app/config/app_text_style.dart';
import 'package:ambathik/app/shared/utils/app_gap.dart';
import 'package:ambathik/app/shared/utils/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget untuk halaman di dalam carousel
class AdvanceUsingPage extends StatelessWidget {
  const AdvanceUsingPage({
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
              Image.asset('assets/images/welcome-two.jpeg')
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
                'Advanced Usage',
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
                  'Are your familiar with ML models?\nExplore advanced options to customize model setting for accurate and rapid identifications',
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
