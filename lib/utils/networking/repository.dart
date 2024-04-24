
import 'package:demo/utils/app_utils.dart';
import 'package:dio/dio.dart';

import '../../model/pixabay_response_model.dart';

class Repository {
  final dio = Dio();

  Future<dynamic> listOfImagesUsingDio(Map<String, dynamic> map, {bool isLoading = true}) async {
    bool isNetworkAvailable = await AppUtils().checkConnectivity();
    if (isNetworkAvailable) {
      if (isLoading) {
        AppUtils().showProgressDialog();
      }
      Uri uri = Uri.parse("https://pixabay.com/api").replace(queryParameters: map);
      try {
        Response response = await dio.get(uri.toString());
        if (response.statusCode == 200) {
          if (isLoading) {
            AppUtils().hideProgressDialog();
          }
          Map<String, dynamic> data = response.data;
          return PixabayResponseModel.fromJson(data);
        } else {
          if (isLoading) {
            AppUtils().hideProgressDialog();
          }
          return response;
        }
      } catch (e) {
        if (isLoading) {
          AppUtils().hideProgressDialog();
        }
        AppUtils().snackBarMessage(e.toString(), title: "Dio Error");
        return e.toString();
      }
    } else {
      if (isLoading) {
        AppUtils().hideProgressDialog();
      }
    }
    return {};
  }
}
