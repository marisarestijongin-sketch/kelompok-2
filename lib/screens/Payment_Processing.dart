import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

/// ===============================
/// 🔵 MAIN SCREEN (PROCESSING)
/// ===============================
class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key});

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState
    extends State<PaymentProcessingScreen> {
  @override
  void initState() {
    super.initState();
    _processPayment();
  }

  Future<void> _processPayment() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok2/user/credit-card',
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final data = jsonData['data'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentSuccessScreen(
                number: data['number'],
                name: data['name'],
                valid: data['valid'],
              ),
            ),
          );
        } else {
          throw Exception(jsonData['message']);
        }
      } else {
        throw Exception("Error ${response.statusCode}");
      }
    } catch (e) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentFailedScreen(
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8F5E9), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Spacer(),

                  /// 🔵 ANIMASI MODERN
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: 0.8 + (0.2 * value),
                          child: child,
                        ),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: SvgPicture.string(_dummySvg),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    "Processing Payment",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "We are securely confirming your transaction.\nThis won’t take long.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 🔄 LOADING
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor:
                          AlwaysStoppedAnimation(Colors.green.shade600),
                      backgroundColor: Colors.green.shade100,
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// 🟢 SUCCESS SCREEN
/// ===============================
class PaymentSuccessScreen extends StatelessWidget {
  final String number;
  final String name;
  final String valid;

  const PaymentSuccessScreen({
    super.key,
    required this.number,
    required this.name,
    required this.valid,
  });

  Widget _infoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade200,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.white, size: 90),
                    const SizedBox(height: 20),
                    const Text(
                      "Payment Successful",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _infoItem("Card Number", number),
                    _infoItem("Name", name),
                    _infoItem("Valid Thru", valid),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Done"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// 🔴 FAILED SCREEN
/// ===============================
class PaymentFailedScreen extends StatelessWidget {
  final String errorMessage;

  const PaymentFailedScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 12)
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.red.shade400, size: 90),
                    const SizedBox(height: 20),
                    const Text(
                      "Payment Failed",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Try Again"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// 🔹 SVG DUMMY
/// ===============================
const String _dummySvg = '''
<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <circle cx="100" cy="100" r="80" fill="#4CAF50"/>
</svg>
''';