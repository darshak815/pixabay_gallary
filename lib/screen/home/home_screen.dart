import 'package:demo/route/app_pages.dart';
import 'package:demo/screen/home/controller/home_controller.dart';
import 'package:demo/utils/app_colors.dart';
import 'package:demo/utils/app_utils.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/pixabay_response_model.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pixabay Gallery"),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AppUtils().launchAnyUrl("https://github.com/darshak815/pixabay_gallary");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Source Code",
                style: TextStyle(
                  color: colorBlue,
                  decoration: TextDecoration.underline,
                  decorationColor: colorBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constrain) {
          return Obx(
            () => Column(
              children: [
                if (controller.listImages.isNotEmpty && controller.isInternet.isTrue)
                  Expanded(
                      child: GridView.builder(
                          itemCount: controller.listImages.length,
                          controller: controller.scrollController,
                          scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (constrain.maxWidth < 575)
                                ? 2
                                : (constrain.maxWidth < 775)
                                    ? 3
                                    : (constrain.maxWidth < 1077)
                                        ? 4
                                        : 5,
                            childAspectRatio: 1.5,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            Hits modelHits = controller.listImages[index];
                            int number = AppUtils().randomNumberGenerate(number: modelHits.id ?? 100);
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed('${AppPages.initial}${AppPages.detail}',
                                    arguments: modelHits, parameters: {'refId': '$number', "data": modelHits.webformatURL ?? ''});
                              },
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  fit: StackFit.expand,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Hero(
                                      /// for animation purpose hero widget used
                                      tag: 'image_full_$number',
                                      child: FastCachedImage(
                                        url: modelHits.webformatURL ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        color: colorWhite,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Wrap(
                                                children: [
                                                  const Icon(
                                                    Icons.thumb_up,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text('${modelHits.likes ?? 0}', maxLines: 1, overflow: TextOverflow.ellipsis),
                                                ],
                                              ),
                                            )),
                                            const SizedBox(width: 10),
                                            Expanded(
                                                child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Wrap(
                                                alignment: WrapAlignment.end,
                                                children: [
                                                  const Icon(
                                                    Icons.remove_red_eye,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '${modelHits.views ?? 0}',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                if (controller.isInternet.isFalse && controller.listImages.isEmpty)
                  Expanded(
                      child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(noInternetMessage),
                        MaterialButton(
                          onPressed: () {
                            controller.fetchImages(page: '${controller.page}');
                          },
                          color: Colors.greenAccent,
                          child: const Text("Try Again"),
                        ),
                      ],
                    ),
                  )),
                if (controller.page == 1 && controller.listImages.isEmpty)
                  const Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.green,
                      )),
                    ),
                  ),
                if (controller.isMore.isTrue)
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator(color: colorBlue)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
