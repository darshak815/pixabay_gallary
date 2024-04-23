import 'dart:convert';

import 'package:demo/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:http_request_handler/request_handler_controller.dart';
import 'package:http/http.dart' as http;

import '../../model/pixabay_response_model.dart';
import 'expired_token_retry_policy.dart';
import 'logging_interceptor.dart';

class Repository {
  static final Repository _repository = Repository._internal();
  RequestHandlerController? _requestController;

  Repository._internal();

  factory Repository({
    required BuildContext context,
  }) {
    _repository._requestController = RequestHandlerController(
      interceptors: [LoggingInterceptor()],
      retryPolicy: ExpiredTokenRetryPolicy(context),
    );
    return _repository;
  }

  Future<dynamic> listOfImages(Map<String, dynamic> map, {bool isLoading = true}) async {
    bool isNetworkAvailable = await AppUtils().checkConnectivity();
    if (isNetworkAvailable) {
      if (isLoading) {
        AppUtils().showProgressDialog();
      }
      Uri uri = Uri.parse("https://pixabay.com/api").replace(queryParameters: map);
      final response = await _requestController!.getRequest(requestUrl: uri);

      if (response is http.Response) {
        if (response.statusCode == 200) {
          if (isLoading) {
            AppUtils().hideProgressDialog();
          }
          Map<String, dynamic> data = json.decode(response.body);
          return PixabayResponseModel.fromJson(data);
        } else {
          if (isLoading) {
            AppUtils().hideProgressDialog();
          }
          return response;
        }
      }
    } else {
      if (isLoading) {
        AppUtils().hideProgressDialog();
      }
    }
    return {};
  }
}
