import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

/// ===============================
/// 🔵 MAIN SCREEN (PROCESSING) api kredit card
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

  /// 🔥 HIT API LANGSUNG
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              /// ✅ TAMBAHAN: BACKGROUND GRADIENT
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE8F5E9), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              /// 🔵 CODING ASLI (TIDAK DIUBAH)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Spacer(),

                    /// 🔹 SVG (dummy) + ANIMASI TAMBAHAN
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0.9, end: 1),
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: child,
                            );
                          },
                          child: SvgPicture.string(
                            _dummySvg,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "Processing Payment...",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Please wait while we confirm your transaction.\nDo not close this page.",
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    /// 🔄 TAMBAHAN STYLE LOADING
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(strokeWidth: 4),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ],
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

              /// ✅ TAMBAHAN: CARD (TIDAK MENGHAPUS KODE LAMA)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 100),
                    const SizedBox(height: 20),
                    const Text(
                      "Payment Success 🎉",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    Text("Card Number: $number"),
                    Text("Name: $name"),
                    Text("Valid Thru: $valid"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back"),
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

              /// ✅ TAMBAHAN: CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cancel, color: Colors.red, size: 100),
                    const SizedBox(height: 20),
                    const Text(
                      "Payment Failed ❌",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Try Again"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// 🔹 SVG DUMMY (BIAR GA ERROR)
/// ===============================
const String _dummySvg = '''
<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <circle cx="100" cy="100" r="80" fill="#4CAF50"/>
</svg>
''';