import 'package:ambathik/app/config/app_colors.dart';
import 'package:ambathik/app/config/app_text_style.dart';
import 'package:ambathik/app/shared/utils/app_gap.dart';
import 'package:ambathik/app/shared/utils/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget untuk halaman di dalam carousel
class ContactUsPage extends StatelessWidget {
  const ContactUsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
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
                'Contact Us',
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
                  'Contact with us directly! React out via email or phone to get in touch and share you thoughts',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  softWrap: true,
                ),
              ),
              AppGap.v30,
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.mail),
                  AppGap.h10,
                  Text('irawandwiarnop2@gmail.com')
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.phone),
                  AppGap.h10,
                  Text('+62 8573 3791 578')
                ],
              )
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC69553)
              ),
                onPressed: () {},
                child: Container(
                  width: Get.width / 1.4,
                  child: Center(child: Text('Try Identify Batik Pattern', style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),)),
                )))
      ],
    );
  }
}
