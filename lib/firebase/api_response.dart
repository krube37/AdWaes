/// response of each api, will be one of [ApiResponse.success()], [ApiResponse.error()]
/// [T] - contains response data or error details if api succeeds or fails respectively
class ApiResponse<T> {
  bool status;
  T? data;
  String? errorMessage;

  ApiResponse.success({this.data}) : status = true;

  ApiResponse.error({this.errorMessage}) : status = false;
}
