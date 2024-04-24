import 'package:demo/route/app_pages.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/detail_controller.dart';

class DetailScreen extends GetView<DetailController> {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        centerTitle: false,
        leading: GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                /// user can back without refresh detail screen
                Get.back();
              } else {
                /// If user click on refresh web page then current screen remove and start from scratch
                Get.offAllNamed(AppPages.initial);
              }
            },
            child: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Hero(
                    /// for animation purpose hero widget used
                    flightShuttleBuilder: (context, anim, direction, fromContext, toContext) {
                      final Widget toHero = toContext.widget;
                      if (direction == HeroFlightDirection.pop) {
                        return FadeTransition(
                          opacity: const AlwaysStoppedAnimation(1),
                          child: toHero,
                        );
                      } else {
                        // return toHero;
                        return FadeTransition(opacity: const AlwaysStoppedAnimation(0), child: toHero);
                      }
                    },
                    tag: 'image_full_${controller.idUnique}',
                    child: FastCachedImage(url: controller.imageUrl.value),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
