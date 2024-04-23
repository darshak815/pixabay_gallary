import 'api_error_model.dart';

class ApiResponseModel {
  dynamic data;
  ApiErrorModel? error;

  ApiResponseModel({
    this.data,
    this.error,
  });
}
