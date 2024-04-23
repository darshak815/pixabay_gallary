import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  BuildContext context;

  @override
  final int maxRetryAttempts = 2;

  ExpiredTokenRetryPolicy(this.context);

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    if (response.statusCode == 401) {
      return true;
    }
    return false;
  }
}
