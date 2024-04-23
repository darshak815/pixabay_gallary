import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

import 'model/api_error_model.dart';
import 'model/api_response_model.dart';

class RequestHandlerController {
  static final RequestHandlerController _requestController = RequestHandlerController._internal();

  factory RequestHandlerController({
    required List<InterceptorContract> interceptors,
    RetryPolicy? retryPolicy,
    Widget? widgetTimeout,
  }) {
    _requestController.interceptors = interceptors;
    _requestController.retryPolicy = retryPolicy;
    // Timeout widget setup
    if (widgetTimeout != null) {
      _requestController.widgetTimeout = widgetTimeout;
    }
    return _requestController;
  }

  RequestHandlerController._internal();

  setTimeOut(Widget widgetTimeout) {
    _requestController.widgetTimeout = widgetTimeout;
  }

  List<InterceptorContract>? interceptors;
  RetryPolicy? retryPolicy;
  final int requestTimeout = 180 /*180*/;

  Widget? widgetTimeout;

  Duration requestTimeoutDuration() {
    return Duration(seconds: requestTimeout);
  }

  http.Response requestTimeoutCallBack() {
    return http.Response('Getaway Request Timeout', 408);
  }

  /// ----------- POST REQUEST  ------------
  Future<dynamic> postRequest({
    Uri? requestUrl,
    Map<String, String>? parameterBody,
    Map<String, String>? headersMap,
    String? textToBeDisplayed,
  }) async {
    Object response;
    try {
      Client client = InterceptedClient.build(
        interceptors: interceptors ?? [],
        retryPolicy: retryPolicy,
      );
      var responseApi = await client.post(requestUrl!, body: parameterBody, headers: headersMap).timeout(
        requestTimeoutDuration(),
        onTimeout: () {
          return requestTimeoutCallBack();
        },
      );
      if (responseApi.statusCode == 200) {
        response = responseApi;
      } else {
        response = await errorHandler(responseApi, null);
      }
    } on SocketException {
      ApiResponseModel responseError = ApiResponseModel();
      responseError.error = ApiErrorModel(statusCode: 0, message: "Error occurred while Communication with Server with StatusCode");
      response = responseError;
    }
    return response;
  }

  /// ----------- POST MULTIPART REQUEST  ------------
  Future<dynamic> postImageRequest(
      {Uri? requestUrl,
      Map<String, String>? parameterBody,
      Map<String, String>? headersMap,
      String? textToBeDisplayed,
      List<http.MultipartFile>? files}) async {
    Object response;
    try {
      http.MultipartRequest request = http.MultipartRequest("POST", requestUrl!);
      // http.MultipartFile multipartFile = await http.MultipartFile.fromPath('file', "");
      request.headers.addAll(headersMap ?? {});
      request.fields.addAll(parameterBody ?? {});
      request.files.addAll(files ?? []);
      var responseApi = await http.Response.fromStream(await request.send());
      if (responseApi.statusCode == 200) {
        response = responseApi;
      } else {
        response = await errorHandler(responseApi, null);
      }
    } on SocketException {
      ApiResponseModel responseError = ApiResponseModel();
      responseError.error = ApiErrorModel(statusCode: 0, message: "Error occurred while Communication with Server with StatusCode");
      response = responseError;
    }
    return response;
  }

  /// ----------- GET REQUEST -----------
  Future<dynamic> getRequest({
    Uri? requestUrl,
    Map<String, String>? headersMap,
  }) async {
    Object response;
    try {
      Client client = InterceptedClient.build(
        interceptors: interceptors ?? [],
        retryPolicy: retryPolicy,
      );
      Response responseHttp = await client.get(requestUrl!, headers: headersMap).timeout(requestTimeoutDuration(), onTimeout: () {
        return requestTimeoutCallBack();
      });
      if (responseHttp.statusCode == 200) {
        response = responseHttp;
      } else {
        response = await errorHandler(responseHttp, null);
      }
    } on SocketException {
      ApiResponseModel responseError = ApiResponseModel();
      responseError.error = ApiErrorModel(statusCode: 0, message: "Error occurred while Communication with Server with StatusCode");
      response = responseError;
    }
    return response;
  }

  Future<ApiResponseModel> errorHandler(Response response, final Function()? onTap) async {
    ApiResponseModel responseModel = ApiResponseModel();
    if (kDebugMode) {
      print("--response.statusCode->${response.request!.url}<-statusCode-> ${response.statusCode}");
    }
    switch (response.statusCode) {
      case 408:
        ApiErrorModel model = ApiErrorModel(
            statusCode: response.statusCode,
            message: response.body,
            errorView: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: widgetTimeout,
              ),
            ));
        responseModel.error = model;
        return responseModel;
      case 401:
        responseModel.error = ApiErrorModel(
          statusCode: response.statusCode,
          message: response.body,
        );
        return responseModel;
      default:
        responseModel.error = ApiErrorModel(
          statusCode: response.statusCode,
          message: response.body,
        );
        return responseModel;
    }
  }
}
