import 'package:ambathik/app/config/app_colors.dart';
import 'package:ambathik/app/config/app_text_style.dart';
import 'package:ambathik/app/shared/utils/app_gap.dart';
import 'package:ambathik/app/shared/utils/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget untuk halaman di dalam carousel
class AmbathikPages extends StatelessWidget {
  const AmbathikPages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.background,
         child: Column(
           children: [
             AppGap.flex,
             Image.asset('assets/images/welcome-one.jpeg')
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
                'Ambathik',
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
                width: Get.width / 1.4,
                child: Text(
                  'Discover the artisty of batik with ease. Ambathik recognizes every intricate detail, bringing culture to your fingertips',
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
