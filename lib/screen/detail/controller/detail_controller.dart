import 'package:get/get.dart';

class DetailController extends GetxController {
  RxString imageUrl = "".obs;
  String idUnique = "0";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // Data get from parameter because if user click refresh in detail screen so same data show in screen
    var data = Get.parameters;
    idUnique = data['refId'] ?? '0';
    imageUrl.value = data['data'] ?? '';
  }
}
