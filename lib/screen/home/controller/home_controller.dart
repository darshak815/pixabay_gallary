import 'package:demo/utils/app_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/pixabay_response_model.dart';
import '../../../utils/networking/repository.dart';

String noInternetMessage = "No internet connection found.!! please try again...";

class HomeController extends GetxController {
  RxList<Hits> listImages = <Hits>[].obs;
  RxBool isInternet = true.obs; // Used for ui renderer if internet connection not found
  RxBool isMore = false.obs; // Used for check using scrollbar fetch more data or not
  ScrollController scrollController = ScrollController(); // Scroll controller attach with gridview
  num page = 1; // current page
  String totalCount = "0";
  final dio = Dio();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    /// First time fetch data from API
    fetchImages();
    scrollListen();
  }

  /// Load more data from API
  scrollListen() {
    /// Scroll listener setup
    scrollController.addListener(() {
      if (scrollController.hasClients && scrollController.position.pixels == (scrollController.position.maxScrollExtent)) {
        // Bottom position
        if (isMore.isFalse) {
          if (totalCount == '${listImages.length}') {
            AppUtils().snackBarMessage("You're at end of the page.", title: "Oops!");
          } else {
            page += 1;
            isMore = true.obs;
            fetchImages(page: '$page', isLoading: false);
          }
        }
      }
    });
  }

  /// API called for fetch list of images from Pixabay API
  fetchImages({String page = "1", String perPage = "30", bool isLoading = true}) async {
    var modelResponse = await Repository().listOfImagesUsingDio({
      "key": "43539926-c7b65b11ef86f29105ffcb7d0",
      "q": "yellow flowers",
      "image_type": "photo",
      "page": page,
      "per_page": perPage,
      "pretty": "true",
    }, isLoading: isLoading);

    if (modelResponse is PixabayResponseModel) {
      /// Here, HTTP success response handle
      isInternet = true.obs;
      PixabayResponseModel model = modelResponse;
      if (model.hits != null) {
        isMore = false.obs;
        if (page == "1") {
          totalCount = '${model.total ?? 0}';
        } else {
          AppUtils().snackBarMessage("Data loaded successfully", title: "Success");
        }
        listImages.addAll(model.hits ?? []);
      }
    } else if (modelResponse is String) {
      /// Here, HTTP error response handle
      String errorMessage = modelResponse;
      isInternet = true.obs;
      AppUtils().snackBarMessage(errorMessage, title: "API Error");
    } else {
      /// Here, Something wrong (No Network Available)
      if (listImages.isEmpty) {
        isInternet = false.obs;
      } else {
        // Alert message show for no internet connection because list available but in new request internet not available
        AppUtils().snackBarMessage(noInternetMessage, title: "No Network");
      }
    }
  }
}
