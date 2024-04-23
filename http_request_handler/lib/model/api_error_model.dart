import 'package:flutter/cupertino.dart';

class ApiErrorModel {
  int? statusCode;
  String? message;
  Widget? errorView;

  ApiErrorModel({
    this.statusCode,
    this.message,
    this.errorView,
  });
}
