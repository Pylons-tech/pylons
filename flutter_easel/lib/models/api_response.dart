class ApiResponse<T> {
  T? data;
  String? errorMessage;
  Status status;

  ApiResponse.error({required this.errorMessage}) : status = Status.error;

  ApiResponse.success({required this.data}) : status = Status.success;
}

enum Status { error, success }
