import 'package:ambathik/app/data/models/save_model_info.dart';
import 'package:ambathik/app/data/services/classification_service.dart';
import 'package:ambathik/app/data/services/database_helper.dart';
import 'package:ambathik/app/data/services/preference_service.dart';
import 'package:ambathik/app/modules/guide_page/guide_binding.dart';
import 'package:ambathik/app/modules/guide_page/guide_view.dart';
import 'package:ambathik/app/modules/home_page/home_binding.dart';
import 'package:ambathik/app/modules/home_page/home_view.dart';
import 'package:ambathik/app/modules/main_menu/main_menu_binding.dart';
import 'package:ambathik/app/modules/main_menu/main_menu_page.dart';
import 'package:ambathik/app/routes/app_pages.dart';
import 'package:ambathik/app/shared/utils/path_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database; // Inisialisasi dan pastikan DB dibuat
  SavedModelInfo? savedModelInfo = await PreferenceService.getModelInfo();
  if(savedModelInfo == null){
    TFLiteService().changeModel(PathModel.INCEPTIONV3, 'InceptionV3');
  }else{
    TFLiteService().changeModel(savedModelInfo.path, savedModelInfo.label);
  }
  await GoogleFonts.pendingFonts();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ambathik',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      getPages: AppPages.routes,
      initialBinding: GuideBinding(),
      home: GuideView(),
    );
  }
}
