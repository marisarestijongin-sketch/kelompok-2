// import 'package:http/http.dart' as http;
// import '../models/api_model.dart';

// class ApiService {
//   static Future<ApiModel> getData() async {
//     final response = await http.get(
//       Uri.parse(
//         'https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok2/check',
//       ),
//     );

//     if (response.statusCode == 200) {
//       return ApiModel(
//         status: "success",
//         message: "OK",
//         title: response.body,
//       );
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
// }

// /// 🔥 GANTI NAMA CLASS (INI YANG PENTING)
// class PaymentSuccessService {
//   static Future<ApiModel> getData() async {
//     final response = await http.get(
//       Uri.parse(
//         'https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok2/payment-successful',
//       ),
//     );    

//     if (response.statusCode == 200) {
//       return ApiModel(
//         status: "success",
//         message: "OK",
//         title: response.body,
//       );
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
// }

// class CreditCardService {
//   static Future<ApiModel> getData() async {
//     final response = await http.get(
//       Uri.parse(
//         'https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok2/user/credit-card',
//       ),
//     );

//     if (response.statusCode == 200) {
//       return apiModelFromJson(response.body); // ✅ parsing JSON
//     } else {
//       throw Exception('Failed to load credit card data');
//     }
//   }
// } 