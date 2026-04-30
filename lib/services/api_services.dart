import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok2';

  static Future<dynamic> checkData() async {
    final url = Uri.parse('$baseUrl/check');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}