import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_model.dart';

class ApiService {
  static const String url =
      "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok2/check";

  static Future<ApiModel> getData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return ApiModel.fromJson(jsonData);
    } else {
      throw Exception("Gagal ambil data: ${response.statusCode}");
    }
  }
}