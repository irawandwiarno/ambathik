import 'package:ambathik/app/data/models/history.dart';
import 'package:get/get.dart';


class DetailHistoryController extends GetxController {
  final history = Rxn<History>();

  void setData(History? res)async {
    history.value = res;
  }

  bool isIdentified(){
    if(history.value == null) return false;
    return history.value!.isIdentified!;
  }

}
