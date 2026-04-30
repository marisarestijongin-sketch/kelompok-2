import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class PaymentSuccessfulScreen extends StatefulWidget {
  const PaymentSuccessfulScreen({super.key});

  @override
  State<PaymentSuccessfulScreen> createState() =>
      _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState
    extends State<PaymentSuccessfulScreen> {

  String amount = "-";
  String method = "-";
  String transactionId = "-";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  /// 🔥 AMBIL DATA DARI API (SUDAH FIX)
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok2/payment-successful",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        /// ✅ FIX DI SINI (AMBIL DARI data['data'])
        setState(() {
          amount = "Rp ${data['data']['amount']}";
          method = data['data']['payment_method'];
          transactionId = data['data']['id'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(),

                /// ✅ Illustration
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: SvgPicture.string(
                          paymentSuccessIllistration,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.check,
                            color: Colors.white, size: 30),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                /// 🔹 Title
                Text(
                  "Payment Successful",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Your transaction has been completed successfully.",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                /// 💳 CARD DINAMIS DARI API
                isLoading
                    ? const CircularProgressIndicator()
                    : Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Amount"),
                                Text(amount),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Payment Method"),
                                Text(method),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Transaction ID"),
                                Text(transactionId),
                              ],
                            ),
                          ],
                        ),
                      ),

                const SizedBox(height: 30),

                /// 🔹 BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Tracking belum tersedia"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Track Order"),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    },
                    child: const Text("Back to Home"),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// SVG DUMMY
const paymentSuccessIllistration = '''
<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <circle cx="100" cy="100" r="80" fill="#E8F5E9"/>
</svg>
''';