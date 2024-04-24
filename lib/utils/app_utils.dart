import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../route/locator.dart';
import '../route/navigation_service.dart';
import 'app_colors.dart';
import 'dart:math';

class AppUtils {
  Future<void> showProgressDialog() {
    return showDialog(
      context: locator<NavigationService>().navigatorKey.currentContext ?? Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              color: colorTransparent,
              width: 80,
              height: 80,
              child: Wrap(
                children: [
                  Card(
                    color: colorBlueRoyal,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Wrap(
                        children: [
                          const SizedBox(height: 5),
                          SpinKitFadingCircle(
                            color: colorWhite,
                            size: 50.0,
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  hideProgressDialog() {
    Navigator.pop(locator<NavigationService>().navigatorKey.currentContext ?? Get.context!);
  }

  Future<bool> checkConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final List<ConnectivityResult> result = await Connectivity().checkConnectivity();
      if (!result.contains(ConnectivityResult.none)) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      debugPrint("NETWORK MESSAGE->${e.message}");
      return false;
    }
  }

  snackBarMessage(String message, {String title = "Oops!"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: colorBlue,
      colorText: colorWhite
    );
  }

  Future<void> launchAnyUrl(String url) async {
    launchUrl(Uri.parse(url));
  }

  int randomNumberGenerate({int number = 100}) {
    Random random = Random();
    int randomNumber = random.nextInt(number);
    return randomNumber;
  }
}
