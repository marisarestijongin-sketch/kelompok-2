class ApiModel {
  final bool? status;
  final String? message;
  final dynamic data;

  ApiModel({
    this.status,
    this.message,
    this.data,
  });

  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}