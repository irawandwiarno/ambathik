import 'package:ambathik/app/data/models/NewItem.dart';
import 'package:ambathik/app/data/models/history.dart';
import 'package:ambathik/app/data/services/database_helper.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController{

  PersistentTabController controllerNavBar = PersistentTabController(initialIndex: 0);

  // List berisi URL image carousel
  final RxList<NewsItem> news = <NewsItem>[
    NewsItem(
      imgPath: "assets/berita/1.png",
      linkDirect: "https://kumparan.com/sejarah-dan-sosial/sejarah-batik-indonesia-lengkap-beserta-perkembangannya-22NY8AtEu6J",
    ),
    NewsItem(
      imgPath: "assets/berita/2.png",
      linkDirect: "https://www.educastudio.com/news/asyik-variasi-kegiatan-belajar-pengenalan-batik-untuk-anak-paud-usia-5-6-tahun-spesial-peringatan-hari-batik",
    ),
    NewsItem(
      imgPath: "assets/berita/3.png",
      linkDirect: "https://batikgiriloyo.id/blog/sejarah-batik-di-indonesia-tradisi-evolusi-dan-warisan-budaya",
    ),
    NewsItem(
      imgPath: "assets/berita/4.png",
      linkDirect: "https://www.detik.com/sulsel/berita/d-7567933/10-acara-hari-batik-di-sekolah-yang-edukatif-dan-menyenangkan",
    ),
  ].obs;

  // List history item (image URL), bisa kosong
  final RxList<History> historyImages = <History>[].obs;


  @override
  void onInit() {
    // TODO: implement onInit
    getHistory();
    super.onInit();
  }

  Future<void> _launchURL(targetUrl) async {
    final Uri uri = Uri.parse(targetUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $targetUrl';
    }
  }

  void getHistory()async{
    var result = await DatabaseHelper().getAllHistory();
     historyImages.assignAll(result);
     print("sukses get history");
  }
}