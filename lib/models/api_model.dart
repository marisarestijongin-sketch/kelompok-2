import 'dart:convert';

ApiModel apiModelFromJson(String str) =>
    ApiModel.fromJson(json.decode(str));

class ApiModel {
  final String status;
  final String message;
  final String title;

  ApiModel({
    required this.status,
    required this.message,
    required this.title,
  });

  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      status: json['status'] ?? "",
      message: json['message'] ?? "",
      title: json['data']?['title'] ?? "No Title",
    );
  }
}