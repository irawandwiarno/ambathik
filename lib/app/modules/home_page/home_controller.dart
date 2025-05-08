import 'package:ambathik/app/data/models/history.dart';
import 'package:ambathik/app/data/services/database_helper.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeController extends GetxController{

  PersistentTabController controllerNavBar = PersistentTabController(initialIndex: 0);

  // List berisi URL image carousel
  final List<String> newsImages = <String>[
    "assets/source-batik/gajah oling/30.jpeg",
    "assets/source-batik/gastro rinonce/19.jpg"
  ].obs;

  // List history item (image URL), bisa kosong
  final RxList<History> historyImages = <History>[].obs;


  @override
  void onInit() {
    // TODO: implement onInit
    getHistory();
    super.onInit();
  }

  void getHistory()async{
    var result = await DatabaseHelper().getAllHistory();
     historyImages.assignAll(result);
     print("sukses get history");
  }
}