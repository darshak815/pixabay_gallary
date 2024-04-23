import 'package:demo/screen/detail/bindings/detail_bindings.dart';
import 'package:demo/screen/detail/detail_screen.dart';
import 'package:demo/screen/home/bindings/home_bindings.dart';
import 'package:get/get.dart';

import '../screen/home/home_screen.dart';

class AppPages {
  static const initial = "/home";
  static const detail = "/detail";
  static final routes = [
    GetPage(
      name: initial,
      page: () => const HomeScreen(),
      binding: HomeBindings(),
      children: [
        GetPage(
          name: detail,
          page: () => const DetailScreen(),
          binding: DetailBindings(),
        ),
      ],
    ),
  ];
}
